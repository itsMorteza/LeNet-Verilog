`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:31:27 07/02/2019 
// Design Name: 
// Module Name:    MAX_POOL 
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
module MAX_POOL #(
		parameter   integer WIDTH = 2,
		parameter 	integer HEIGHT = 2,
		parameter   integer CHANNEL = 3
    )
    (
    input 		[8 * WIDTH * HEIGHT * CHANNEL - 1 : 0]			indata,
	 input																	clk,
	 input 																	enable,
    output 	reg [7 : 0]												 	result,
	 output  reg [7:	0]													adrressout,
	 output	reg															maxpoolingdone,
	 output	reg 															maxpoolFIN
    );
    
    wire [8 - 1 : 0] dataArray[0 : CHANNEL - 1][0 : HEIGHT-1][0 : WIDTH - 1];
    wire [8 * 4 * HEIGHT * WIDTH - 1 : 0]data_Array;
	 reg 	[7:0] 	C_adr;
	 reg 	[7:0] 	X_adr;
	 reg 	[7:0] 	Y_adr;
    genvar 			i, j, k, m, n;
	 wire [20:0]	address;
	 wire [7:0] 	channel_ad;
	// wire	[7:0]		poolout		[20:0][20:0][20:0];
	 //aschannel_ad
    generate       
        for(i = 0; i < CHANNEL; i = i + 1) begin
            for(j = 0; j < HEIGHT; j = j + 1) begin
                for(k = 0; k < WIDTH; k = k + 1) begin
                    assign dataArray[i][j][k] = indata[(i * HEIGHT * WIDTH + j * HEIGHT + k)
						  * WIDTH + WIDTH +: 8];
                end
            end
        end      
    endgenerate
    
   initial begin
		C_adr	=	0;
		X_adr = 	0;
		Y_adr	=	0;
	end
    maxpool Pooling (
								 .in1(dataArray[C_adr][2*Y_adr][2*X_adr]), 
								 .in2(dataArray[C_adr][2*Y_adr][2*X_adr+1]), 
								 .in3(dataArray[C_adr][2*Y_adr+1][2*X_adr]), 
								 .in4(dataArray[C_adr][2*Y_adr+1][2*X_adr+1]), 
								 .op(result));
//witout clock
	always @ (posedge clk)begin
		if (enable) begin
			adrressout = C_adr * HEIGHT * WIDTH / 4  + Y_adr * WIDTH/2 + X_adr;
			X_adr = X_adr + 1; maxpoolingdone  = 1;
			if (X_adr	==		WIDTH/2) begin
				X_adr = 0;
				Y_adr = Y_adr + 1;
			end
			if (Y_adr	==		HEIGHT/2) begin
				Y_adr = 0;
				C_adr = C_adr + 1;
			end
			if (C_adr	==		CHANNEL) begin
				C_adr = 0;
				maxpoolFIN  =  1 ;
			end
		end
		else begin
			maxpoolingdone = 0;
			C_adr	=	0;
			X_adr = 	0;
			Y_adr	=	0;
		end
	end
endmodule
