`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:31:48 06/28/2019 
// Design Name: 
// Module Name:    processing_element 
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
module processing_element	#(
		parameter  	WIDTH 			= 	32,
		parameter  	HEIGHT 			= 	32,
		parameter  	CHANNEL 			= 	3,
		parameter 	FIRSTFILTER 	=	32,
		parameter 	SECFILTER 		=	64,
		parameter 	FIRSTLAYER 		=	100,
		parameter 	SECLAYER 		=	50,
		parameter 	DECLAYER 		=	10
	)(
		input																	clk,
		input																	enable,
		input 																reset,
		input 				[8*WIDTH*HEIGHT*CHANNEL-1:0]			pixel,
		output 		reg													done,
		output		reg	[10:0]										decied
		);

		reg				[20:0]																					counter;
		reg				[3:0]																						flag;
		wire																											dataready;
		reg				enable1,enable2,enable3,enable4,enable5;
		wire				finish1,finish2,finish3,finish4,finish5;
		reg 				[(WIDTH 	* 	HEIGHT	*	CHANNEL 	*	FIRSTFILTER	*	8)-1:0] 				weight1;
		reg 				[(WIDTH 	* 	HEIGHT 	*	FIRSTFILTER	*	8 / 4)-1:0] 						result1;
		reg 				[(WIDTH 	* 	HEIGHT 	*	FIRSTFILTER	*	SECFILTER	*	8 / 4)-1:0] 	weight2;
		reg 				[(WIDTH 	* 	HEIGHT 	*	SECFILTER	*	8 / 16)-1:0] 						result2;
		reg 				[(WIDTH 	* 	HEIGHT 	*	SECFILTER	*	FIRSTLAYER *	8 / 16)-1:0] 	weight3;
		reg 				[(FIRSTLAYER	*	8)-1:0] 															result3;
		reg 				[(	SECLAYER	*	FIRSTLAYER )-1:0]										 			weight4;
		reg 				[(SECLAYER	*	8)-1:0] 																result4;
		reg 				[(	SECLAYER	*	DECLAYER 	*	8)-1:0] 											weight5;
		wire				[7:0]																						out;
	 // first convolution  
		CONV2D #(WIDTH,HEIGHT,CHANNEL,FIRSTFILTER)CONVOLUTIONALLAYER1 (.clk(clk), .enable(enable1), .indata(pixel), .filterWeight(weight1), 
		.address_out(address_out), .result(out), .dataready(dataready), .finish(finish1) ); 
	///	layer 2
		// sec convolution
		CONV2D # (WIDTH/2,HEIGHT/2,FIRSTFILTER, SECFILTER) CONVOLUTIONALLAYER2 (.clk(clk), .enable(enable2), .indata(result1), .filterWeight(weight2), 
		.address_out(address_out), .result(out), .dataready(dataready), .finish(finish2) ); 
	//	fully connectend 	feature, 	weight,	FCfinish,	out_F 
		FullyConnected # (FIRSTLAYER , SECFILTER*WIDTH*HEIGHT/4) LayerOne (.clk(clk),.enable(enable3), .feature(result3), .weight(weight3), 
		.FCfinish(finish3), .currentnerun(currentnerun), .out_F(out));
	//	fully connectend 	feature, 	weight, 	FCfinish, 	out_F
		FullyConnected # (SECLAYER , FIRSTLAYER) Layertwo (.clk(clk),.enable(enable4), .feature(result4), .weight(weight4), 
		.FCfinish(finish4), .currentnerun(currentnerun), .out_F(out));
	//	Descied 	feature, 	weight, 	FCfinish, 	out_F
		FullyConnected # (DECLAYER , SECLAYER) Descision (.clk(clk),.enable(enable5), .feature(result4), .weight(weight5), 
		.FCfinish(finish5), .currentnerun(currentnerun), .out_F(out));
		always @ (posedge clk) begin
				if (enable)begin
					if (flag == 0 && finish1 != 1)begin
							enable1 = 1;
							if (dataready == 1)begin counter = counter +1; result1[counter * 8 +: 8] = out;end
					end
					else if(flag == 0 && finish1 == 1)begin  
						result1[(WIDTH 	* 	HEIGHT	*	CHANNEL 	*	FIRSTFILTER	*	8)-1 +: 8]	=	out;
						counter= 0;
						flag = 1; enable1 = 0;enable2=0;
					end
					else if(flag == 1 && finish2 != 1 && finish1 != 1)begin  
						enable2 = 1;
						if (dataready == 1)begin counter = counter +1; result2[counter * 8 +: 8] = out;end
					end
					else if(flag == 1 && finish2 == 1 )begin  
						flag = 2; enable3 = 0;enable2=0;
						counter = 0;
						result2[(WIDTH 	* 	HEIGHT	*	CHANNEL 	*	FIRSTFILTER	*	8)-1 +: 8]	=	out;
					end
					else if(flag == 2 && finish3 != 1 && finish2 != 1)begin  
						enable3 = 1;
						if (dataready == 1)begin counter = counter +1; result3[counter * 8 +: 8] = out;end
					end
					else if(flag == 2 && finish3 == 1 )begin  
						flag = 3; enable4 = 0;enable3=0;
						counter = 0;
						result3[(WIDTH 	* 	HEIGHT	*	CHANNEL 	*	FIRSTFILTER	*	8)-1 +: 8]	=	out;
					end
					else if(flag == 3 && finish4 != 1 && finish3 != 1)begin  
						enable4 = 1;
						if (dataready == 1)begin counter = counter +1; result4[counter * 8 +: 8] = out;end
					end
					else if(flag == 3 && finish4 == 1 )begin  
						flag = 3; enable4 = 0;enable5=0;
						counter = 0;
						result4[(WIDTH 	* 	HEIGHT	*	CHANNEL 	*	FIRSTFILTER	*	8)-1 +: 8]	=	out;
					end
					else if(flag == 4 && finish5 != 1 && finish4 != 1)begin  
						enable5 = 1;
						if (dataready == 1)begin counter = counter +1; if(out>0)begin decied [counter-1]=1; end else begin decied[counter-1]= 0; end end
					end
					else if(flag == 4 && finish5 == 1 )begin  
						done = 1; enable5 = 0;
						counter = 0;
						if(out>0)begin decied [9]=1; end 
						else begin decied[9]= 0; end
					end
				end
		
		end
endmodule
