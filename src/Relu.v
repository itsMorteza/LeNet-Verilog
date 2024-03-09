`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:08:14 07/01/2019 
// Design Name: 
// Module Name:    Relu 
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
module Relu(
		input 					signed 	[7:0] data,
		input										clk,
		output 	 	reg		signed 	[7:0] result
    );
		initial begin result = 0 ;end
		parameter THRESSHOLD = 0;
		always @ (posedge clk)begin
			result = (data > THRESSHOLD)? (data) : (8'b00000000);
		end
endmodule
