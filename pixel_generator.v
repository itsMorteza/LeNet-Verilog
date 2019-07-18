`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:00:17 06/28/2019 
// Design Name: 
// Module Name:    pixel_generator 
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
module pixel_generator(
	input 						clk,
	input 			[9:0] 	pixel_x,
	input 			[9:0] 	pixel_y,
	input    		[7:0] 	pixel_in,
	input 						h_video_on,v_video_on,
	output 	reg 	[7:0] 	rgb
   );
		always@(posedge clk)begin //Showing Pixel 
			if(h_video_on && v_video_on)begin
				if(pixel_x>208 && pixel_x<432 && pixel_y>128&& pixel_y<352)begin
					rgb = pixel_in;
				end
			end
			else begin
					rgb <= 7'b0;
			end
		end
endmodule
