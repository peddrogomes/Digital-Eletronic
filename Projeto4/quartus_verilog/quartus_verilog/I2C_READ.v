module I2C_READ(
	clk,
	rst_n,
	scl,sda,data
);
 
input clk;//50MHz  
input rst_n; 
  
output scl;//SCL 
inout  sda;// SDA 
output [15:0] data;//
  
reg [15:0]data_r;//
reg scl;//SCL  
reg sda_r;//SDA   
reg sda_link;//SDA   
reg [7:0]scl_cnt;//SCL  
reg [2:0]cnt;
reg [25:0]timer_cnt;
reg [3:0]data_cnt;
reg [7:0]address_reg;
reg [8:0]state; 
always@(posedge clk or negedge rst_n) // conta de 0 até 199 na velocidade do clock 50MHz
    begin  
        if(!rst_n)  
            scl_cnt <= 8'd0;  
        else if(scl_cnt == 8'd199)  
            scl_cnt <= 8'd0;  
        else  
            scl_cnt <= scl_cnt + 1'b1;  
    end  
always@(posedge clk or negedge rst_n)   // divide a contagem em 4 pulsos
    begin  
        if(!rst_n)  
            cnt <= 3'd5;  
        else   
            case(scl_cnt)  
                8'd49: cnt <= 3'd1;
                8'd99: cnt <= 3'd2; 
                8'd149:cnt <= 3'd3; 
                8'd199:cnt <= 3'd0; 
               default: cnt <= 3'd5;  
            endcase  
    end  
`define SCL_HIG (cnt == 3'd1)  // scl esta alto nesse momento, no meio do ciclo
`define SCL_NEG (cnt == 3'd2)  // scl vai para baixo (negedge)
`define SCL_LOW (cnt == 3'd3)  // scl esta baixo nesse momento, no meio do ciclo
`define SCL_POS (cnt == 3'd0)  // scl vai para alto (posedge)
always@(posedge clk or negedge rst_n)  // scl 250khz (período 4us)
    begin  
        if(!rst_n)  
            scl <= 1'b0;  
        else if(`SCL_POS)  // scl vai para alto 
            scl <= 1'b1;  
        else if(`SCL_NEG)  // scl vai para baixo
            scl <= 1'b0;  
    end  
always@(posedge clk or negedge rst_n)  // contador de 1s
    begin  
        if(!rst_n)  
            timer_cnt <= 26'd0;  
        else if(timer_cnt == 26'd49_999_999)  
            timer_cnt <= 26'd0;  
        else   
            timer_cnt <= timer_cnt + 1'b1;  
    end  
	 
parameter IDLE  		= 9'b0_0000_0000,  
          START  		= 9'b0_0000_0010,  
          ADDRESS    = 9'b0_0000_0100,  
          ACK1       = 9'b0_0000_1000,  
          READ1  		= 9'b0_0001_0000,  
          ACK2       = 9'b0_0010_0000,  
          READ2  		= 9'b0_0100_0000,  
          NACK       = 9'b0_1000_0000,  
          STOP       = 9'b1_0000_0000;  

`define DEVICE_ADDRESS 8'b1001_0001 //só tem 1 sensor (1001 é o lm75, 000 é o endereço A2A1A0, o lsb indica leitura 

always@(posedge clk or negedge rst_n)  
    begin  
        if(!rst_n)  
            begin  //estado inicial dos registradores
                data_r  	<= 16'd0;  
                sda_r       <= 1'b1;  
                sda_link    <= 1'b1;  //permite enviar no proximo estado
                state       <= IDLE;  
                address_reg <= 8'd0;  
                data_cnt    <= 4'd0;  
            end  
        else   
            case(state)  
                IDLE:  //fica nesse estado até o terminar o segundo atual
                    begin  
                        sda_r   	<= 1'b1;  
                        sda_link <= 1'b1;  //permite enviar no proximo estado
                        if(timer_cnt == 26'd49_999_999)  
                            state <= START;  //vai para o START no segundo 1
                        else  
                            state <= IDLE;  
                    end  
                START: //colocamos o endereço de leitura no registrador que será enviado pelo sda
                    begin  
                        if(`SCL_HIG)  //define os valores no tempo 1s + 1us
                            begin  
                                sda_r       <= 1'b0;  
                                sda_link    <= 1'b1;  //permite enviar no proximo estado
                                address_reg <= `DEVICE_ADDRESS; //esse é o endereço do dispositivo e define apenas leitura 
                                state       			<= ADDRESS;  
                                data_cnt    			<= 4'd0;  
                            end  
                        else  
                            state <= START;  
                    end  
                ADDRESS:  
                    begin  
                        if(`SCL_LOW)  //começa no tempo 1s + 3us                                                         e envia todos os 8bits na velocidade de SCL 250kHz (4us)
                            begin  
                                if(data_cnt == 4'd8)  //quando enviar todos os bits vai para o proximo estado
                                    begin  
                                        state   	 <= ACK1;
                                        data_cnt 	 <= 4'd0;  
                                        sda_r       <= 1'b1;  
                                        sda_link    <= 1'b0;  //permite receber no proximo estado
                                    end  
                                else
                                    begin  
                                        state   <= ADDRESS;  //repete o estado até enviar todos os bits
                                        data_cnt <= data_cnt + 1'b1;  
                                        case(data_cnt)  
                                            4'd0: sda_r <= address_reg[7];
                                            4'd1: sda_r <= address_reg[6];
                                            4'd2: sda_r <= address_reg[5];
                                            4'd3: sda_r <= address_reg[4];
                                            4'd4: sda_r <= address_reg[3];
                                            4'd5: sda_r <= address_reg[2];
                                            4'd6: sda_r <= address_reg[1];
                                            4'd7: sda_r <= address_reg[0];
                                            default: ;  
                                        endcase  
                                    end  
                            end  
                        else 
                            state <= ADDRESS;  
                    end  
                ACK1: //caso o despositivo exista, ele responderá como um Acknowledge
                    begin  
                        if(!sda && (`SCL_HIG))  //(sda mantido baixo até o scl alto)
                            state <= READ1;  
                        else if(`SCL_NEG)  		//scl negedge
                            state <= READ1;  
                        else  
                            state <= ACK1;  
                    end  
                READ1:  //recebe os 8 bits msb do sensor por sda
                    begin  
                        if((`SCL_LOW) && (data_cnt == 4'd8))
								
                            begin  
                                state   		<= ACK2;  
                                data_cnt 		<= 4'd0;  
                                sda_r       	<= 1'b1;  
                                sda_link    	<= 1'b1;  //permite enviar no proximo estado
                            end  
                        else if(`SCL_HIG) //recebe os 8 bits durante scl alto
                            begin  
                                data_cnt <= data_cnt + 1'b1;  
                                case(data_cnt)  
                                    4'd0: data_r[15] <= sda;  
                                    4'd1: data_r[14] <= sda;  
                                    4'd2: data_r[13] <= sda;  
                                    4'd3: data_r[12] <= sda;  
                                    4'd4: data_r[11] <= sda;  
                                    4'd5: data_r[10] <= sda;  
                                    4'd6: data_r[9]  <= sda;  
                                    4'd7: data_r[8]  <= sda;  
                                    default: ;  
                                endcase  
                            end  
                        else  
                            state <= READ1;  
                    end  
                ACK2: //envia acknowledge para o sensor
                    begin     
                        if(`SCL_LOW)  
                            sda_r <= 1'b0;  //fallingedge
                        else if(`SCL_NEG)  
                            begin  
                                sda_r   	  <= 1'b1;  
                                sda_link    <= 1'b0;  //permite receber no proximo estado
                                state       <= READ2;  
                            end  
                        else  
                            state <= ACK2;  
                    end  
                READ2: //recebe os 8 bits lsb do sensor por sda
                    begin  
                        if((`SCL_LOW) && (data_cnt == 4'd8))  
                            begin  
                                state   		<= NACK;  
                                data_cnt 		<= 4'd0;  
                                sda_r       	<= 1'b1;  
                                sda_link    	<= 1'b1;  //permite enviar no proximo estado
                            end  
                        else if(`SCL_HIG)  //recebe os 8 bits durante scl alto
                            begin  
                                data_cnt <= data_cnt + 1'b1;  
                                case(data_cnt)  
                                    4'd0: data_r[7] <= sda;  
                                    4'd1: data_r[6] <= sda;  
                                    4'd2: data_r[5] <= sda;  
                                    4'd3: data_r[4] <= sda;  
                                    4'd4: data_r[3] <= sda;  
                                    4'd5: data_r[2] <= sda;  
                                    4'd6: data_r[1] <= sda;  
                                    4'd7: data_r[0] <= sda;  
                                    default: ;  
                                endcase  
                            end  
                        else  
                            state <= READ2;  
                    end  
                NACK: //aborta a comunicação com o sensor pt1
                    begin  
                        if(`SCL_LOW)  
                            begin  
                                state <= STOP;  
                                sda_r <= 1'b0;  //envia sda 0 para no proximo posedge encerrar
                            end  
                        else  
                            state <= NACK;  
                    end  
                STOP:  //quando scl for alto reinicia
                    begin  
                        if(`SCL_HIG)  
                            begin  
                                state <= IDLE;  // volta ao inicio
                                sda_r <= 1'b1;  //envia sda 1 (posedge) enquanto scl alto, encerra a comunicação
                            end  
                        else  
                            state <= STOP;  
                    end  
                default: state <= IDLE;  
            endcase  
    end  
assign sda   = sda_link ? sda_r: 1'bz;  //se sda_link 1 sda=sda_r, se sda_link 0 sda=1'bz
assign data  = data_r;  
endmodule
