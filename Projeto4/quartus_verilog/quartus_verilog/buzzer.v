module buzzer(
	clk,
	rst_n,
	acionar,
	buzzer_out
);
  
input clk;//50MHz  
input rst_n;
input [1:0]acionar;
  
output buzzer_out;


reg buzzer_r;
reg flag;

reg [14:0]cnt_2khz;	//frequecia do som 2kHz 0.5ms
reg [3:0]cnt_10hz;	//100ms
reg [4:0]cnt_4hz;		//250ms
reg [10:0]cnt_1hz;	//1s

reg clk_2khz;			//frequecia do som 2kHz 0.5ms
reg clk_10hz;			//100ms
reg clk_4hz;			//250ms
reg clk_1hz;			//1s


always@(posedge clk,negedge rst_n)
	begin
		if(!rst_n)
			begin
				cnt_2khz<=15'd0;
				clk_2khz<=1'd0;
			end
		else if(cnt_2khz==15'd12_499) //meio periodo de 2khz
			begin
				cnt_2khz<=15'd0;
				clk_2khz<=~clk_2khz; //2kHz 0.5ms
			end
		else   
			cnt_2khz<=cnt_2khz +1;  
	end

always@(posedge clk_2khz,negedge rst_n)
	begin
		if(!rst_n)
			begin
				cnt_10hz<=4'd0;
				clk_10hz<=1'd0;
			end
		else if(cnt_10hz==4'd9) //meio periodo de 10hz
			begin
				cnt_10hz<=4'd0;
				clk_10hz<=~clk_10hz; // 100ms 10Hz
			end
		else   
			cnt_10hz<=cnt_10hz +1;  
	end

always@(posedge clk_2khz,negedge rst_n)
	begin
		if(!rst_n)
			begin
				cnt_4hz<=5'd0;
				clk_4hz<=1'd0;
			end
		else if(cnt_4hz==5'd24) //meio periodo de 4hz
			begin
				cnt_4hz<=5'd0;
				clk_4hz<=~clk_4hz; // 250ms 4Hz
			end
		else   
			cnt_4hz<=cnt_4hz +1;		
	end

always@(posedge clk_2khz,negedge rst_n)
	begin
		if(!rst_n)
			begin
				cnt_1hz<=11'd0;
				clk_1hz<=1'd0;
			end
		else if(cnt_1hz==11'd999) //meio periodo de 1hz
			begin
				cnt_1hz<=11'd0;
				clk_1hz<=~clk_1hz; //1s 1Hz
			end
		else   
			cnt_1hz<=cnt_1hz +1;
	end
	
always@(posedge clk, negedge rst_n)
	begin
		if(!rst_n)
			begin
				buzzer_r<=1'd0;
			end
		else
			case(acionar)
				2'b01: //quente
					begin
						if (clk_1hz==1) // 1s (1Hz)
							begin
								if(clk_10hz==1) // 100ms (10Hz)
									begin
										buzzer_r<=clk_2khz;// som 2kHz
									end
								else
									begin
										buzzer_r<=1'b0;
									end	
							end
						else
							begin
								buzzer_r<=1'b0;
							end
					end
				2'b10: //frio
					begin
						if (clk_4hz==1) // 250ms (4Hz)
							begin
								if(clk_10hz==1) // 100ms (10Hz)
									begin
										buzzer_r<=clk_2khz; // som 2kHz
									end
								else
									begin
										buzzer_r<=1'b0;
									end	
							end
						else
							begin
								buzzer_r<=1'b0;
							end
					end
				default: 
						begin
							buzzer_r<=1'b0;
						end
			endcase
	end

assign buzzer_out = buzzer_r;
endmodule
