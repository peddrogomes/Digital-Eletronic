library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity debounce is
	generic (delay: natural := 500_000);  -- 100Hz, T=10ms
	
    port(    clk : in std_logic;
             botao: in std_logic;
				saida : out std_logic);

			end debounce;

architecture vhd of debounce is
    signal contador : integer range 0 to delay;
	 SIGNAL flipflops   : STD_LOGIC_VECTOR(1 DOWNTO 0);
    signal aux : std_logic;
    begin

    process(clk)
    begin
	 
		aux <= flipflops(0) xor flipflops(1);
		
        if rising_edge(clk) then
		  
				flipflops(0) <= botao;
				flipflops(1) <= flipflops(0);
				
				if (aux='1') then
					
					contador<=0;
				
				elsif (contador<delay) then
				
					contador <= contador + 1;
				else
					
				
				saida <= flipflops(1);
				 
				end if;

			end if;
		  
    end process;

end vhd;

