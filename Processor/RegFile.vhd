LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;


ENTITY RegFile is 
  GENERIC (n:integer :=32);
  PORT ( Read1,Read2,Write1,Write2 : IN std_logic_vector(2 DOWNTO 0);
         CLK,RegWrite1,RegWrite2: IN std_logic;
         WriteData1,WriteData2: IN std_logic_vector(n-1 DOWNTO 0);
         ReadData1,ReadData2: OUT std_logic_vector(n-1 DOWNTO 0));  
  END RegFile;
  ARCHITECTURE a_Reg OF RegFile
  IS 
    type Reg_Array is array (0 to 7) of std_logic_vector (n-1 DOWNTO 0) ;   
    signal Reg_s : Reg_Array:= ("00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000");

 BEGIN
  process (CLK)
    begin
      IF rising_edge(clk) THEN  
        if RegWrite1 = '1' THEN
         Reg_s(to_integer(unsigned(Write1))) <= WriteData1;
       END IF;
        if RegWrite2 = '1' THEN
         Reg_s(to_integer(unsigned(Write2))) <= WriteData2;
       END IF;
    end if;
--   IF  falling_edge(clk) THEN
   
   --END IF;
    end process;
      ReadData1 <= Reg_s(to_integer(unsigned(Read1)));
       ReadData2 <= Reg_s(to_integer(unsigned(Read2)));
 
  END a_Reg;    