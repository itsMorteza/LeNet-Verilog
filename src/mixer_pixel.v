`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:21:55 06/28/2019 
// Design Name: 
// Module Name:    mixer_pixel 
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
module mixer_pixel(
		input 	signed [7:0] 	A,
		input		signed [7:0]		floating,
		//input		clk,
		output 	signed [7:0]	B
    );
	 assign 	B = A*floating;
	 wire 	[15:0]	result;
	 /*mixer_fp fpmix1 (
		.a(A), // input [15 : 0] a
		.b(floating), // input [15 : 0] b
		.clk(clk), // input clk
		.result(result) // output [15 : 0] result
		);
	mixer_fptofx floattofix (
		.a(result), // input [15 : 0] a
		.clk(clk), // input clk
		.result(B) // output [7 : 0] result
		);*/
endmodule
