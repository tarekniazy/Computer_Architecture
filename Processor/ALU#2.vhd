library ieee;
library work;
use ieee.std_logic_1164.all;

ENTITY ALU2 IS
Generic (n:integer:=32);
PORT( A:IN std_logic_vector (31 DOWNTO 0);
      B:IN std_logic_vector (31 DOWNTO 0);
       sel: In std_logic_vector(3 DOWNTO 0);
              F:out std_logic_vector (31 DOWNTO 0);
cin : in std_logic;
cout,Sign,zero : out std_logic
);
end entity alu2;


ARCHITECTURE struct_alu2 OF alu2 IS

signal x:std_logic_vector (n-1 DOWNTO 0);
signal y:std_logic_vector (n-1 DOWNTO 0);
signal z:std_logic_vector (n-1 DOWNTO 0);
signal w:std_logic_vector (n-1 DOWNTO 0);
signal cin_x,sign_x,zero_x,cin_y,sign_y,zero_y,cin_z,sign_z,zero_z,cout_x,cout_y,cout_z:std_logic;


-----------------------------------------------------------------

component  partc2 
Generic (n:integer:=32);
PORT( A:IN std_logic_vector (31 DOWNTO 0);
      B:IN std_logic_vector (31 DOWNTO 0);
       sel: In std_logic_vector(3 DOWNTO 0);
        shft_amnt:IN std_logic_vector (31 DOWNTO 0);
              F:out std_logic_vector (31 DOWNTO 0);
cin : in std_logic;
 cout,Sign,zero : OUT std_logic 
);
end component;
----------------------------------------------------------------

component partb2 
Generic (n:integer:=32);
PORT( A:IN std_logic_vector (31 DOWNTO 0);
      B:IN std_logic_vector (31 DOWNTO 0);
       sel: In std_logic_vector(1 DOWNTO 0);
              F:out std_logic_vector (n-1 DOWNTO 0);
cin : in std_logic;
 cout,Sign,zero : OUT std_logic 
);
end component;

----------------------------------------------------------------

component parta2 
Generic (n:integer:=32);
	PORT (a,b: IN std_logic_vector(31 DOWNTO 0) ;
		cin : IN std_logic;
             s: out std_logic_vector(31 DOWNTO 0) ;
		 cout,Sign,zero : OUT std_logic ;
                        sel: In std_logic_vector(1 DOWNTO 0));
end component;

---------------------------------------------------------------

---------------------------------------------------
begin 
---------------------------------------------------


u1:  parta2 generic map(32) port map(A,B,cin_x,x,cout_x,sign_x,zero_x,SEL(1 DOWNTO 0)); 

u2:  partb2 generic map(32) port map(A,B,SEL(1 DOWNTO 0),y,cin_y,cout_y,sign_y,zero_y);

u3:  partc2 generic map(32) port map(A,B,SEL(3 DOWNTO 0),B,z,cin_z,cout_z,sign_z,zero_z);

----------------------------------------------------
f<=x when SEL(3 DOWNTO 2)="00"

else y when SEL(3 DOWNTO 2) ="01"

else z when SEL(3 DOWNTO 2) ="10";
-------------------------------------------------------
cout<= cout_x when SEL(3 DOWNTO 2)="00"

else cout_y when SEL(3 DOWNTO 2) ="01"

else cout_z when SEL(3 DOWNTO 2) ="10";
------------------------------------------------------
Sign<= sign_x when SEL(3 DOWNTO 2)="00"

else sign_y when SEL(3 DOWNTO 2) ="01"

else sign_z when SEL(3 DOWNTO 2) ="10";
----------------------------------------------------
zero<=zero_x when SEL(3 DOWNTO 2)="00"

else zero_y when SEL(3 DOWNTO 2) ="01"

else zero_z when SEL(3 DOWNTO 2) ="10";

-------------------------------------------------------
cin_x<=cin when  SEL(3 DOWNTO 2)="00";

cin_y<=cin when  SEL(3 DOWNTO 2)="01";

cin_z<= cin when  SEL(3 DOWNTO 2)="10";


-------------------------------------------------------
end struct_alu2 ;

























