
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY muxbit IS 
	PORT ( in0,in1,in2,in3 : IN std_logic;
			sel : IN  std_logic_vector (1 DOWNTO 0);
			out1 : OUT std_logic);
END muxbit;


ARCHITECTURE when_else_mux OF muxbit is
	BEGIN
		
  out1 <= 	in0 when sel = "00"
	else	in1 when sel = "01"
	else	in2 when sel = "10"
	else 	in3 when sel = "11"; 
END when_else_mux;
