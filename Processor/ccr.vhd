Library ieee;
use ieee.std_Logic_1164.all;

ENTITY ccr is 
  GENERIC (n:integer :=4);
  PORT (Clk,Rst,En: IN std_logic;
    d: IN std_logic_vector (n-1 DOWNTO 0);
    q: OUT std_logic_vector(n-1 DOWnTO 0));
  END ccr;
  
  ARCHITECTURE struct_ccr OF ccr
  IS 
  BEGIN
    PROCESS(Clk,Rst)
      BEGIN
        IF Rst ='1' THEN
          q <= (OTHERS => '0');
        ELSIF rising_edge(Clk) THEN
          if En ='1' then
            q <= d;
          end if;
        end if;
      end process;
    End struct_ccr;
