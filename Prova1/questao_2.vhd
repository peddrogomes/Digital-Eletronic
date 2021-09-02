LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
use IEEE.numeric_std.all;

ENTITY questao_2 IS
	PORT( 
	teclado : in std_logic_Vector(9 DOWNTO 0);
	clock_in : in std_logic;
	startn, stopn, clearn, door_closed : in std_logic;
	
	mag_on : out std_logic;
	min_segs, sec_tens_segs, sec_ones_segs : out std_logic_vector(6 downto 0)	
	
	);
END questao_2;

ARCHITECTURE vhd1 OF questao_2 IS
VARIABLE dig1, dig2, dig3: INTEGER RANGE 0 TO 9; 
BEGIN 


	PROCESS (teclado, dig1, dig2, dig3, dig)
	VARIABLE dig: INTEGER RANGE 0 TO 9;
	signal en: std_logic;
	BEGIN 
	
	 --interpretador do digito do teclado --
		CASE teclado IS
			WHEN "1000000000" => dig <=0;
			WHEN "0100000000" => dig <=1;
			WHEN "0010000000" => dig <=2;
			WHEN "0001000000" => dig <=3;
			WHEN "0000100000" => dig <=4;
			WHEN "0000010000" => dig <=5;
			WHEN "0000001000" => dig <=6;
			WHEN "0000000100" => dig <=7;
			WHEN "0000000010" => dig <=8;
			WHEN "0000000001" => dig <=9;
			WHEN OTHERS => dig <= 0;
		END CASE;

		--faz o digito andar pra frente e insere outro no mais a direita
		IF not(dig='0') and en='1' THEN
			en:=0;
			IF not(dig1='0') THEN
				IF not(dig2='0') THEN
					dig3:=dig2;
					dig2:=dig1;
					dig1:=dig;
					
				ELSE
					dig2:=dig1;
					dig1:=dig;
					
				END IF;
			ELSE
			dig1:=dig;
			dig:=0;
			END IF;
		ELSE
			en:=1;
		END IF;

		--decodificador dos digitos--
		CASE dig1 IS
			WHEN 0 => sec_ones_segs <="0000001";
			WHEN 1 => sec_ones_segs <="1001111";
			WHEN 2 => sec_ones_segs <="0010010";
			WHEN 3 => sec_ones_segs <="0000110";
			WHEN 4 => sec_ones_segs <="1001100";
			WHEN 5 => sec_ones_segs <="0100100";
			WHEN 6 => sec_ones_segs <="0100000";
			WHEN 7 => sec_ones_segs <="0001111";
			WHEN 8 => sec_ones_segs <="0000000";
			WHEN 9 => sec_ones_segs <="0000100";
		END CASE;

		CASE dig2 IS
			WHEN 0 => sec_tens_segs <="0000001";
			WHEN 1 => sec_tens_segs <="1001111";
			WHEN 2 => sec_tens_segs <="0010010";
			WHEN 3 => sec_tens_segs <="0000110";
			WHEN 4 => sec_tens_segs <="1001100";
			WHEN 5 => sec_tens_segs <="0100100";
			WHEN 6 => sec_tens_segs <="0100000";
			WHEN 7 => sec_tens_segs <="0001111";
			WHEN 8 => sec_tens_segs <="0000000";
			WHEN 9 => sec_tens_segs <="0000100";
		END CASE;
		
		CASE dig3 IS
			WHEN 0 => min_segs <="0000001";
			WHEN 1 => min_segs <="1001111";
			WHEN 2 => min_segs <="0010010";
			WHEN 3 => min_segs <="0000110";
			WHEN 4 => min_segs <="1001100";
			WHEN 5 => min_segs <="0100100";
			WHEN 6 => min_segs <="0100000";
			WHEN 7 => min_segs <="0001111";
			WHEN 8 => min_segs <="0000000";
			WHEN 9 => min_segs <="0000100";
		END CASE;
		END PROCESS;
		
		--funcionamento do microondas
		
	PROCESS (cllock_in, dig1, dig2, dig3, startn, stopn, clearn, door_closed)
	signal aux: std_logic;
	BEGIN 
		IF startn and door_closed and (not stopn) THEN
			mag_on<=1;
			IF rising_edge(clock_in) THEN --contagem regressiva
					IF not dig1='0' THEN
						dig1:=dig1-1;
					ELSE
						IF not dig2='0' THEN
							dig2:=dig2-1;
						ELSE
							IF not dig3='0' THEN
								dig3:=dig3-1;
							ELSE
							END IF;
						END IF;
					END IF;
			END IF;
		ELSE
			mag_on<=0;	
		END IF;
		IF clearn THEN
			dig1:=0;
			dig2:=0;
			dig3:=0;		
		END IF;
				
END vhd1;


----7 seg
--WITH a SELECT 
--s <=  "0000001" WHEN "0000",
--		"1001111" WHEN "0001",
--		"0010010" WHEN "0010",
--		"0000110" WHEN "0011",
--		"1001100" WHEN "0100",
--		"0100100" WHEN "0101",
--		"0100000" WHEN "0110",
--		"0001111" WHEN "0111",
--		"0000000" WHEN "1000",
--		"0000100" WHEN "1010";
--
--		