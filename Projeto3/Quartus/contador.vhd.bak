library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity contador is
	port (
	clock, reset, enable : in std_logic;
	q: out std_logic_vector (3 downto 0)
	);
end contador;	
architecture contar of contador is
begin
	process (clock, reset)
	variable contagem : integer range 15 downto 0;
	begin
		
		if contagem = 15 then
			contagem := 9;
		elsif clock'event and clock = '1' then
			if enable = '1' then 
				contagem := contagem - 1;
			end if;
			if reset = '1' then
				contagem := 9;
			end if;	
		end if;
		q <= conv_std_logic_vector (contagem, 4);
	end process;
end contar;