`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:45:33 06/30/2019 
// Design Name: 
// Module Name:    CONV 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module conv #(
	parameter filtersize = 9
	)(
// Global signals
//	Input Buffer
	input 			[8*filtersize-1:0]	ifmap,
	input 			[8*filtersize-1:0]	kernel,
	input 										clk,
	output		 	[7:0]						ofmap
);

	wire 	 signed[7:0] outtemp;
	wire  [7:0]	temp1;
	wire  [7:0]	temp2;
	wire  [7:0]	temp3;
	wire  [7:0]	temp4;
	wire  [7:0]	temp5;
	wire  [7:0]	temp6;
	wire  [7:0]	temp7;
	wire  [7:0]	temp8;
	wire  [7:0]	temp9;
		// Instantiate the module
		mixer_pixel mix01 (
			 .A(ifmap[7:0]), 
			 .floating(kernel[7:0]),
			 .B(temp1)
			 );
		// Instantiate the module
		mixer_pixel mix02 (
			 .A(ifmap[15:8]), 
			 .floating(kernel[15:8]), 
			 .B(temp2)
			 );
		mixer_pixel mix03 (
			 .A(ifmap[23:16]), 
			 .floating(kernel[23:16]), 
			 .B(temp3)
			 );
		mixer_pixel mix04 (
			 .A(ifmap[31:24]), 
			 .floating(kernel[31:24]), 
			 .B(temp4)
			 );
		mixer_pixel mix05 (
			 .A(ifmap[39:32]), 
			 .floating(kernel[39:32]), 
			 .B(temp5)
			 );
		mixer_pixel mix06 (
			 .A(ifmap[47:40]), 
			 .floating(kernel[47:40]), 
			 .B(temp6)
			 );
		mixer_pixel mix07 (
			 .A(ifmap[55:48]), 
			 .floating(kernel[55:48]), 
			 .B(temp7)
			 );
		mixer_pixel mix08 (
			 .A(ifmap[63:56]), 
			 .floating(kernel[63:56]), 
			 .B(temp8)
			 );
		mixer_pixel mix09 (
			 .A(ifmap[71:64]), 
			 .floating(kernel[71:64]), 
			 .B(temp9)
			 );
		average_conv AV_conv (
			 .t1(temp1), 
			 .t2(temp2), 
			 .t3(temp3), 
			 .t4(temp4), 
			 .t5(temp5), 
			 .t6(temp6), 
			 .t7(temp7), 
			 .t8(temp8), 
			 .t9(temp9), 
			 .op(outtemp)
			 );
			 Relu conv_relu (
				.data(outtemp), 
				.clk(clk),
				.result(ofmap)
				);
endmodule