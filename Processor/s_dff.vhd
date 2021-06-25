Library ieee;
use ieee.std_Logic_1164.all;

ENTITY s_dff is 
  GENERIC (n:integer :=32);
  PORT (Clk,Rst,En: IN std_logic;
    d: IN std_logic_vector (n-1 DOWNTO 0);
    q: OUT std_logic_vector(n-1 DOWnTO 0));
  END s_dff;
  
  ARCHITECTURE struct_s_dff OF s_dff
  IS 
  BEGIN
    PROCESS(Clk,Rst)
      BEGIN
        IF Rst ='1' THEN
          q <= "00000000000000000000011111111111";
        ELSIF  rising_edge(Clk) THEN
          if En ='1' then
            q <= d;
          end if;
        end if;
      end process;
    End struct_s_dff;
