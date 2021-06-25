Library work;
Library ieee;
USE IEEE.std_logic_1164.all;

ENTITY parta2 IS
Generic (n:integer:=32);
	PORT (a,b: IN std_logic_vector(31 DOWNTO 0) ;
		cin : IN std_logic;
             s: out std_logic_vector(31 DOWNTO 0) ;
		 cout,Sign,zero : OUT std_logic ;
                        sel: In std_logic_vector(1 DOWNTO 0));
END parta2;

ARCHITECTURE structa2 OF parta2 IS

component n_adder IS

	Generic (n:integer:=32);
	PORT (a,b: IN std_logic_vector(31 DOWNTO 0) ;
		cin : IN std_logic;
             s: out std_logic_vector(31 DOWNTO 0) ;
		 cout : OUT std_logic );

END component;

         SIGNAL w,x,y,z,k : std_logic_vector(31 DOWNTO 0);
         signal coutw,coutx,couty,coutz,cinx,ciny,cinz,cinw,q: std_logic;
        signal amn: std_logic_vector (31 downto 0):= "00000000000000000000000000000000"; 
-----------------------------------------------------------------------------
signal temp1:string(1 to 4);
signal temp2:string(1 to 4);
signal temp3:string(1 to 4);
signal temp4:string(1 to 4);  
signal Tm:integer:=0;  

--------------------------------------------------------------------------

BEGIN
-------------------------------------------
k<=not b;

--------------------------------------------------------------------------------------
u0: n_adder Generic map(32) PORT MAP (a(31 DOWNTO 0),(others=>'0'),'1',w,coutw);
u1: n_adder Generic map(32) PORT MAP (a(31 DOWNTO 0),b(31 DOWNTO 0)  ,'0',x,coutx); 
u2: n_adder Generic map(32) PORT MAP (a(31 DOWNTO 0),k,'1',y,couty);
u3: n_adder Generic map(32) PORT MAP (a(31 DOWNTO 0),(others=>'1'),'0',z,coutz);

-----------------------------------------------------------------------------------------



s<= w when sel ="00"
else x when sel ="01"
else y when sel ="10"
else z when sel="11" 
else (others =>'1');

-----------------------------------------------------------------------------------------
cout <= coutw when sel ="00"
else  coutx when sel ="01"
else not couty when sel ="10"
else not coutz when sel="11"
else '0';
-----------------------------------------------
cinw<=cin when sel="00";
cinx<=cin when sel="01";
ciny<=cin when sel="10";
cinz<=cin when sel="11";
--------------------------------------------
process(w,x,y,z,sel)
variable M, N : integer;



begin

m:=tm+1;

tm<=m;

if sel="00" then 
	if w(31 downto 0)=amn(31 downto 0) then
	zero<='1';
	temp1<="inc_";
	else zero<='0';
	end if;

elsif sel="01" then
	if x(31 downto 0)=amn(31 downto 0) then 
	zero<='1';
	temp2<="add_";
	else zero<='0';
	end if;

elsif sel="10" then
	if y(31 downto 0)=amn(31 downto 0) then
	zero<='1';
	temp3<="sub_";
	else zero<='0';
	end if;

elsif sel="11" then
	if z(31 downto 0)=amn(31 downto 0) then
	zero<='1';
	temp4<="dec_";
	else zero<='0';
	end if;

end if;

end process;
---------------------------------------------------
process(w,x,y,z,sel)
begin

if sel="00" then 
if w(31)='1' then
Sign<='1';
else Sign<='0';
end if;
elsif sel="01" then 
if x(31)='1' then 
Sign<='1';
else Sign<='0';
end if;
elsif sel="10" then
if y(31)='1' then
Sign<='1';
else Sign<='0';
end if;
elsif sel="11" then
if z(31)='1' then
Sign<='1';
else Sign<='0';
end if;
end if;
end process;


---------------------------------------------
END structa2;
