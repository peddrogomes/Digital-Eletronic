module SEG_D(clk,rst_n,seg,data,cs, estado);
  
input clk;  
input rst_n;  
input [15:0]data;
output [7:0] seg;
output [3:0] cs;
output [1:0] estado;

reg [1:0] estado;
reg [7:0] seg;
reg [3:0] cs;
wire [4:0] dataout_buf;
reg [1:0] disp_dat;
reg [16:0] delay_cnt;



bin_decimaldigit bin_decimaldigit(
	.reset(rst_n),
	.disp_sel2b(disp_dat),
	.data(data[14:8]),
	.decimal(data[7]),
	.decimal_digit(dataout_buf)
);

always@(posedge clk,negedge rst_n)
	begin
		if(!rst_n)
			delay_cnt<=16'd0;
		else if(delay_cnt==16'd50000)
			delay_cnt<=16'd0;  
		else   
			delay_cnt<=delay_cnt +1;  
	end

always@(posedge clk,negedge rst_n)  //maquina de estado dos digitos
	begin
		if(!rst_n)
			disp_dat<=2'd0;
		else if(delay_cnt==16'd50000)  
			disp_dat<=disp_dat + 1'b1;  
		else
			disp_dat<=disp_dat;  
	end  
      
always@(disp_dat)  //decodificador da maquina de estado
	begin   
		case(disp_dat)  
			2'b00: cs = 4'b1110;
			2'b01: cs = 4'b1101;
			2'b10: cs = 4'b1011;
			2'b11: cs = (dataout_buf > 4'd0) ? 4'b0111 : 4'b1111; // Enable hundreds digit only if it's greater than 0
			default cs = 4'b1111;
		endcase
	end

always@(dataout_buf) //decodificador do 7seg
	begin   
		case(dataout_buf)  
			4'd0 : seg = 8'hc0; //0
			4'd1 : seg = 8'hf9; //1
			4'd2 : seg = 8'ha4; //2
			4'd3 : seg = 8'hb0; //3
			4'd4 : seg = 8'h99; //4
			4'd5 : seg = 8'h92; //5
			4'd6 : seg = 8'h82; //6
			4'd7 : seg = 8'hf8; //7
			4'd8 : seg = 8'h80; //8
			4'd9 : seg = 8'h90; //9
			default : seg =8'hc0; //0
		endcase
		if(disp_dat == 2'b01)
			seg = seg & 8'b01111111; // Add decimal point for second digit
	end
	
always@(data)
	begin
		if ((data[14:7])<9'b000110110) //menor que 27º
			estado = 2'b10;
		else if ((data[14:7])>9'b000111110) //maior que 31º
			estado = 2'b01;
		else
			estado = 2'b11;
	end
endmodule   