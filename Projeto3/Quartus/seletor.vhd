library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seletor is

	port 
	(
		FM			   : in integer range 0 to 41;
		AM		   	: in integer range 0 to 106;
		seletor	   : in std_logic;
		
		DB1		   : out integer range 0 to 127;
		DB2			: out integer range 0 to 127;
		DB3			: out integer range 0 to 127;
		DB4			: out integer range 0 to 127
	);

end entity;

architecture hardware of seletor is
--	signal freq_AM : integer range 540 to 1600;
--	signal freq_AM : integer range 540 to 1600;
begin

	process (seletor)
		variable freq_AM : integer range 540 to 1600;
		variable freq_FM : integer range 875 to 1080;
	begin
		--seletor AM 
		if (seletor='1') then
		
			freq_AM := 540 + AM*10;
			
			--dividir os algarismos
			--ta errado aki
			DB3_buff <= freq_AM;
			DB2_buff <= freq_AM/10;
			DB1_buff <= freq_AM/1000;
			
			DB4 <= 48;
			
			with DB3_buff select
				DB3<=	48 when 0,
						49 when 1,
						50 when 2,
						51 when 3,
						52 when 4,
						53 when 5,
						54 when 6,
						55 when 7,
						56 when 8,
						57 when 9,
						32 when others;
						
			with DB2_buff select
				DB2<=	48 when 0,
						49 when 1,
						50 when 2,
						51 when 3,
						52 when 4,
						53 when 5,
						54 when 6,
						55 when 7,
						56 when 8,
						57 when 9,
						32 when others;
						
			with DB1_buff select
				DB1<=	49 when 1;
						32 when others;	
					
		else 
			--seletor '0' FM
			
			--
			freq_FM := 875 + FM*5;
			
			--dividir os algarismos
			--ta errado essa parte
			DB4_buff <= freq_FM/1000;
			DB3_buff <= freq_FM/100;
			DB2_buff <= freq_FM/10;
			DB1_buff <= freq_FM/1;
			
			with DB4_buff select
				DB4<=	48 when 0;
						53 when 5;
						32 when others;
			
			with DB3_buff select
				DB3<=	48 when 0;
						49 when 1;
						50 when 2;
						51 when 3;
						52 when 4;
						53 when 5;
						54 when 6;
						55 when 7;
						56 when 8;
						57 when 9;
						32 when others;
						
			with DB2_buff select
				DB2<=	48 when 0;
						56 when 8;
						57 when 9;
						32 when others;
						
			with DB1_buff select
				DB1<=	49 when 1;
						32 when others;
		end if;
	end process;


end hardware;