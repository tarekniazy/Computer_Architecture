LIBRARY IEEE,STD;
USE ieee.std_logic_1164.all;

ENTITY mux2 IS 
	Generic ( n : Integer:=16);
	PORT ( in0,in1 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic;
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
END mux2;


ARCHITECTURE whenmux OF mux2 is
	BEGIN
		
  out1 <= 	in0 when sel = '0'
	else	in1  ;
END whenmux;


