// megafunction wizard: %LPM_DIVIDE%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: LPM_DIVIDE 

// ============================================================
// File Name: lpmdiv.v
// Megafunction Name(s):
// 			LPM_DIVIDE
//
// Simulation Library Files(s):
// 			lpm
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 20.1.0 Build 711 06/05/2020 Patches 0.08std SJ Lite Edition
// ************************************************************


//Copyright (C) 2020  Intel Corporation. All rights reserved.
//Your use of Intel Corporation's design tools, logic functions 
//and other software and tools, and any partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Intel Program License 
//Subscription Agreement, the Intel Quartus Prime License Agreement,
//the Intel FPGA IP License Agreement, or other applicable license
//agreement, including, without limitation, that your use is for
//the sole purpose of programming logic devices manufactured by
//Intel and sold by Intel or its authorized distributors.  Please
//refer to the applicable agreement for further details, at
//https://fpgasoftware.intel.com/eula.


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module lpmdiv (
	denom,
	numer,
	quotient,
	remain);

	input	[6:0]  denom;
	input	[6:0]  numer;
	output	[6:0]  quotient;
	output	[6:0]  remain;

	wire [6:0] sub_wire0;
	wire [6:0] sub_wire1;
	wire [6:0] quotient = sub_wire0[6:0];
	wire [6:0] remain = sub_wire1[6:0];

	lpm_divide	LPM_DIVIDE_component (
				.denom (denom),
				.numer (numer),
				.quotient (sub_wire0),
				.remain (sub_wire1),
				.aclr (1'b0),
				.clken (1'b1),
				.clock (1'b0));
	defparam
		LPM_DIVIDE_component.lpm_drepresentation = "UNSIGNED",
		LPM_DIVIDE_component.lpm_hint = "MAXIMIZE_SPEED=6,LPM_REMAINDERPOSITIVE=TRUE",
		LPM_DIVIDE_component.lpm_nrepresentation = "UNSIGNED",
		LPM_DIVIDE_component.lpm_type = "LPM_DIVIDE",
		LPM_DIVIDE_component.lpm_widthd = 7,
		LPM_DIVIDE_component.lpm_widthn = 7;


endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone IV E"
// Retrieval info: PRIVATE: PRIVATE_LPM_REMAINDERPOSITIVE STRING "TRUE"
// Retrieval info: PRIVATE: PRIVATE_MAXIMIZE_SPEED NUMERIC "6"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: PRIVATE: USING_PIPELINE NUMERIC "0"
// Retrieval info: PRIVATE: VERSION_NUMBER NUMERIC "2"
// Retrieval info: PRIVATE: new_diagram STRING "1"
// Retrieval info: LIBRARY: lpm lpm.lpm_components.all
// Retrieval info: CONSTANT: LPM_DREPRESENTATION STRING "UNSIGNED"
// Retrieval info: CONSTANT: LPM_HINT STRING "MAXIMIZE_SPEED=6,LPM_REMAINDERPOSITIVE=TRUE"
// Retrieval info: CONSTANT: LPM_NREPRESENTATION STRING "UNSIGNED"
// Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_DIVIDE"
// Retrieval info: CONSTANT: LPM_WIDTHD NUMERIC "7"
// Retrieval info: CONSTANT: LPM_WIDTHN NUMERIC "7"
// Retrieval info: USED_PORT: denom 0 0 7 0 INPUT NODEFVAL "denom[6..0]"
// Retrieval info: USED_PORT: numer 0 0 7 0 INPUT NODEFVAL "numer[6..0]"
// Retrieval info: USED_PORT: quotient 0 0 7 0 OUTPUT NODEFVAL "quotient[6..0]"
// Retrieval info: USED_PORT: remain 0 0 7 0 OUTPUT NODEFVAL "remain[6..0]"
// Retrieval info: CONNECT: @denom 0 0 7 0 denom 0 0 7 0
// Retrieval info: CONNECT: @numer 0 0 7 0 numer 0 0 7 0
// Retrieval info: CONNECT: quotient 0 0 7 0 @quotient 0 0 7 0
// Retrieval info: CONNECT: remain 0 0 7 0 @remain 0 0 7 0
// Retrieval info: GEN_FILE: TYPE_NORMAL lpmdiv.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL lpmdiv.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL lpmdiv.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL lpmdiv.bsf FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL lpmdiv_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL lpmdiv_bb.v TRUE
// Retrieval info: LIB_FILE: lpm