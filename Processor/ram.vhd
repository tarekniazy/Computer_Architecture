LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY ram IS
  GENERIC (n:integer :=16);
	PORT(
		clk : IN std_logic;
		address : IN  std_logic_vector(10 DOWNTO 0);
		dataout : OUT std_logic_vector(16+n-1 DOWNTO 0));
END ENTITY ram;

ARCHITECTURE syncrama OF ram IS

	TYPE ram_type IS ARRAY(0 TO 2047) OF std_logic_vector(n-1 DOWNTO 0);
	SIGNAL ram : ram_type ;
	
	BEGIN
		dataout(n-1 downto 0) <= ram(to_integer(unsigned(address))+1);
		dataout(16+n-1 downto n) <= ram(to_integer(unsigned(address)));
END syncrama;
