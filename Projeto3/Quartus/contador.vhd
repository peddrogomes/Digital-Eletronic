library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use ieee.numeric_std.all;

entity contador is
	port (
	clk, enable_subida, enable_descida, seletor, load : in std_logic;
	
	D1_r, D2_r, D3_r, D4_r: in std_logic_vector (3 downto 0);
	
	D1, D2, D3, D4: out std_logic_vector (3 downto 0)
	);
end contador;	

architecture contar of contador is
	signal limite_descida, limite_subida : integer range 0 to 1;

begin
	
		
	
	process (clk, seletor,enable_subida, enable_descida, load)
		variable unidades_am, unidades_fm : integer range 9 downto 0:=0;
		variable dezenas_am, dezenas_fm: integer range 9 downto 0:=7;
		variable centenas_am, centenas_fm: integer range 9 downto 0:=9;
		variable milhares_am, milhares_fm : integer range 9 downto 0:=0;
	begin
	-------------------------------------------------------------------------
	--------------------- limites de contagem -----------------------------
		if seletor = '0' then --AM 

			if (unidades_am=0 and dezenas_am=0 and centenas_am=6 and milhares_am=1) then
			
			limite_subida<=1; --1600
			
			elsif (unidades_am=0 and dezenas_am=4 and centenas_am=5 and milhares_am=0) then
			
			limite_descida<=1; --540
			else
			limite_subida<=0;
			limite_descida<=0;
			end if;
			
		else
		
			if (unidades_fm=0 and dezenas_fm=8 and centenas_fm=0 and milhares_fm=1) then
				limite_subida<=1; --1080
			elsif (unidades_fm=5 and dezenas_fm=7 and centenas_fm=8 and milhares_fm=0) then
				limite_descida<=1; --875
			else
				limite_subida<=0;
				limite_descida<=0;
			end if;
		end if;
	
	


	if rising_edge(clk) then 
	
	
--------------------------------------------------------------------------------
------------------------seleção dos salvos-----------------------------------------	
	if load='1' then
		if seletor='0' then --AM
			
			unidades_am:=conv_integer(unsigned(D1_r));
			dezenas_am:=conv_integer(unsigned(D2_r));
			centenas_am:=conv_integer(unsigned(D3_r));
			milhares_am:=conv_integer(unsigned(D4_r));
			
		else
			unidades_am:= conv_integer(unsigned(D1_r));
			dezenas_fm:=conv_integer(unsigned(D2_r));
			centenas_fm:=conv_integer(unsigned(D3_r));
			milhares_fm:=conv_integer(unsigned(D4_r));
			
		end if;
	end if;
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------
------------------------contadores-------------------------------------------	
------------------------------------------------------------------------------------

		if enable_subida='1' and limite_subida=0 then
			if seletor='0' then --subida AM (de 10 em 10)
					if dezenas_am=9 then 
						dezenas_am:=0;
						if centenas_am=9 then
							centenas_am:=0;							
							milhares_am:=milhares_am+1;							
						else
							centenas_am:=centenas_am+1;
						end if;
					else
						dezenas_am:=dezenas_am+1;
					end if;		
			else --subida FM (de 5 em 5)
				if unidades_fm=5 then
					unidades_fm:=0;
					if dezenas_fm=9 then
						dezenas_fm:=0;
						if centenas_fm=9 then
							centenas_fm:=0;							
							milhares_fm:=milhares_fm+1;							
						else
							centenas_fm:=centenas_fm+1;
						end if;
					else
						dezenas_fm:=dezenas_fm+1;
					end if;
				else
				unidades_fm:=5;
				end if;
			end if;
		
		elsif enable_descida='1' and limite_descida=0 then
			if seletor='0' then --descida AM (de 10 em 10)
					if dezenas_am=0 then 
						dezenas_am:=9;
						if centenas_am=0 then
							centenas_am:=9;
							milhares_am:=milhares_am-1;
						else
							centenas_am:=centenas_am-1;
						end if;
					else
						dezenas_am:=dezenas_am-1;
					end if;		
			else --descida FM (de 5 em 5)
				if unidades_fm=0 then
					unidades_fm:=5;
					if dezenas_fm=0 then
						dezenas_fm:=9;
						if centenas_fm=0 then
							centenas_fm:=9;
							milhares_fm:=milhares_fm-1;
						else
							centenas_fm:=centenas_fm-1;
						end if;
					else
						dezenas_fm:=dezenas_fm-1;
					end if;
				else
				unidades_fm:=0; --5 ou 0
				end if;
			end if;
		end if;
	end if;
-----------------------------------------------------------------------
---------------------seletor de saida ---------------------------------

		if seletor='0' then --AM
		
			D4 <= conv_std_logic_vector (unidades_am, 4);
			D3 <= conv_std_logic_vector (dezenas_am, 4);
			D2 <= conv_std_logic_vector (centenas_am, 4);
			D1 <= conv_std_logic_vector (milhares_am, 4);
		else
			D4 <= conv_std_logic_vector (unidades_fm, 4);
			D3 <= conv_std_logic_vector (dezenas_fm, 4);
			D2 <= conv_std_logic_vector (centenas_fm, 4);
			D1 <= conv_std_logic_vector (milhares_fm, 4);
		end if;

	end process;
end contar;