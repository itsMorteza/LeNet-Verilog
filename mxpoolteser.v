`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   07:38:49 07/06/2019
// Design Name:   MAX_POOL
// Module Name:   F:/ProjectFiles/Fpga/Arch Lab/project/project_window_sliding/mxpoolteser.v
// Project Name:  project_window_sliding
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MAX_POOL
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mxpoolteser;

	// Inputs
	reg [95:0] indata;
	reg clk;

	// Outputs
	wire [23:0] result;
	wire maxpoolingdone;

	// Instantiate the Unit Under Test (UUT)
	MAX_POOL uut (
		.indata(indata), 
		.clk(clk), 
		.result(result), 
		.maxpoolingdone(maxpoolingdone)
	);
	integer i;
	initial begin
		// Initialize Inputs
		for (i = 0 ; i<12;i=i+1)begin
			indata[i*8 +:	8]	=	3;
		end
		clk = 0;
		
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
   always #10  clk =~(clk);
endmodule

