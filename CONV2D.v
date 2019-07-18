`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:36:07 07/02/2019 
// Design Name: 
// Module Name:    CONV2D 
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
module CONV2D#(    
    parameter  WIDTH 	= 	3,
    parameter  HEIGHT 	= 	3,
    parameter  CHANNEL 	= 	1,
	 parameter 	FILTER 	=	32,
	 parameter  KERNELSIZE = 9
    )(
		input																												clk,
		input																												enable,
		input 			[8 * WIDTH 		* 	HEIGHT 		* 	CHANNEL 	- 	1 	: 0]							indata,
		input 			[8 * FILTER		*	KERNELSIZE	* 	CHANNEL  - 1 	: 0]							filterWeight,
		output	reg	[FILTER			*	WIDTH 		* 	HEIGHT 	- 1 	: 0]							address_out,
		output 	reg	  [7  : 0] 																					result,
		output	reg																									dataready,
		output   reg 																									finish
    );
		wire 	DSR;
		reg	[7:0]	Filter_adr;
		reg	[7:0] completedconv;
		wire  	[7:0] xyadress;
		wire 	[7:0] out;
		wire 	[20:0]	inaddress;
		initial begin result = 0; end
		initial begin
			Filter_adr	=	0;
			result=	0;
			address_out = 0;
			completedconv	=	0;
		//	x_a=0;y_a=0;c_a=0;
		end
		genvar i;
		// wire [7 : 0] dataArray[0 : CHANNEL - 1][0 : HEIGHT-1][0 : WIDTH - 1];
		 //wire [8*( CHANNEL *HEIGHT* WIDTH )*9- 1: 0] data_Array;

			conv_main #(WIDTH,HEIGHT,CHANNEL	)mid_conv (.clk(clk), .indata(indata),
			.filterWeight(filterWeight[72*(Filter_adr) +: 72]),
			.result(out),.res_address(xyadress),  .dataready(DSR));
		always @ (posedge clk) begin
				address_out	=	Filter_adr * CHANNEL * HEIGHT * WIDTH + completedconv * HEIGHT * WIDTH + xyadress;
				if (DSR) begin
					result	= out;
					dataready		=	1;
					completedconv	=	completedconv	+	1;
				end
				else begin dataready = 0; end
				if (completedconv == WIDTH * HEIGHT)begin
					Filter_adr = Filter_adr+1;
				end
				if (Filter_adr	==	FILTER)begin
					finish = 1;
					Filter_adr = 0;
				end
				else begin finish = 0; end 
		end
endmodule
