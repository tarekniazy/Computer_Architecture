library ieee;
library work;
use ieee.std_logic_1164.all;

entity mem_stage is 

PORT (
      In_port : in std_logic_vector (31 downto 0);
      CLK,Ret,flushmemory,sp_enable,sp_rst,sp_add,mux_6,mem_write,mem_read,mux_10_sel ,reg_w1_en , reg_w2_en,WB_Ben,mux_9:in std_logic;

      mux_7 , mux_8 :in std_logic_vector(1 downto 0);
      


 Write_R1 , write_r2,read_rs1,read_rs2 :in std_logic_vector (2 downto 0);

alu,read_data1,read_data2,pc_value,pc_int:in std_logic_vector (31 downto 0);

flag_reg :in std_logic_vector(3 downto 0);



B_out: out std_logic_vector(177 downto 0)
);
END mem_stage;





ARCHITECTURE struct_mem OF mem_stage IS

signal sp_val:std_logic_vector (31 downto 0);
signal address:std_logic_vector (31 downto 0);
signal couty:std_logic;
signal pc_1:std_logic_vector (31 downto 0);
signal flag_sig:std_logic_vector (31 downto 0);
signal data:std_logic_vector (31 downto 0);

signal out_mem_sig: std_logic_vector (31 downto 0);

signal b_in : std_logic_vector(177 downto 0);

------------------------------------------------------------------
component su IS
Generic (n:integer:=32);
PORT(  spadd,sp_enable,sp_rst,sp_clk,mux_10_sel:in std_logic;
       sp_val:out std_logic_vector(31 downto 0)

);
end component;

-----------------------------------------------------------------------------
   COMPONENT mux2 is 
   Generic ( n : Integer:=16);
	PORT ( in0,in1: IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic;
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
end component;
-------------------------------------------------------------------------------
COMPONENT mem_ram IS
  GENERIC (n:integer :=16);
	PORT(
		clk,mux_6 : IN std_logic;
		we,re  : IN std_logic;   
		address : IN  std_logic_vector(31 DOWNTO 0);
		datain  : IN  std_logic_vector(n-1 DOWNTO 0);
		dataout : OUT std_logic_vector(n-1 DOWNTO 0));
END COMPONENT;
-----------------------------------------------------------------------
COMPONENT mux_generic is 
   Generic ( n : Integer:=16);
	PORT ( in0,in1,in2,in3 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic_vector (1 DOWNTO 0);
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
  END COMPONENT;
---------------------------------------------------------------------
component n_adder IS

	Generic (n:integer:=32);
	PORT (a,b: IN std_logic_vector(n-1 DOWNTO 0) ;
		cin : IN std_logic;
             s: out std_logic_vector(n-1 DOWNTO 0) ;
		 cout : OUT std_logic );

END component;
--------------------------------------------------------------------
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
---------------------------------------------------------------------
begin

flag_sig<="0000000000000000000000000000"&flag_reg;

sp: su GENERIC MAP(32) PORT MAP (sp_add,sp_enable,sp_rst,CLK,mux_10_sel,sp_val);

u0: mux2 GENERIC MAP(32) PORT MAP (sp_val,alu,mux_6,address);

--u3:  n_adder   PORT MAP (pc_value,"00000000000000000000000000000001",'0',pc_1,couty);

u4: mux_generic GENERIC MAP(32) PORT MAP (pc_value,pc_int,read_data1,flag_sig,mux_7,data);

u5: mem_ram GENERIC MAP(32) PORT MAP (CLK,mux_6,mem_write,mem_read,address,data,out_mem_sig);

u6: Buff GENERIC MAP(178) PORT MAP (b_in,'1',flushmemory,CLK,'0',b_out);



b_in<=In_port & read_rs1 & read_rs2 & Ret & alu & out_mem_sig & read_data1 & read_data2 & Write_R1 & write_r2 & reg_w1_en & reg_w2_en & mux_8 & mux_9;

end struct_mem;












