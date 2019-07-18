`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:37:57 07/01/2019 
// Design Name: 
// Module Name:    maxpool 
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
module maxpool(
		input 			[7:0]		in1,
		input				[7:0]		in2,
		input				[7:0]		in3,
		input				[7:0]		in4,
		input							clk,		
		input 						enable,	//enable for start maxpooling				
		output	reg	[7:0]		op		
		//output	reg				maxready	//maxpool is ready bro
    );
	 always @ (posedge clk) begin
			if (enable) begin
						  if (in1 > in2 	&& in1 > in3 	&& in1 > in4) begin
							op		=	in1;
					end
					else if (in2 > in3 	&& in2 > in4 		&& in2 >=in1) begin
							op		=	in2;
					end
					else if (in3 >	in4 && in3 >= in2 	&& in3>= in1) begin
							op		=	in3;
					end
					else if (in4 >= in3 && in4 >= in2 && in4 >= in1) begin
							op		=	in4;
					end
			end
	 end
endmodule
