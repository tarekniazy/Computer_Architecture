library ieee;
use ieee.std_logic_1164.all;

-- 25er 3 bits: (Enable (N-3) , Stall (N-2), Flush (N-1) )
Entity Buff is 
Generic (n: integer:= 16);
Port
(
input : In std_logic_vector  (n-1 downto 0);
Enable,Flush : In std_logic;
clk : In std_logic;
Reset: In std_logic;
output: Out std_logic_vector (n-1 downto 0)  -- Msh hakhod el 3 bits dool
);
End Buff;
Architecture arch1 of Buff is 
signal input1: std_logic_vector (n-1 downto 0);
Begin 


Process(clk, reset,Flush) is
Begin 
if falling_edge (clk) Then
   if (Reset='1')  Then
         output <= (others=>'0');
   elsif (Enable='1') Then --  if enable=1
        if (FLush='1') Then  -- Stall=0, Flush =0
            output <= (others=>'0');
        else
            output <= input (n-1 downto 0);          
        end if;
   end if  ;
end if  ;

end process;
ENd arch1;