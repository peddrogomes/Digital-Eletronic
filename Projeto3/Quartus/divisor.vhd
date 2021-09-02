library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity divisor is
    Port ( clk   : in  std_logic;     -- input
           pulso : out std_logic          -- output
	  );
end divisor;

architecture Behavioral of divisor is
signal auxiliar: std_logic;
signal count: integer range 0 to 12500000;
begin

process(clk) -- Divisor do sinal de clock da placa
begin
	if rising_edge(clk) then
		count<=count+1;
		if count=(12500000) then
			count<=0;
			auxiliar<= not auxiliar;
		end if;
	end if;
end process;

pulso<=auxiliar;

end Behavioral;