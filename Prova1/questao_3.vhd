LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
use IEEE.numeric_std.all;

ENTITY questao_3 IS
PORT( nickel_in, dime_in, quarter_in : in std_logic;
		clk, rst : in std_logic;
		nickel_out, dime_out, candy_out : out std_logic 
			
	);
END questao_3;

ARCHITECTURE vhd2 OF questao_3 IS
VARIABLE	din : INTEGER RANGE 45 TO 0;
BEGIN
	PROCESS(nickel_in, dime_in, quarter_in, rst) --calcula o dinheiro inserido
	signal aux1, aux2, aux3 : std_logic;
	BEGIN
		IF quarter_in='1' THEN
			aux1:=0;
			din:=din+25;
		ELSE
			aux1:=1;
		END IF;
		IF dime_in='1' THEN
			aux2:=0;
			din:=din+10;
		ELSE
			aux2:=1;
		END IF;
		IF nickel_in='1' THEN
			aux3:=0;
			din:=din+5;
		ELSE
			aux3:=1;
		END IF;
		IF rst=1 THEN
			din:=0;
		END IF;		
	END PROCESS;
	
	
	PROCESS (clk)
	signal count : integer range 0 to 1000;
	signal troco5, troco10, troco15, troco20 : std_logic;
	BEGIN
			IF din>=25 THEN
				din:=din-25;
				candy_out<=1;
				
				IF din>=10 THEN --troco pra 10
			
					din:=din-10;
					troco10:=1;
					
					IF din>=10 THEN --troco pra 20
						din:=din-10;
						troco20:=1;
						troco10:=0;
					END IF;
					
					IF din>=5 THEN --troco pra 15
						din:=din-5;
						troco15:=1;
						troco10:=0;
					END IF;
				ELSE
					IF din>=5 THEN --troco pra 5
						troco5:=1;
					END IF;
				END IF;	
			END IF;
		
		IF rising_edge(clk) AND candy_out=1 THEN
			IF count=1000 THEN --time do candy
				candy_out<=0;				
				count:=0;
			ELSE
				count:=count+1;
			END IF;
		END IF;			
		IF rising_edge(clk) AND troco5=1 THEN		
			IF count=1000 THEN --troco de 5			
				candy_out<=0;				
				count:=0;				
				nickel_out<=0;				
				troco5:=0;				
			ELSE
				count:=count+1;				
				nickel_out<=1;				
			END IF;	
		END IF;		
		IF rising_edge(clk) AND troco10=1 THEN		
			IF count=1000 THEN --troco de 10			
				candy_out<=0;				
				count:=0;				
				dime_out<=0;				
				troco10:=0;				
			ELSE
				count:=count+1;				
				dime_out<=1;				
			END IF;	
		END IF;		
		IF rising_edge(clk) AND troco20=1 THEN		
			IF count=1000 THEN --troco de 20			
				candy_out<=0;				
				count:=0;				
				dime_out<=0;				
				troco20:=0;				
				troco10:=1;				
			ELSE
				count:=count+1;				
				dime_out<=1;				
			END IF;	
		END IF;		
	END PROCESS;
END vhd2;