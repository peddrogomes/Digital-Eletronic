library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity debounce_v2 is
	generic (delay: natural := 500_000);  -- 100Hz, T=10ms
	
    port(   clk : in std_logic;
            b1, b2: in std_logic;
				modo : in std_logic;
				b1_a, b2_a, b3_a : out std_logic;
				b1_b, b2_b : out std_logic
				);
	end debounce_v2;

architecture vhd of debounce_v2 is
    signal cont1, cont2 : integer range 0 to delay;
	 SIGNAL ffd1, ffd2   : STD_LOGIC_VECTOR(1 DOWNTO 0);
    signal aux1, aux2 : std_logic;
	 signal b1_f,b2_f,b1_r,b2_r,b3_r : std_logic;
    begin


    process(clk,  b1, b2, modo, b1_f,b2_f,b1_r,b2_r,b3_r)
	 	variable flag1 : integer range 0 to 1 ;
		variable flag2 : integer range 0 to 1 ;
		begin
		
			aux1 <= ffd1(0) xor ffd1(1); -- 1 se entre dois pulsos de clock a entra for diferente
			aux2 <= ffd2(0) xor ffd2(1); -- detecta edges (completando o comentário de cima)
		
			if rising_edge(clk) then --inicio1
				ffd1(0) <= b1; 
				ffd1(1) <= ffd1(0); -- a entrada do botão de pulsos consecutivos
				
				ffd2(0) <= b2;
				ffd2(1) <= ffd2(0);
				
				if (aux1='1') then -- detectou borda(edge) antes do tempo
					cont1<=0;
					cont2<=0;
				elsif (cont1<delay) then -- sinal continuo por esse tempo
					cont1 <= cont1 + 1;
				else
					b1_f <= ffd1(1);
					
				end if; --fim2
--				
				if (aux2='1') then -- detectou borda(edge) antes do tempo
					cont2<=0;
					cont1<=0;
				elsif (cont2<delay) then -- sinal continuo por esse tempo
					cont2 <= cont2 + 1;
				else
					b2_f <= ffd2(1); 
					
				end if; --fim3
				
			end if; --fim1
			

			if (b1_f='1') and (b2_f='1') then --inicio4
				 --enquato os dois botoes tiverem apertados
					b1_r<='0';
					b2_r<='0';
					b3_r<='1';
					
			elsif (b1_f='1' and flag1=0) then
				
					b3_r<='0';
					b1_r<= not b1_r;
					flag1:=1;
						
			elsif (b2_f='1' and flag2=0) then --inicio12
						
					b3_r<='0';	
					b2_r<= not b2_r;
					flag2:=1;

			else
		
				flag1:=0;
				flag2:=0;
				b3_r<='0';
				
			end if;--fim4
	
	
--mux modo seleciona qual saída
		case modo is
			when '1' =>
				b1_a<=b1_r;
				b2_a<=b2_r;
				b3_a<=b3_r;
				b1_b<='0';
				b2_b<='0';
			when '0' =>
				b1_a<='0';
				b2_a<='0';
				b3_a<='0';
				b1_b<=b1_r;
				b2_b<=b2_r;
			when others =>
				b1_a<='0';
				b2_a<='0';
				b3_a<='0';
				b1_b<='0';
				b2_b<='0';
		end case;
		
    end process;
	
end vhd;

