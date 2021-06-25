Library ieee;
use ieee.std_Logic_1164.all;

ENTITY fetch is 
  PORT ( PCSrc,CondAddr,UnCondAddr,memoryvalue : IN std_logic_vector ( 31 DOWNTO 0);
         CondJ,UncondJ,memoryin,CLK,RST,Interrupt,MX1S,pc_stall : IN std_logic;
         PCINC,Instruction,MUX1_O: OUT std_logic_vector ( 31 DOWNTO 0));
  END fetch;
  
  ARCHITECTURE a_fetch OF fetch
  IS 
-- 4x1 MUX
   COMPONENT mux_generic is 
   Generic ( n : Integer:=16);
	PORT ( in0,in1,in2,in3 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic_vector (1 DOWNTO 0);
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
  END COMPONENT;
  -- 2x1 MUX
   COMPONENT mux2 is 
   Generic ( n : Integer:=16);
	PORT ( in0,in1: IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic;
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
  END COMPONENT;
  ----- RAM
  
  COMPONENT ram IS
  GENERIC (n:integer :=16);
	PORT(
		clk : IN std_logic;
		address : IN  std_logic_vector(10 DOWNTO 0);
		dataout : OUT std_logic_vector(n-1 DOWNTO 0));
END COMPONENT;
--- REGISTER
   COMPONENT my_nDFF is 
  GENERIC (n:integer :=32);
  PORT (Clk,Rst,En: IN std_logic;
    d: IN std_logic_vector (n-1 DOWNTO 0);
    q: OUT std_logic_vector(n-1 DOWnTO 0));
  END COMPONENT;
  
component n_adder IS
Generic (n:integer:=32);
	PORT (a,b: IN std_logic_vector(31 DOWNTO 0) ;
		cin : IN std_logic;
             s: out std_logic_vector(31 DOWNTO 0) ;
		 cout : OUT std_logic );
END component;
-----------------------------------
 component ccr  
  GENERIC (n:integer :=32);
  PORT (Clk,Rst,En: IN std_logic;
    d: IN std_logic_vector (n-1 DOWNTO 0);
    q: OUT std_logic_vector(n-1 DOWnTO 0));
  end component ;
--------------------------------------------


  Signal rstaddress,intaddress,mmOut,IMOUT,PCADD,add,PP,PCVALUE: std_logic_vector (31 DOWNTO 0);
  Signal r,pcenable,maS,MX1: std_logic;
  Signal mmSel,cout: std_logic_vector (1 DOWNTO 0);
  
  BEGIN
     
      ---------------    ----- Fetch Stage -------------
     PROCESS(CLK,pc_stall)
         BEGIN
 
      if CondJ = '1' then
            PCVALUE <= CondAddr;
      elsif UnCondJ = '1' then
            PCVALUE <= UnCondAddr;
      elsif memoryin = '1' then
            PCVALUE <= memoryvalue;
      else 
            PCVALUE <= PCSrc;
      end if;

      if pc_stall ='1' then
         pcenable <= '0';
     else 
         pcenable <= '1';
     end if;

     END PROCESS;
     

     PC: my_nDFF GENERIC MAP(32) PORT MAP (CLK,'0',pcenable,PCVALUE,add);
     rstaddress <= "00000000000000000000000000000000";
     intaddress <= "00000000000000000000000000000010";
     mmSel <= Interrupt & RST;
     mm: mux_generic GENERIC MAP(32) PORT MAP (add,rstaddress,intaddress,rstaddress,mmSel,mmOut);
     IM: ram GENERIC MAP(16) PORT MAP(CLK,mmOut(10 DOWNTO 0),IMOUT);
       PROCESS(IMOUT (31 downto 27))
         BEGIN
          IF IMOUT (31 downto 27) = "01010"  THEN
              maS <= '1';
          ELSIF IMOUT (31 downto 27) = "10010"  THEN
              maS <= '1';
          ELSIF IMOUT (31 downto 27) = "10011" THEN
              maS <= '1';
          ELSIF IMOUT (31 downto 27) = "10100" THEN
              maS <= '1';
          ELSE
              maS <= '0';
          END IF;
      END PROCESS;
	Process(RST,Interrupt)
          BEGIN
          IF RST ='1' or Interrupt ='1' THEN
              MX1 <= '1';
          ELSE
              MX1 <= '0';
	END IF;
        END PROCESS;
    Instruction <=IMOUT;
    ma: mux2 GENERIC MAP(32) PORT MAP ("00000000000000000000000000000001","00000000000000000000000000000010",maS,PCADD);
    pcadder: n_adder GENERIC MAP(32) PORT MAP (PCADD,mmOut,'0',PP);
    PCINC<=PP ;
    m1: mux2 GENERIC MAP(32) PORT MAP (PP ,IMOUT,MX1,MUX1_O);
    
    
   End a_fetch;