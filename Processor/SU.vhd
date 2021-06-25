library ieee;
library work;
use ieee.std_logic_1164.all;


ENTITY su IS
Generic (n:integer:=32);
PORT(  spadd,sp_enable,sp_rst,sp_clk,mux_10_sel:in std_logic;
       sp_val:out std_logic_vector(31 downto 0)

);
end entity su;

architecture struct_su  of su is
signal a,b,c,d,e: std_logic_vector(31 downto 0); 
signal couty:std_logic;
signal k: std_logic_vector (31 downto 0):="00000000000000000000000000000010";
signal m :std_logic_vector (31 downto 0);
signal f:std_logic_vector(31 downto 0);
---------------------------------
 COMPONENT s_dff is 
  GENERIC (n:integer :=32);
  PORT (Clk,Rst,En: IN std_logic;
    d: IN std_logic_vector (n-1 DOWNTO 0);
    q: OUT std_logic_vector(n-1 DOWnTO 0));
  END COMPONENT;
  
----------------------------------------------------------
COMPONENT mux2 is 
   Generic ( n : Integer:=32);
	PORT ( in0,in1: IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic;
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
  END COMPONENT;
------------------------------------------------------------
component n_adder IS

	Generic (n:integer:=32);
	PORT (a,b: IN std_logic_vector(n-1 DOWNTO 0) ;
		cin : IN std_logic;
             s: out std_logic_vector(n-1 DOWNTO 0) ;
		 cout : OUT std_logic );

END component;
------------------------------------------------
begin
m<=not k;

sp:s_dff GENERIC MAP(32) PORT MAP (sp_clk,sp_rst,sp_enable,e,a);
add: n_adder   PORT MAP (a,k,'0',d,couty);
sub: n_adder   PORT MAP (a,m,'1',c,couty);

e<= c when mux_10_sel='0'
else d when mux_10_sel='1';


spadd_mux: mux2 GENERIC MAP(32) PORT MAP (e,a,spadd,b);

sp_val<=b;


 PROCESS(sp_clk,sp_rst)
      BEGIN
        
      
        IF falling_edge(sp_clk) THEN
          if sp_enable ='1' then
            f<= b;
          end if;
        end if;
      end process;



end struct_su;




