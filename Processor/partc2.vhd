library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;


ENTITY partc2 IS
Generic (n:integer:=32);
PORT( A:IN std_logic_vector (31 DOWNTO 0);
      B:IN std_logic_vector (31 DOWNTO 0);
       sel: In std_logic_vector(3 DOWNTO 0);
        shft_amnt:IN std_logic_vector (31 DOWNTO 0);
              F:out std_logic_vector (31 DOWNTO 0);
cin : in std_logic;
 cout,Sign,zero : OUT std_logic 
);
end entity partc2;

ARCHITECTURE structc2 OF partc2 IS

SIGNAL w,x: std_logic_vector(n-1 DOWNTO 0);
signal amn: std_logic_vector (31 downto 0):= "00000000000000000000000000000000"; 

begin

process(sel,a,b,shft_amnt)

begin 

if sel(3 downto 2)="10" then
  
  if sel(1 downto 0) = "00" then
  F <=(amn(to_integer(unsigned(shft_amnt)) downto 1)&A(31 DOWNTO to_integer(unsigned(shft_amnt)) ));
  elsif sel(1 downto 0)="01" then
  f<=(A(31-to_integer(unsigned(shft_amnt)) DOWNTO 0 )&amn(to_integer(unsigned(shft_amnt)) downto 1));
  end if;
if sel(1 downto 0) = "00" then
  w <=(amn(to_integer(unsigned(shft_amnt)) downto 1)&A(31 DOWNTO to_integer(unsigned(shft_amnt)) ));
  elsif sel(1 downto 0)="01" then
  x<=(A(31-to_integer(unsigned(shft_amnt)) DOWNTO 0 )&amn(to_integer(unsigned(shft_amnt)) downto 1));
  end if;

if sel(1 downto 0)=  "00" then
cout<=A(to_integer(unsigned(shft_amnt))-1);
elsif sel(1 downto 0)=  "01" then 
cout<= A(31-(to_integer(unsigned(shft_amnt))+1));
elsif sel(1 downto 0)=  "10" then 
cout<='1';
elsif sel(1 downto 0)=  "11" then
cout<='0';
end if;

end if;
end process;
---------------------------------------------
process(w,x)
begin

if sel="00" then 
if w(n-1 downto 0)=amn(n-1 downto 0) then
zero<='1';
else zero<='0';
end if;
elsif sel="01" then 
if x(n-1 downto 0)=amn(n-1 downto 0) then 
zero<='1';
else zero<='0';
end if;
end if;
end process;
--------------------------------------------
process(w,x)
begin

if sel="00" then 
if w(n-1)='1' then
Sign<='1';
else Sign<='0';
end if;
elsif sel="01" then 
if x(n-1)='1' then 
Sign<='1';
else Sign<='0';
end if;
end if;
end process;

----------------------------------------


end structc2 ;
