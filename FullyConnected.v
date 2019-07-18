`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:32:44 07/01/2019 
// Design Name: 
// Module Name:    FullyConnected 
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
module FullyConnected #(
		parameter 	nerunnum	=	100,
		parameter  	featurenum	=	128
		)
		(
		input															clk,
		input															enable,
		input				[8*featurenum-1:0]					feature,
		input				[8*nerunnum*featurenum-1:0]		weight,
		output 	reg												FCfinish,
		output	reg		[7:0]									currentnerun,
		output 	reg	 	[7:0]				 					out_F 
    );
			//define variable
			genvar  				i , j , k;
			integer 				 m, n; 
			wire		signed [10:0]	out  [nerunnum-1:0][featurenum-1:0];
			reg		signed [7:0]	out_actvated;
			reg 		signed  [16:0]       sum;
			initial begin
				currentnerun	=	0;
				FCfinish			=	0;
			end
			 generate 
					for(j = 0; j < featurenum; j = j + 1) begin
						  mixer_pixel(feature[(j + 1) * 8 +: 8], weight[(currentnerun * featurenum + j+1) * 8 +:  8],
						  out[currentnerun][j]);
					end
			 endgenerate
			 Relu activefun(.data(sum), .clk(clk), .result(out_actvated));
			 always @(posedge 	clk) begin
				if (enable) begin
						FCfinish=0;
						sum = 0;
						for(n = 0; n < featurenum; n = n + 1) begin
							 sum = sum + out[currentnerun][n];
						end
						out_F	=	out_actvated;
						currentnerun= currentnerun + 1;
						if (currentnerun >= nerunnum)begin
								FCfinish	=	1;
						end
				end
			 end
endmodule
