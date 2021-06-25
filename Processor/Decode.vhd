Library ieee;
use ieee.std_Logic_1164.all;
ENTITY decode is 
  PORT ( PC,Instruction,WriteData1,WriteData2: IN std_logic_vector (31 downto 0);
         RegWrite1,RegWrite2,Mux4S,CLK : IN std_logic;  
         WA1,WA2 : IN std_logic_vector (2 DOWNTO 0)  ;      
         MUX2S,MUX5S: IN std_logic_vector (1 DOWNTO 0);
         PCOUT,ReadData1,ReadData2,Mux5O: OUT std_logic_vector (31 downto 0);
         WriteAddress1,WriteAddress2,read_rs1,read_rs2 : OUT std_logic_vector (2 DOWNTO 0) 
); 
-------------------------------------------------------------------------------------
         -- Na2es Signals !
         -- ELy dakhel 3ala write1 w write2 fl regfile hayb2a eh??
         -- MUX5O: Extend Output
         -- Write Address 1 : OUTPUT OF MUX 2
         --ReadReg1 -> WriteAddress2
--ReadReg2 --> WriteAddress1
  END decode;
ARCHITECTURE a_decode OF decode
  IS 
 -- 4x1 MUX
   COMPONENT mux_generic is 
   Generic ( n : Integer:=16);
	PORT ( in0,in1,in2,in3 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic_vector (1 DOWNTO 0);
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
  END COMPONENT;
  -- 2x1 MUX
   COMPONENT mux2 is 
   Generic ( n : Integer:=16);
	PORT ( in0,in1: IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic;
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
  END COMPONENT;
  
  COMPONENT RegFile IS
 GENERIC (n:integer :=32);
  PORT ( Read1,Read2,Write1,Write2 : IN std_logic_vector(2 DOWNTO 0);
         CLK,RegWrite1,RegWrite2: IN std_logic;
         WriteData1,WriteData2: IN std_logic_vector(n-1 DOWNTO 0);
         ReadData1,ReadData2: OUT std_logic_vector(n-1 DOWNTO 0));  
END COMPONENT;

Signal M4O : std_logic_vector (3 downto 0);
Signal m5i0,m5i1,m5o,rd2: std_logic_vector (31 downto 0);
Signal w1 : std_logic_vector (2 downto 0);
BEGIN
  PCOUT <= PC;
  WriteAddress1 <= w1;
  WriteAddress2 <= Instruction (26 downto 24);
  ReadData2 <= rd2;
  m5i0 <="000000000000" & M4O & Instruction(15 downto 0);
  m5i1 <="000000000000000000000000000"& Instruction(20 downto 16);
  MUX5O <= m5o;
  m2: mux_generic GENERIC MAP(3) PORT MAP (Instruction( 23 downto 21),Instruction (26 downto 24),Instruction (20 downto 18),"000",MUX2S,w1);
  m4: mux2 GENERIC MAP(4) PORT MAP (Instruction(19 downto 16),"0000",MUX4S,M4O);
  m5: mux_generic GENERIC MAP(32) PORT MAP (m5i0,m5i1,rd2,(OTHERS => '0'),MUX5S,M5o);
  RF: RegFile GENERIC MAP(32) PORT MAP (Instruction(26 downto 24),Instruction(23 downto 21),WA1,WA2,CLK,RegWrite1,RegWrite2,WriteData1,WriteData2,ReadData1,rd2);
  read_rs1<=Instruction(26 downto 24);
  read_rs2<=Instruction(23 downto 21);
  End a_decode;
