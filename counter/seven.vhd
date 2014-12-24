----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:04:35 12/23/2014 
-- Design Name: 
-- Module Name:    seven - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity seven is
generic(n: natural :=2);

    Port ( 
           a : out  STD_LOGIC;
           b : out  STD_LOGIC;
			  c : out  STD_LOGIC;
           d : out  STD_LOGIC;
           e : out  STD_LOGIC;
           f : out  STD_LOGIC;
			  g : out  STD_LOGIC;
           dp : out  STD_LOGIC;
           
           enable1 : out  STD_LOGIC;
			  enable2 : out  STD_LOGIC;
	        enable3 : out STD_LOGIC;
			  sevenSegment: out std_logic_vector(0 to 7);
			  clear:	in std_logic;
	        count:	in std_logic;
			  MCLK : in STD_LOGIC
			);
			  
end seven;

architecture Behavioral of seven is
	 signal a_store: std_logic_vector(20 downto 0);    
	 constant second : integer := 12000000/2;
	 constant divsec : integer := 400;
	 
	 signal d1: std_logic_vector(0 TO 7);
	 signal d2: std_logic_vector(0 TO 7);
	 signal d3: std_logic_vector(0 TO 7);
	 
	 shared VARIABLE tmp: INTEGER RANGE 0 TO 3*second/divsec;
	 shared VARIABLE digit1: integer := 0;
    shared VARIABLE digit2: integer := 0;
	 shared VARIABLE digit3: integer := 0;
	 signal test: std_logic;
function  convert  (a : integer) return UNSIGNED is
    variable r: UNSIGNED(0 to 7);
    begin
	 
	   if a=1 then r:="10011111";
      elsif a=2 then r:="00100101";
		elsif a=3 then r:="00001101";
		elsif a=4 then r:="10011001";
		elsif a=5 then r:="01001001";
		elsif a=6 then r:="01000001";
		elsif a=7 then r:="00011111";
		elsif a=8 then r:="00000001";
		elsif a=9 then r:="00001001";
		elsif a=0 then r:="00000011";
      end if;		
    return r;

  end convert;

begin

     process (MCLK,d1,d2,d3,clear) 
        begin		  
          if (clear='1') then  
            tmp := 0;  
          elsif (MCLK'event and MCLK='1') then  
            tmp := tmp + 1;
            if tmp <= second/divsec and tmp > 0 then
   				enable2 <= '1';
					enable3 <= '1';
               sevensegment <= d1;				
				   enable1 <= '0';
				elsif tmp > second/divsec and tmp < 2*second/divsec then
					enable1 <= '1';
					enable3 <= '1';					
					sevensegment <= d2;
					enable2 <= '0';
				elsif tmp > 2*second/divsec and tmp < 3*second/divsec then	
					enable1 <= '1';
					enable2 <= '1';
					sevensegment <= d3;
					enable3 <= '0';					 
				end if;				         
			end if;
      end process; 


     process (MCLK)	  	 
		 VARIABLE tmp2: INTEGER RANGE 0 TO second/5;
        begin
          if (MCLK'event and MCLK='1') then  
            tmp2 := tmp2 + 1;
            if tmp2 <= second/5 - 2 and tmp2 > 0 then
				   d1 <= std_logic_vector(convert(digit1));
					d2 <= std_logic_vector(convert(digit2));
					d3 <= std_logic_vector(convert(digit3));
				elsif tmp2 = second/5 -1 then
               digit1 := (digit1 + 1);				
					if digit1 = 10 then 
					   digit2 := (digit2 + 1);
                  digit1 := 0;
						if digit2 = 10 then
						  digit3 := (digit3 +1);
						  digit2 :=0;
						  if digit3=10 then
						    digit3 :=0;
							 digit1 :=0;
							 digit2 :=0;
						  end if;	 
						end if;
					end if;
				end if;				         
			end if;
     end process;     
	  
     
end Behavioral;
	
