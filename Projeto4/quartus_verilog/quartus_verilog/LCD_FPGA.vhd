
		entity LCD_FPGA is
		generic (fclk: natural := 50_000_000); -- 50MHz , cristal do kit EE03
		port (
		       clk         :     in bit; 
				 RS, RW      :    out bit;
		       E           : buffer bit;  
		       DB          :    out bit_vector(7 downto 0); 
				 estado      :		in bit_vector(1 downto 0));
		end LCD_FPGA;



		architecture hardware of LCD_FPGA is
		type state is (FunctionSetl, FunctionSet2, FunctionSet3,
		 FunctionSet4,FunctionSet5,FunctionSet6,FunctionSet7,FunctionSet8,FunctionSet9,FunctionSet10,FunctionSet11,FunctionSet12,
		 FunctionSet13,FunctionSet14,FunctionSet15, ClearDisplay, DisplayControl, EntryMode, 
		 WriteData1, WriteData2, WriteData3, WriteData4, WriteData5,WriteData6,WriteData7,WriteData8,WriteData9,WriteData10,WriteData11,
		 WriteData12,WriteData13,WriteData14,WriteData15,SetAddress1, ReturnHome);
		signal pr_state, nx_state: state; 
		begin
		
---—Clock generator (E->500Hz) :---------
		process (clk)
		variable count: natural range 0 to fclk/1000; 
		begin
			if (clk' event and clk = '1') then 
				count := count + 1;
				if (count=fclk/1000) then 
				 E <= not E; 
				 count := 0; 
				end if; 
			end if; 
		end process;
		
-----Lower section of FSM:---------------
		process (E) 
		begin
			if (E' event and E = '1') then 
			
				pr_state <= FunctionSetl; 
		
		pr_state <= nx_state; 
		
		end if; 
		end process;
		
-----Upper section of FSX:---------------
		process (pr_state, estado ) --colocar o estado aqui
		--variable estado : bit_vector(1 downto 0);
		begin
		
		--estado:="10";
		
		case pr_state is

		when FunctionSetl => 
		RS<= '0'; RW<= '0'; 
		DB<= "00111000"; 
		nx_state <= FunctionSet2; 
		when FunctionSet2 => 
		RS<= '0'; RW<= '0'; 
		DB <= "00111000";
		nx_state <= FunctionSet3; 
		when FunctionSet3 => 
		RS <= '0'; RW<='0'; 
		DB <= "00111000"; 
		nx_state <= FunctionSet4;

		when   FunctionSet4   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= FunctionSet5;

		when   FunctionSet5   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= FunctionSet6;

		when   FunctionSet6   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= FunctionSet7;

		when   FunctionSet7   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= FunctionSet8;

		when   FunctionSet8   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= FunctionSet9;

		when   FunctionSet9   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= FunctionSet10;

		when   FunctionSet10   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= FunctionSet11;

		when   FunctionSet11   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= FunctionSet12;

		when   FunctionSet12   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= FunctionSet13;

		when   FunctionSet13   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= FunctionSet14;

		when   FunctionSet14   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= FunctionSet15;

		when   FunctionSet15   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= ClearDisplay;


		when ClearDisplay =>
		RS<= '0'; RW<= '0';
		DB <= "00000001";
		nx_state   <=   DisplayControl; 
		
		when   DisplayControl   =>
		RS<= '0';   RW<=  '0';
		DB   <=  "00001100";
		nx_state <= EntryMode; 
		
		when EntryMode =>
		RS<= '0'; RW<= '0';
		DB <= "00000110";
		nx_state   <=  SetAddress1; 
		
		
		when SetAddress1 =>
		RS<=   '0';   RW<=   '0';
		DB   <=  "10000000";   --COMANDO PARA POSICIONAR O CURSOR NA LINHA 0 COLUNA 5
		nx_state  <= WriteData1; 
			
		when  WriteData1 =>
		RS<=   '1';   RW <='0';
		DB   <=   X"51";   				  --'Q
		nx_state <= WriteData2;
				
		when WriteData2 =>
		RS<= '1'; RW<= '0';
		DB <= X"55";                    --'U'
		nx_state <= WriteData3; 
		
		when WriteData3 =>
		RS<= '1'; RW<= '0';
		DB <= X"41";                    --'A'
		nx_state  <= WriteData4; 
		
		when  WriteData4   =>
		RS<=   '1';   RW<=   '0';
		DB   <=  X"52";                 --'R'
		nx_state  <= WriteData5; 

		when  WriteData5   =>
		RS<=   '1';   RW<=   '0';
		DB   <=  X"54";                 --'T'
		nx_state  <= WriteData6;

		when  WriteData6   =>
		RS<=   '1';   RW<=   '0';
		DB   <=  X"4f";                 --'0'
		nx_state  <= WriteData7;

		when  WriteData7   =>
		RS<=   '1';   RW<=   '0';
		DB   <=  X"20";                 --'_'
		nx_state  <= WriteData8;

		when  WriteData8   =>
		RS<=   '1';   RW<=   '0';
		DB   <=  X"58";                 --'X'
		nx_state  <= WriteData9;
		
		when  WriteData9   =>
		RS<=   '1';   RW<=   '0';
		DB   <=  X"20";                 --'_'
		nx_state  <= WriteData10;
	
	
		when WriteData10 =>
		RS<= '1'; RW<= '0';
		if estado="01" then --quente
			DB <= X"51";   						
		elsif estado="10" then --frio
			DB <= X"46"; 
		else  --normal
			DB <= X"4e"; --'N'
		end if;
		nx_state <= WriteData11; 


		when WriteData11 =>
		RS<= '1'; RW<= '0';
		if estado="01" then --quente
			DB <= X"55";   						
		elsif estado="10" then --frio
			DB <= X"52";  
		else  --normal
			DB <= X"4f";      --'O'
		end if;
		nx_state <= WriteData12;

		when WriteData12 =>
		RS<= '1'; RW<= '0';
		if estado="01" then --quente
			DB <= X"45";   						
		elsif estado="10" then --frio
			DB <= X"49"; 
		else
			DB <= X"52"; 		--'R'
		end if;
		nx_state <= WriteData13;

		when WriteData13 =>
		RS<= '1'; RW<= '0';
		if estado="01" then --quente
			DB <= X"4e";   						
		elsif estado="10" then --frio
			DB <= X"4f"; 
		else		  --normal
			DB <= X"4d";                    --'M'
		end if;
		nx_state <= WriteData14;

		when WriteData14 =>
		RS<= '1'; RW<= '0';
		if estado="01" then --quente
			DB <= X"54";   						
		elsif estado="10" then --frio
			DB <= X"20"; 
		else  --normal
			DB <= X"41";                    --'A'
		end if;                    
		nx_state <= WriteData15;

		when WriteData15 =>
		RS<= '1'; RW<= '0';
		if estado="01" then --quente
			DB <= X"45";   						
		elsif estado="10" then --frio
			DB <= X"20"; 
		else  --normal
			DB <= X"4c";                    --'L'
		end if; 
		nx_state <= ReturnHome;


		when   ReturnHome   =>
		RS<=   '0';   RW<=  '0';
		DB   <=  "10000000";
		nx_state <= WriteData1; 
		end case; 
		end process;
		
	end hardware;



















