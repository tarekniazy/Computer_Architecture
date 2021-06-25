Library ieee;
use ieee.std_Logic_1164.all;

entity Funit is 
   
  GENERIC (n: integer := 32);
  PORT (S1,S2: OUT std_logic;
 ALUop1,ALUop2 : OUT std_logic_vector(1 downto 0); --mux selectors
     ALUSEL :  IN std_logic_vector(3 downto 0);
   EX_MEM_RegWrite,MEM_WB_RegWrite,EX_MEM_RegWrite2,MEM_WB_RegWrite2: IN std_logic;
    RS1,RS2 :  IN std_logic_vector(2 downto 0);
    EX_MEM_RD1,EX_MEM_RD2,MEM_WB_RD1,MEM_WB_RD2 : IN std_logic_vector(2 downto 0);
   ldm:std_logic );
END ENTITY Funit;

ARCHITECTURE forward OF Funit IS
  BEGIN

  process ( EX_MEM_RegWrite,MEM_WB_RegWrite,RS1,RS2,EX_MEM_RD1,EX_MEM_RD2,MEM_WB_RD1,MEM_WB_RD2)
BEGIN
 ALUop1<="00";
ALUop2<="00";
if      ldm = '1' then
      ALUop1<="00";
      ALUop2<="00";
else

  if EX_MEM_RegWrite='0' and MEM_WB_RegWrite='0' and EX_MEM_RegWrite2='0' and MEM_WB_RegWrite2='0' then 
       ALUop1<="00";
          
     elsif EX_MEM_RegWrite='0' and MEM_WB_RegWrite='1' and EX_MEM_RegWrite2='0' and MEM_WB_RegWrite2='0' then 
    if (RS1= MEM_WB_RD1 ) then 
      ALUop1<="10";
        else 
         ALUop1<="00";  
               end if ;
                   
        elsif EX_MEM_RegWrite='1' and MEM_WB_RegWrite='0' and EX_MEM_RegWrite2='0' and MEM_WB_RegWrite2='0' then
    if RS1 =EX_MEM_RD1 then
     ALUop1<="01";
       else  
       ALUop1<="00";
      end if ;
      
      elsif  EX_MEM_RegWrite='1' and MEM_WB_RegWrite='1' and EX_MEM_RegWrite2='0' and MEM_WB_RegWrite2='0' then 
             if RS1=EX_MEM_RD1 then
                   ALUop1<="01"; 
              elsif   RS1=MEM_WB_RD1 then
                   ALUop1<="10"; 
               else  
             ALUop1<="00";
              end if ;
      else
              ALUop1<="00";
               ALUop2<="00";
             end if ;

             -- op2 & RS2
             
    if (EX_MEM_RegWrite='0' and MEM_WB_RegWrite='0' and EX_MEM_RegWrite2='0' and MEM_WB_RegWrite2='0') then 
                   ALUop2<="00";
          
     elsif (EX_MEM_RegWrite='0' and MEM_WB_RegWrite='1' and EX_MEM_RegWrite2='0' and MEM_WB_RegWrite2='0') then 
                   if (RS2= MEM_WB_RD1 ) then 
                        ALUop2<="10";
                   else 
                       ALUop2<="00";  
                      end if ;
                   
        elsif (EX_MEM_RegWrite='1' and MEM_WB_RegWrite='0' and EX_MEM_RegWrite2='0' and MEM_WB_RegWrite2='0')then
    if (RS2 =EX_MEM_RD1)then
     ALUop2<="01";
       else  
       ALUop2<="00";
      end if ;
      
      elsif (EX_MEM_RegWrite='1' and MEM_WB_RegWrite='1' and EX_MEM_RegWrite2='0' and MEM_WB_RegWrite2='0')then 
        if  RS2=EX_MEM_RD1 then
        ALUop2<="01"; 
         elsif (RS2=MEM_WB_RD1 ) then
        ALUop2<="10"; 
         else  
       ALUop2<="00";
      end if ;
             end if ;


----------------------------------------------------------------------------
---------------IF SWAP ----------------------------------
if (EX_MEM_RegWrite2='1') then  --yb2a da swap 
 if RS1=EX_MEM_RD1 then 
     ALUop1<="11";
     S1 <= '1';

elsif RS1=EX_MEM_RD2 then 
     ALUop1<="11";
     S1 <= '0';
end if;

if RS2=EX_MEM_RD1 then 
     ALUop2<="11";
     S2 <= '1';

elsif RS2=EX_MEM_RD2 then 
     ALUop2<="11";
     S2 <= '0';
end if;


end if;
end if;
---------------------Reg Write 2 -----------------------------
--if (EX_MEM_RegWrite2='0' and MEM_WB_RegWrite2='0') then 
--    ALUop1<="00";
--          
--     elsif (EX_MEM_RegWrite2='0' and MEM_WB_RegWrite2='1') then 
--    if (RS1= MEM_WB_RD1 ) then 
--      ALUop1<="10";
--        else 
--         ALUop1<="00";  
--               end if ;
--                   
--        elsif (EX_MEM_RegWrite2='1' and MEM_WB_RegWrite2='0')then
--    if (RS1 =EX_MEM_RD1)then
--     ALUop1<="01";
--       else  
--       ALUop1<="00";
--      end if ;
--      
--      elsif (EX_MEM_RegWrite2='1' and MEM_WB_RegWrite2='1')then 
--        if (RS1=MEM_WB_RD1 or RS1=MEM_WB_RD2  ) then
--        ALUop1<="01"; 
--         elsif   ( RS1=EX_MEM_RD1 or RS1=EX_MEM_RD2) then
--        ALUop1<="10"; 
--         else  
--       ALUop1<="00";
--      end if ;
--             end if ;
--
--             
--             
--             -- op2 & RS2
--             
--             if (EX_MEM_RegWrite2='0' and MEM_WB_RegWrite2='0') then 
--    ALUop2<="00";
--          
--     elsif (EX_MEM_RegWrite2='0' and MEM_WB_RegWrite2='1') then 
--    if (RS2= MEM_WB_RD2 ) then 
--      ALUop2<="10";
--        else 
--         ALUop2<="00";  
--               end if ;
--                   
--        elsif (EX_MEM_RegWrite2='1' and MEM_WB_RegWrite2='0')then
--    if (RS2 =EX_MEM_RD2)then
--     ALUop2<="01";
--       else  
--       ALUop2<="00";
--      end if ;
--      
--      elsif (EX_MEM_RegWrite2='1' and MEM_WB_RegWrite2='1')then 
--        if (RS2=MEM_WB_RD1 or RS2=MEM_WB_RD2  ) then
--        ALUop2<="01"; 
--         elsif ( RS2=EX_MEM_RD1 or RS2=EX_MEM_RD2) then
--        ALUop2<="10"; 
--         else  
--       ALUop2<="00";
--      end if ;
--             end if ;

     
end process; 
END forward;



