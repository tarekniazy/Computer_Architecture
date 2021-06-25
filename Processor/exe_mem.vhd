library ieee;
library work;
use ieee.std_logic_1164.all;

ENTITY exe_mem is 
  GENERIC (n:integer :=32);
  port (In_port,mux8_o, ReadD1,Read2,Mux5_out: IN std_logic_vector(n-1 downto 0);

   in_signal,Ret,FlgSrc,WB_Ben,M_Ben,mux_9 : in std_logic; --%%enables of the writeback buffer and memory buffer%%-- return RTI

   pc,pc_int:  IN std_logic_vector(n-1 downto 0);

  reg_w1_en,reg_w2_en: in std_logic ;  --%%the two enables of the write reg%%--

    Write_R1,write_r2,read_rs1,read_rs2: IN std_logic_vector(2 downto 0); --%%the adresses of the two registers sources and the addresses of the two destination registers%%-- 

        ALUselectors: In std_logic_vector(3 DOWNTO 0);

mux_6,spadd,mux_10,sp_en,sp_rst,mem_w,mem_r : in std_logic ;

mux_7,mux_8 : IN std_logic_vector(1 downto 0);



    carryin ,CLK,FUSig1,FUSig2,FlagEn,FlagReset,OutEn,OutReset: in std_logic;
    
    mem_flag: IN std_logic_vector(3 DOWNTO 0);

         flag_r : out std_logic_vector(3 downto 0);

            B_out: out std_logic_vector(177 downto 0);
  jmp_add: out std_logic_vector (31 downto 0);
   ldm :in std_logic);

 END exe_mem;

ARCHITECTURE struct_exe_mem OF exe_mem IS

signal Db_out_signal: std_logic_vector(190 DOWNTO 0);
signal B_Signal: std_logic_vector(177 DOWNTO 0);
signal flush1,mswap1,mswap2: std_logic;
-------FU SIGNALS--------------
signal muxsel1,muxsel2: std_logic_vector(1 downto 0):="00";
signal operand1,operand2,swap1,swap2 : std_logic_vector(31 downto 0);



-----------------------------------------------------------------------------------------
component  execute is 

  GENERIC (n:integer :=32);
 
 port ( In_port,ReadD1,Read2,Mux5_out: IN std_logic_vector(n-1 downto 0);

   in_signal,Ret,flush,FlgSrc,WB_Ben,M_Ben,mux_9 : in std_logic; --%%enables of the writeback buffer and memory buffer%%--

   pc:  IN std_logic_vector(n-1 downto 0);

  reg_w1_en,reg_w2_en: in std_logic ;  --%%the two enables of the write reg%%--

    Write_R1 ,write_r2,read_rs1,read_rs2: IN std_logic_vector(2 downto 0); --%%the adresses of the two registers sources and the addresses of the two destination registers%%-- 

        ALUselectors: In std_logic_vector(3 DOWNTO 0);

mux_6,spadd,mux_10,sp_en,sp_rst,mem_w,mem_r : in std_logic ;

mux_7 , mux_8: IN std_logic_vector(1 downto 0);

    carryin ,CLK,FlagEn,FlagReset,OutEn,OutReset: in std_logic;
    mem_flag: IN std_logic_vector(3 DOWNTO 0);
    

     Db_out: out std_logic_vector(190 DOWNTO 0);

flagRegister: OUT std_logic_vector(3 DOWNTO 0));

  END component ;


--------------------------------------------------------------------------------- 
component mem_stage is 

PORT (
       In_port : in std_logic_vector (31 downto 0);
       CLK,Ret,flushmemory,sp_enable,sp_rst,sp_add,mux_6,mem_write,mem_read,mux_10_sel ,reg_w1_en , reg_w2_en,WB_Ben,mux_9:in std_logic;

      mux_7 , mux_8 :in std_logic_vector(1 downto 0);
      
 Write_R1 , write_r2,read_rs1,read_rs2 :in std_logic_vector (2 downto 0);

alu,read_data1,read_data2,pc_value,pc_int:in std_logic_vector (31 downto 0);

flag_reg :in std_logic_vector(3 downto 0);

B_out: out std_logic_vector(177 downto 0) );

END component;

-------------------------------------------------------------------------------------------------------------

-- 2x1 MUX
   COMPONENT mux2 is 
   Generic ( n : Integer:=16);
	PORT ( in0,in1: IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic;
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
  END COMPONENT;

COMPONENT mux_generic is 
   Generic ( n : Integer:=16);
	PORT ( in0,in1,in2,in3 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic_vector (1 DOWNTO 0);
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
  END COMPONENT;
--------------------------------------------------
COMPONENT Funit is 
   
  GENERIC (n: integer := 32);
  PORT ( S1,S2: OUT std_logic;
     ALUop1,ALUop2 : OUT std_logic_vector(1 downto 0); --mux selectors
     ALUSEL :  IN std_logic_vector(3 downto 0);
    EX_MEM_RegWrite,MEM_WB_RegWrite,EX_MEM_RegWrite2,MEM_WB_RegWrite2 : IN std_logic;
    RS1,RS2 :  IN std_logic_vector(2 downto 0);
    EX_MEM_RD1,EX_MEM_RD2,MEM_WB_RD1,MEM_WB_RD2 : IN std_logic_vector(2 downto 0);
ldm: in std_logic );
END COMPONENT;

---------------------------------------------------------------------------
begin 

u0: execute Generic map(32) PORT MAP (In_port,operand1,Read2,operand2,in_signal,Ret,flush1,FlgSrc,WB_Ben,M_Ben,mux_9,pc,reg_w1_en,reg_w2_en,Write_R1 ,write_r2,read_rs1,read_rs2,ALUselectors,mux_6,spadd,mux_10,sp_en,sp_rst,mem_w,mem_r,mux_7,mux_8,carryin ,CLK,FlagEn,FlagReset,OutEn,OutReset,mem_flag,Db_out_signal,flag_r);
u1: mem_stage port map(Db_out_signal(190 downto 159),CLK,Db_out_signal(152),flush1,Db_out_signal(151),sp_rst,Db_out_signal(150),Db_out_signal(149),Db_out_signal(148),Db_out_signal(147),Db_out_signal(146),Db_out_signal(145),Db_out_signal(144),Db_out_signal(143),Db_out_signal(142),Db_out_signal(141 downto 140),Db_out_signal(139 downto 138),Db_out_signal(137 downto 135),Db_out_signal(134 downto 132),Db_out_signal(158 downto 156),Db_out_signal(155 downto 153),Db_out_signal(131 downto 100),Db_out_signal(99 downto 68),Db_out_signal(67 downto 36),Db_out_signal(35 downto 4),pc_int,Db_out_signal(3 downto 0),B_signal);
fu : Funit Generic map(32) PORT MAP (mswap1,mswap2,muxsel1,muxsel2,ALUselectors,Db_out_signal(145),B_signal(4),Db_out_signal(144),B_signal(3),read_rs1,read_rs2,Db_out_signal(137 downto 135),Db_out_signal(134 downto 132),B_signal(10 downto 8), B_signal(7 downto 5),ldm);
mO11: mux2 Generic map(32) PORT MAP(Db_out_signal(99 downto 68),Db_out_signal(67 downto 36),mswap1,swap1);
mOp1: mux_generic Generic map(32) PORT MAP( ReadD1,Db_out_signal(131 downto 100),mux8_o ,swap1,muxsel1,operand1);
mO12: mux2 Generic map(32) PORT MAP(Db_out_signal(99 downto 68),Db_out_signal(67 downto 36),mswap2,swap2);
mOp2: mux_generic Generic map(32) PORT MAP(Mux5_out,Db_out_signal(131 downto 100), mux8_o,swap2,muxsel2,operand2);
flush1 <= B_signal(139);
B_Out <= B_signal;
jmp_add<=operand1;
end struct_exe_mem;



--Db_out_signal(158 downto 156),Db_out_signal(155 downto 153)


--Db_out_signal(137 downto 135),Db_out_signal(134 downto 132)









