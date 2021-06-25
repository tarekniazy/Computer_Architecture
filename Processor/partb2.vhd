library ieee;
use ieee.std_logic_1164.all;
ENTITY partb2 IS
Generic (n:integer:=16);
PORT( A:IN std_logic_vector (n-1 DOWNTO 0);
      B:IN std_logic_vector (n-1 DOWNTO 0);
       sel: In std_logic_vector(1 DOWNTO 0);
              F:out std_logic_vector (n-1 DOWNTO 0);
cin : in std_logic;
 cout,Sign,zero : OUT std_logic 
);
end entity partb2;

ARCHITECTURE structb2 OF partb2 IS

 SIGNAL w,x,z: std_logic_vector(n-1 DOWNTO 0);
 signal amn: std_logic_vector (31 downto 0):= "00000000000000000000000000000000"; 
 

begin 



 F<=(A and B) when (sel= "00")
else (A or B) when (sel ="01")
else b  when (sel ="10")
else (not A) WHEN (sel = "11");
-------------------------------------------
cout<='0';
-------------------------------------
w<=(A and B) when (sel= "00");
x<= (A or B) when (sel ="01");
z<= (not A) WHEN (sel = "11");

-----------------------------------------
process(w,x,z)
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
elsif sel="11" then
if z(n-1 downto 0)=amn(n-1 downto 0) then
zero<='1';
else zero<='0';
end if;
end if;
end process;
-------------------------------------------
process(w,x,z)
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
elsif sel="11" then
if z(n-1)='1' then
Sign<='1';
else Sign<='0';
end if;
end if;
end process;




--------------------------------------------
end structb2 ;
