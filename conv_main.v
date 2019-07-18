`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:33:44 07/03/2019 
// Design Name: 
// Module Name:    conv_main 
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
module conv_main#(    
    parameter  WIDTH 	= 	28,
    parameter  HEIGHT 	= 	28,
    parameter  CHANNEL 	= 	1,
	 parameter	KERNELWIDTH =3,
	 parameter	KERNELHEIGHT =3
    )(
		input																										clk,
		input 			[8 * WIDTH 		* 	HEIGHT 	* 	CHANNEL 		    - 	1 	: 0]			indata,
		input 			[8 * 	CHANNEL 	* 	KERNELWIDTH *  KERNELHEIGHT - 	1 	: 0]			filterWeight,
		output 	reg   [7  	: 	0] 																		result,
		output	reg   [7		:	0]																			res_address,
		output	reg																							dataready);
		//	decleration
		wire	[8*KERNELWIDTH * KERNELHEIGHT -1:0] Datain;
		genvar i, j;
		reg   [2:0]    counter;
		reg	[7:0]		temp3;
		reg 	[7:0]		X_adr;
		reg	[7:0]		Y_adr;
		reg	[7:0]		C_adr;
		reg	[7:0]		PIXEL1;
		reg	[7:0]		PIXEL2;
		reg	[7:0]		PIXEL3;
		reg	[7:0]		PIXEL4;
		reg 	[15:0]	address;
		reg   [7:0]    temp2;
		wire	[7:0]		out,out2;
		wire 	[7:0]		temp;
		//integer x_a , y_a , c_a;
		initial begin
			X_adr = 	0;
			Y_adr	=	0;
			C_adr	=	0;
			result=	0;
			temp2  = 0;
			counter	=	0;
		//	x_a=0;y_a=0;c_a=0;
		end
		reg maxin;
		generate 
			for(i=0;i<3;i=i+1)begin
				for(j=0;j<3;j=j+1)begin
					assign temp = (X_adr > 0 && Y_adr> 0 && X_adr<WIDTH+1	&&	Y_adr<HEIGHT+1)?(indata[8*(address)+:8]):(8'b00000000);
					assign Datain[(i*3+j)*8 +:8]	= temp;
				end
			end
		endgenerate
		maxpool Maxpooling (.in1(PIXEL1), .in2(PIXEL2), .in3(PIXEL3), .in4(PIXEL4), .clk(clk),  .enable(maxin), .op(out2));
		always @ (posedge clk )begin
			
			temp2		=	temp2	+	out;
			address	=	C_adr *	HEIGHT 	*	WIDTH	+	(Y_adr)	*	WIDTH	+	(X_adr);
			res_address=Y_adr	*	WIDTH	+	X_adr;
			if	(C_adr	<	CHANNEL)begin
				maxin = 0;
				temp3		= 	temp2;
				dataready 	= 0;
			end
			C_adr	=	C_adr	+	1;
			if	(C_adr 	== CHANNEL)begin
					temp2	=	0;
					res_address=Y_adr	*	WIDTH	+	X_adr;
					X_adr	=	X_adr	+	1;
					C_adr	=	0;
					counter = counter + 1;
					if(counter == 1) begin  X_adr = X_adr +1;	PIXEL1 = temp3;maxin=0;	end
					if(counter == 2) begin	X_adr = X_adr -1; Y_adr = Y_adr + 1;	PIXEL2 = temp3; end
					if(counter == 3) begin	X_adr = X_adr +1; PIXEL3 = temp3;maxin=0;	end
					if(counter == 4) begin	X_adr = X_adr +1;counter = 0;	PIXEL4 = temp3; maxin = 1 ; dataready = 1; Y_adr = Y_adr - 1; result = out2;end 
					dataready	=	1;
			end
			if (X_adr	==	WIDTH+2)begin
				X_adr = 0;
				Y_adr = Y_adr +2;
			end
			if	(Y_adr		==	HEIGHT+2)begin
				Y_adr			=	0;
			//	dataready	=	1;
			//	enable		=	0;
			end
		end 
		//	mixing part 3*3
		conv MIX_part (
			 .ifmap(Datain), 
			 .kernel(filterWeight), 
			 .clk(clk),
			 .ofmap(out)
			 );
endmodule
