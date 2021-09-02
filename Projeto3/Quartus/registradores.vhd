library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity registradores is
	port (
	 D1_in, D2_in, D3_in, D4_in: in std_logic_vector (3 downto 0);
	 B3, B1_b, B2_b : in std_logic;
	
	seletor, clk : in std_logic; --1=FM , 0=AM.
	
	mux_seletor : out std_logic;
	
	D1_out, D2_out, D3_out, D4_out: out std_logic_vector (3 downto 0);
	load : out std_logic
	);
end registradores;	

architecture registrar of registradores is
begin
	
	
	process (clk, seletor,D1_in, D2_in, D3_in, D4_in,B3, B1_b, B2_b)
		variable reg11_am, reg11_fm : std_logic_vector (3 downto 0);
		variable reg12_am, reg12_fm : std_logic_vector (3 downto 0);
		variable reg13_am, reg13_fm : std_logic_vector (3 downto 0);
		variable reg14_am, reg14_fm : std_logic_vector (3 downto 0);
		
		variable reg21_am, reg21_fm : std_logic_vector (3 downto 0);
		variable reg22_am, reg22_fm : std_logic_vector (3 downto 0);
		variable reg23_am, reg23_fm : std_logic_vector (3 downto 0);
		variable reg24_am, reg24_fm : std_logic_vector (3 downto 0);
		
		variable count : integer range 7 downto 0:=0;
	begin
	
	----------registradores-----------
	

	
		if seletor='0' then --AM
		
			if B1_b='1' then
				reg11_am:=D1_in;
				reg12_am:=D2_in;
				reg13_am:=D3_in;
				reg14_am:=D4_in;
			elsif B2_b='1' then
				reg21_am:=D1_in;
				reg22_am:=D2_in;
				reg23_am:=D3_in;
				reg24_am:=D4_in;
			end if;
			
		else
		
			if B1_b='1' then
				reg11_fm:=D1_in;
				reg12_fm:=D2_in;
				reg13_fm:=D3_in;
				reg14_fm:=D4_in;
			elsif B2_b='1' then
				reg21_fm:=D1_in;
				reg22_fm:=D2_in;
				reg23_fm:=D3_in;
				reg24_fm:=D4_in;
			end if;
		
		end if;
		
	-------------------------------------------
	
	-------mostrar as radios registradas-------
	
	if rising_edge(clk) then
	
	if B3='0' and count>=4 then  --carregar o valor no contador
		load<='1';
		count:=0;
	elsif B3='0' and count>=1 then
		count:=0;
	else
		load<='0';  
	end if;
	
	if B3='1' then	
			count:=count+1;
			if count>=4 then 		--contador de 2s
				mux_seletor<='1';
				if seletor='0' then --AM
					if count>=6 then --1segundo aqui
						D1_out<=reg21_am;
						D2_out<=reg22_am;
						D3_out<=reg23_am;
						D4_out<=reg24_am;		
					else  --1segundo aqui
						D1_out<=reg11_am;
						D2_out<=reg12_am;
						D3_out<=reg13_am;
						D4_out<=reg14_am;
					end if;
				else
					if count>=6 then --1segundo aqui
						D1_out<=reg21_fm;
						D2_out<=reg22_fm;
						D3_out<=reg23_fm;
						D4_out<=reg24_fm;
					else  --1segundo aqui
						D1_out<=reg11_fm;
						D2_out<=reg12_fm;
						D3_out<=reg13_fm;
						D4_out<=reg14_fm;
					end if;
				end if;
			else
				mux_seletor<='0';
			end if;
		end if;
		
	end if;

end process;
end registrar;