Library ieee;
use ieee.std_Logic_1164.all;

ENTITY HazardUnit is 
  PORT ( CLK,ID_EX_MEMRead : IN std_logic; --if load use case
         IF_ID_RS1, IF_ID_RS2, ID_EX_Rs1: IN std_logic_vector (2 DOWNTO 0);   
         PCStall,FetchStall,FlushEx : OUT std_logic);

  END HazardUnit;
  
  ARCHITECTURE HDU OF HazardUnit
  IS 
BEGIN
PROCESS(CLK,ID_EX_MEMRead,IF_ID_RS1,IF_ID_RS2,ID_EX_Rs1)
BEGIN
  IF ID_EX_MEMRead ='1' then 
     IF (IF_ID_RS1 = ID_EX_Rs1) or (IF_ID_RS2 = ID_EX_Rs1) then
        PCStall <= '1';
        FetchStall <= '1';
        FlushEx <= '1'; 
     ELSE   
       PCStall <= '0';
        FetchStall <= '0';
        FlushEx <= '0'; 
     END IF;
  ELSE
      PCStall <= '0';
      FetchStall <= '0';
      FlushEx <= '0'; 

  END IF;

END PROCESS;

END HDU;
