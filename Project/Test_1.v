// Quartus Prime Verilog Template
// Unsigned Adder

module Test_1
#(parameter WIDTH=16)
(
	input [WIDTH-1:0] dataa,
	input [WIDTH-1:0] datab,
	input cin,
	output [WIDTH:0] result
);

	assign result = dataa + datab + cin;

endmodule
