library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity mux21 is
	port (
	mux_seletor : in std_logic;
	D1_c, D2_c, D3_c, D4_c, D1_r, D2_r, D3_r, D4_r: in std_logic_vector (3 downto 0);
	D1, D2, D3, D4 : out std_logic_vector (3 downto 0)
	);
end mux21;	

architecture escolha of mux21 is
--signal aux1, aux2, aux3, aux4: std_logic;
begin
	
	process (mux_seletor,D1_c, D2_c, D3_c, D4_c, D1_r, D2_r, D3_r, D4_r)
	--variable count: integer range 0 to 5;
	begin
		if mux_seletor='1' then
			D1<=D1_r;
			D2<=D2_r;
			D3<=D3_r;
			D4<=D4_r;
			
		else
		
			D1<=D1_c;
			D2<=D2_c;
			D3<=D3_c;
			D4<=D4_c;			
			
		end if;
		
	end process;

end escolha;