library ieee;
library work;
use ieee.std_logic_1164.all;

ENTITY execute is 
  GENERIC (n:integer :=32);
  port ( In_port,ReadD1,Read2,Mux5_out: IN std_logic_vector(n-1 downto 0);

   in_signal,Ret,flush,FlgSrc,WB_Ben,M_Ben,mux_9:in std_logic; --%%enables of the writeback buffer and memory buffer%%--

   pc:  IN std_logic_vector(n-1 downto 0);

  reg_w1_en,reg_w2_en: in std_logic ;  --%%the two enables of the write reg%%--

    Write_R1 ,write_r2,read_rs1,read_rs2: IN std_logic_vector(2 downto 0); --%%the adresses of the two registers sources and the addresses of the two destination registers%%-- 

        ALUselectors: In std_logic_vector(3 DOWNTO 0);

mux_6,spadd,mux_10,sp_en,sp_rst,mem_w,mem_r : in std_logic ;

mux_7 , mux_8: IN std_logic_vector(1 downto 0);

--RS1,RS2,EXMEMRD1,EXMEMRD2,MEMWBRD1,MEMWBRD2: In std_logic_vector(2 DOWNTO 0); --FU registers from mem & wb 

    carryin ,CLK,FlagEn,FlagReset,OutEn,OutReset: in std_logic;
--FUsig1 --> ex.mem 
--FUsig2 --> mem.wb
    mem_flag: IN std_logic_vector(3 DOWNTO 0);

------------------------------------------------------------------------------------------

     Db_out: out std_logic_vector(190 DOWNTO 0);

flagRegister: OUT std_logic_vector(3 DOWNTO 0));

  END execute;
  
  ARCHITECTURE arch1 OF execute IS
    
    Signal muxOp1,muxOp2 : std_logic_vector(1 downto 0); --FU output 

Signal  c_in,EXMEM_regW , MEMWB_regW: std_logic; --FU input signals 

Signal Rd1,Rd2,mux5o,mux8o,mux_in4: std_logic_vector(n-1 downto 0); --registers from decode

Signal  EXMEM_RD1,EXMEM_RD2,MEMWB_RD1,MEMWB_RD2 : std_logic_vector(n-1 downto 0);

Signal AluOP1,AluOP2, AluOutput,Port_Output: std_logic_vector(n-1 downto 0); --ALU operands
 
Signal Alu_s,Flag_R ,FlgSrcO:std_logic_vector(3 DOWNTO 0);

Signal Write_Reg1,Read_Reg1 :std_logic_vector(2 DOWNTO 0); -- 0 -> cout , 1->sign , 2-> zero

Signal muxSelect1,muxSelect2: std_logic_vector(1 DOWNTO 0);

signal Db_in:  std_logic_vector(190 DOWNTO 0);

signal operand_2: std_logic_vector(31 DOWNTO 0);
   

-- 2x1 MUX
   COMPONENT mux2 is 
   Generic ( n : Integer:=16);
	PORT ( in0,in1: IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic;
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
  END COMPONENT;
   --OUTPORT --
   component ccr  
  GENERIC (n:integer :=32);
  PORT (Clk,Rst,En: IN std_logic;
    d: IN std_logic_vector (n-1 DOWNTO 0);
    q: OUT std_logic_vector(n-1 DOWnTO 0));
  end component ;
  
-- 4x1 MUX
   COMPONENT mux_generic is 
   Generic ( n : Integer:=16);
	PORT ( in0,in1,in2,in3 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic_vector (1 DOWNTO 0);
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
  END COMPONENT;

  --ALU--
  component ALU2
  Generic (n:integer:=32);
PORT( A:IN std_logic_vector (n-1 DOWNTO 0);
      B:IN std_logic_vector (n-1 DOWNTO 0);
       sel: In std_logic_vector(3 DOWNTO 0);
              F:out std_logic_vector (n-1 DOWNTO 0);
cin : in std_logic;
cout,Sign,zero : out std_logic
);
end component ;

------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------
COMPONENT Funit is
 GENERIC (n: integer := 32);
  PORT ( ALUop1,ALUop2 : OUT std_logic_vector(1 downto 0);
    EX_MEM_RegWrite,MEM_WB_RegWrite : IN std_logic;
    RS1,RS2 :  IN std_logic_vector(2 downto 0);
    EX_MEM_RD1,EX_MEM_RD2,MEM_WB_RD1,MEM_WB_RD2 : IN std_logic_vector(2 downto 0) );
END COMPONENT ;

--------------------------------------------------------
 
--SIGNALS --
BEGIN
  mux_in4<=(others=>'0');
--ForwardingUnit: Funit GENERIC MAP(32) PORT MAP (muxSelect1,muxSelect2,EXMEM_regW , MEMWB_regW,Rd1,Rd2,EXMEM_RD1,EXMEM_RD2,MEMWB_RD1,MEMWB_RD2);
--  mux_one: mux_generic GENERIC MAP(32) PORT MAP (Rd1,AluOutput,WB,mux_in4,muxSelect1,AluOP1);
--   mux_two: mux_generic GENERIC MAP(32) PORT MAP (mux5o,AluOutput,WB,mux_in4,muxSelect2,AluOP2);
     --ALU & outport
     ALU: ALU2 GENERIC MAP(32) PORT MAP (ReadD1,operand_2,ALUselectors, AluOutput,carryin,flag_R(2),flag_R(1),flag_R(0));
       Out_p: ccr GENERIC MAP(32) PORT MAP (CLK,'0','1',AluOutput,Port_Output);
         FlagReg : ccr GENERIC MAP(4) PORT MAP (CLK,flagreset,flagen,FlgSrcO,flagRegister);
        mem_buff:  Buff GENERIC MAP(191) PORT MAP (Db_in,'1',flush,CLK,'0',Db_out);    
     -- MUX3
        
       mux_op2: mux2 GENERIC MAP(32) PORT MAP (Mux5_out,In_port,in_signal,operand_2);
        
     FlgM: mux2 GENERIC MAP(4) PORT MAP (mem_flag,flag_r,FlgSrc,FlgSrcO);    

    Db_in<=In_port & read_rs1 & read_rs2 & Ret & sp_en & spadd & mux_6 &  mem_w & mem_r &  mux_10 & reg_w1_en & reg_w2_en & WB_Ben  & mux_9 & mux_7 & mux_8 & Write_R1  &  write_r2 & AluOutput  & ReadD1 & Read2  & pc & flag_r ;

  --   final<= AluOutput;   
     
    
 --ReadData1<=Rd1;
--   ReadData2<=Rd2;
--   ReadReg1<=Read_Reg1;
--   WriteReg1<=Write_Reg1;
   
    End arch1;
    

