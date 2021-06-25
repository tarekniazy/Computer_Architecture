Library ieee;
use ieee.std_Logic_1164.all;

ENTITY proccessor is 
  GENERIC (n:integer :=32);
  PORT ( CLK,RST,FUsig1,FUsig2,Interrupt: IN std_logic;
         INPORT : IN std_logic_vector (n-1 DOWNTO 0);
         Rs: IN std_logic);  

  END proccessor;
ARCHITECTURE a_DATA OF proccessor

  IS 
  -- Control unit    
  COMPONENT Control is 
   PORT ( Opcode : IN std_logic_vector (4 DOWNTO 0);
         CLK,Interrupt :  IN std_logic;
         Reset :  IN std_logic;
         Signals : OUT std_logic_vector (0 TO 38);
         Zf,Cf,Nf: OUT std_logic;
             ldm_in:out std_logic);
  END COMPONENT;
  ---- HAZARD DETECTION UNIT
COMPONENT HazardUnit is 
PORT ( CLK,ID_EX_MEMRead : IN std_logic; --if load use case
         IF_ID_RS1, IF_ID_RS2, ID_EX_Rs1: IN std_logic_vector (2 DOWNTO 0);   
         PCStall,FetchStall,FlushEx : OUT std_logic);
  END COMPONENT;


  -- 4x1 MUX
   COMPONENT mux_generic is 
   Generic ( n : Integer:=16);
	PORT ( in0,in1,in2,in3 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic_vector (1 DOWNTO 0);
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
   END COMPONENT;

   COMPONENT muxbit IS 
	PORT ( in0,in1,in2,in3 : IN std_logic;
		sel : IN  std_logic_vector (1 DOWNTO 0);
		out1 : OUT std_logic);
   END COMPONENT;

  -- fetch
  COMPONENT fetch is 
  PORT ( PCSrc ,CondAddr,UnCondAddr,memoryvalue : IN std_logic_vector ( 31 DOWNTO 0);
         CondJ,UncondJ,memoryin,CLK,RST,Interrupt,MX1S ,pc_stall: IN std_logic;
         PCINC,Instruction,MUX1_O: OUT std_logic_vector ( 31 DOWNTO 0));
  END COMPONENT;
  
   COMPONENT mux2 is 
   Generic ( n : Integer:=16);
	PORT ( in0,in1: IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic;
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
  END COMPONENT;
  --- REGISTER
   COMPONENT my_nDFF is 
  GENERIC (n:integer :=32);
  PORT (Clk,Rst,En: IN std_logic;
    d: IN std_logic_vector (n-1 DOWNTO 0);
    q: OUT std_logic_vector(n-1 DOWnTO 0));
  END COMPONENT;

------- Buffer
  
  COMPONENT Buff IS
 Generic (n: integer:= 16);
Port
(
input : In std_logic_vector  (n-1 downto 0);
Enable,Flush : In std_logic;
clk : In std_logic;
Reset: In std_logic;
output: Out std_logic_vector (n-1 downto 0)  -- Msh hakhod el 3 bits dool
);
END COMPONENT;

COMPONENT decode IS
  PORT ( PC,Instruction,WriteData1,WriteData2: IN std_logic_vector (31 downto 0);
         RegWrite1,RegWrite2,Mux4S,CLK : IN std_logic;    
         WA1,WA2 : IN std_logic_vector (2 DOWNTO 0)  ;       
         MUX2S,MUX5S: IN std_logic_vector (1 DOWNTO 0);
         PCOUT,ReadData1,ReadData2,Mux5O: OUT std_logic_vector (31 downto 0);
         WriteAddress1,WriteAddress2,read_rs1,read_rs2 : OUT std_logic_vector (2 DOWNTO 0) );  
END COMPONENT;

COMPONENT exe_mem is 
  GENERIC (n:integer :=32);
  port (In_port, MUX8_O,ReadD1,Read2,Mux5_out: IN std_logic_vector(n-1 downto 0);

   in_signal,Ret,FlgSrc,WB_Ben,M_Ben,mux_9 : in std_logic; --%%enables of the writeback buffer and memory buffer%%--

   pc,pc_int:  IN std_logic_vector(n-1 downto 0);

  reg_w1_en,reg_w2_en: in std_logic ;  --%%the two enables of the write reg%%--

    Write_R1 ,write_r2,read_rs1,read_rs2: IN std_logic_vector(2 downto 0); --%%the adresses of the two registers sources and the addresses of the two destination registers%%-- 

        ALUselectors: In std_logic_vector(3 DOWNTO 0);

mux_6,spadd,mux_10,sp_en,sp_rst,mem_w,mem_r : in std_logic ;

mux_7,mux_8 : IN std_logic_vector(1 downto 0);

    carryin ,CLK,FUSig1,FUSig2,FlagEn,FlagReset,OutEn,OutReset: in std_logic;
    mem_flag: IN std_logic_vector(3 DOWNTO 0);

         flag_r : out std_logic_vector(3 downto 0);

            B_out: out std_logic_vector(177 downto 0);
           jmp_add: out std_logic_vector (31 downto 0);
    ldm :in std_logic);

 END COMPONENT;
-----------------------------------------------------------

  Signal add,q1,dpc,rd1,rd2,mux5o,WData1,WData2,MUX8_O,MUX9_O,CondJ,UnCondj,PCSrcOut,MUX1_O,INvalue,JmpAdd: std_logic_vector (31 DOWNTO 0); -- Output PC (Address) -> IN ll RAM
  Signal q2,FBin: std_logic_vector (95 DOWNTO 0); -- Fetch/Decode buffer
  Signal wa1,wa2,re_rs1,re_rs2: std_logic_vector (2 DOWNTO 0); -- Fetch/Decode buffer
  Signal S : std_logic_vector (0 to 38); -- Signals (Control unit)
  Signal flagM: std_logic_vector (3 downto 0);
  Signal ExMemBOut: std_logic_vector (177 downto 0);
  Signal q3,DBIn: std_logic_vector (206 DOWNTO 0);
  Signal r,mux3Out,PCSel,FlushFetch,FlushDecode,FlushExecute: std_logic;
  Signal mux3s,pcmux: std_logic_vector (1 DOWNTO 0);
  Signal Zf,Cf,Nf,flushcond : std_logic;
  Signal stallPC :  std_logic := '0';
  Signal stallFetch : std_logic := '0';
  Signal FlushExHDU : std_logic := '0';
  signal ldm:std_logic;
  BEGIN
     
     --q2 -> output Fetch/Decode buffer ( pc -> (63 to 32) & instruction ( 31 to 0) & bit (64) ??)
     
      ---------------    ----- Fetch Stage -------------
     CondJ <= JmpAdd;
     UnCondJ <= JmpAdd;
  --   pc: mux_generic GENERIC MAP(32) PORT MAP(MUX1_O,MUX8_O,CondJ,"00000000000000000000000000000010",pcmux,PCSrcOut);
     PCSrcOut <= MUX1_O;
     fet : fetch PORT MAP (PCSrcOut,CondJ,UnCondj,MUX8_O,flushcond,q3(3),ExMemBOut(139),CLK,RST,Interrupt,S(2),stallPC,add,q1,MUX1_O);
     --q2 -> output Fetch/Decode buffer ( pc -> (63 to 32) & instruction ( 31 to 0) & bit (64) ??)
     r <= (not(RST)) or (not(stallFetch)); ---- Fetch buffer enable
     FBin <= INPORT & add &q1;
     FDB:  Buff GENERIC MAP(96) PORT MAP ( FBin,r, FlushFetch,CLK,'0',q2);
     FlushFetch <= (flushcond) or (q3(3)) or ExMemBOut(139);
-------------------------- Decode stage--------------------
     CU: Control PORT MAP (q2 (31 DOWNTO 27),CLK,'0','0',S,Zf,Cf,Nf,ldm);
     dec: decode PORT MAP (q2(63 downto 32),q2(31 downto 0),MUX9_O,ExMemBOut(42 downto 11),ExMemBOut(4),ExMemBOut(3),S(7),CLK,ExMemBOut(10 downto 8),ExMemBOut(7 downto 5),S(3 to 4),S(8 to 9),dpc,rd1,rd2,mux5o,wa1,wa2,re_rs1,re_rs2);
                   -- Regwrite1 Regwrite2: Signsls from WB
                   --WriteData1,WriteData2 : output WB
      DBIn <= ldm & Zf & Cf & Nf & S(38) & q2(95 downto 64) & re_rs1 & re_rs2 & S(37) & dpc & rd1 & rd2 & mux5o & wa1 & wa2  & S(0 to 1) & S( 5 to 6) & S(10 to 32) & S(35 to 36);
     DEB:  Buff GENERIC MAP(207) PORT MAP (DBIn,S(34),FlushDecode,CLK,'0',q3);
      FlushDecode <= (flushcond) or (q3(3)) or ExMemBOut(139) or FlushExHDU;
-------------------------Execute and Memory Stage -------------
  EXMem:  exe_mem GENERIC MAP(32) PORT MAP (q3(201 downto 170),MUX8_O,q3(130 downto 99),q3(98 downto 67),q3(66 downto 35),q3(202),q3(163),q3(8),q3(0),q3(1),q3(19),q3(162 downto 131),add,q3(13),q3(12),q3(34 downto 32),q3(31 downto 29),q3(169 downto 167),q3(166 downto 164),q3(17 downto 14),q3(24),q3(6),q3(18),q3(4),RST,q3(10),q3(11),q3(23 downto 22),q3(21 downto 20),'0',CLK,FUsig1,FUsig2,q3(9),RST,q3(7),RST,MUX8_O(3 downto 0),flagM,ExMemBOut,JmpAdd,q3(206));
       M3: muxbit PORT MAP (FlagM(0),FlagM(1),FlagM(2),'0',q3(26 downto 25),mux3Out); 
       flushcond <= (mux3Out and q3(205)) or (mux3Out and q3(204)) or (mux3Out and q3(203)) ; 
--------------------------------Write Back Stage--------------------
mux8: mux_generic GENERIC MAP(32) PORT MAP(ExMemBOut(106 downto 75),ExMemBOut(177 downto 146),ExMemBOut(138 downto 107),(OTHERS => '0'),ExMemBOut(2 downto 1),MUX8_O);
    mux9: mux2 GENERIC MAP(32) PORT MAP(MUX8_O,ExMemBOut(74 downto 43),ExMemBOut(0),MUX9_O);

--------------------------------HAZARD Detection Unit-------------------
 HDU:  HazardUnit GENERIC MAP(32) PORT MAP (CLK,q3(11),q2(26 downto 24),q2(23 downto 21),q3(169 downto 167),stallPC,stallFetch,FlushExHDU);
---------------------------------------------------------------------------------------------------------------   
    

End a_DATA;
  

