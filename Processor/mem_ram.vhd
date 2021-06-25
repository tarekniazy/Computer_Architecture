LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY mem_ram IS
   GENERIC (n:integer :=32);
	PORT(
		clk, mux_6: IN std_logic;
		we,re  : IN std_logic;   
		address : IN  std_logic_vector(31 DOWNTO 0);
		datain  : IN  std_logic_vector(n-1 DOWNTO 0);

		dataout : OUT std_logic_vector(n-1 DOWNTO 0));
END ENTITY mem_ram;

ARCHITECTURE syncrama OF mem_ram IS

	TYPE ram_type IS ARRAY(0 TO 2047) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL ram : ram_type ;
	
	BEGIN
		PROCESS(clk,mux_6) IS
			BEGIN
                        
                       if mux_6='0' then
				IF rising_edge(clk) THEN  
					IF we = '1' THEN
						ram(to_integer(unsigned(address))) <= datain(31 downto 16);
                                                ram(to_integer(unsigned(address))-1) <= datain(15 downto 0); 
					END IF;
				
                              --------------------
                   --          
					IF re = '1' THEN
						dataout(31 downto 16) <= ram(to_integer(unsigned(address)));
                                                dataout(15 downto 0) <= ram(to_integer(unsigned(address))-1);
					END IF;
				END IF;
                      elsif mux_6='1' then 
                              IF rising_edge(clk) THEN  
					IF we = '1' THEN
						ram(to_integer(unsigned(address))) <= datain(31 downto 16);
                                                ram(to_integer(unsigned(address))+1) <= datain(15 downto 0); 
					END IF;
				
                              --------------------
					IF re = '1' THEN
						dataout(31 downto 16) <= ram(to_integer(unsigned(address)));
                                                dataout(15 downto 0) <= ram(to_integer(unsigned(address))+1);
					END IF;
				END IF; 
                       end if;     

		END PROCESS;
		
END syncrama;

