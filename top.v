`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:30:02 06/27/2019 
// Design Name: 
// Module Name:    top 
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
module top #(
		parameter  	WIDTH 			= 	32,
		parameter  	HEIGHT 			= 	32,
		parameter  	CHANNEL 			= 	3)(
	input 								clk,
	output 								hsync,
	output 								vsync,
	output 		[7:0] 				rgb,
	output    	        			done,
	output		 [10:0]			class
    );

	 reg 		[WIDTH*HEIGHT*CHANNEL*8-1:0] img;
	 wire												out;
	 reg enable1,enable2;
	 reg 		[20:0]		address;
		initial begin
			enable1=1;
		end
		ROM ROM1  (
			.clka(clk), // input clka
			.ena(enable1), // input ena
			.addra(address), // input [9 : 0] addra
			.douta(out) // output [7 : 0] douta
		);
		processing_element instance_name (
				.clk(clk), 
				.enable(enable2), 
				.reset(reset), 
				.pixel(img), 
				.done(done), 
				.decied(class)
			);
		vga_sync vga1 (
			.clk(clk),  
			.hsync(hsync), 
			.vsync(vsync), 
			.video_on(), 
			.h_video_on(h_video_on),
			.v_video_on(v_video_on),
			.pixel_x(pixel_x), 
			.pixel_y(pixel_y)
		);
		
		pixel_generator pixel(
			.clk(clk), 
			.pixel_x(pixel_x), 
			.pixel_y(pixel_y), 
			.pixel_in(pixel_in), 
			.h_video_on(h_video_on), 
			.v_video_on(v_video_on), 
			.rgb(rgb)
		);
		always @ (posedge clk)begin		
				if (address < WIDTH*HEIGHT*CHANNEL) begin			
					img[address*8 +: 8]=out;
					address = address + 1;
					enable1=1;
				end
				else if (address < WIDTH*HEIGHT*CHANNEL) begin
					enable2=1;enable1=0;
				end
				if (done)begin
					enable2=0;
				end
		end
endmodule
