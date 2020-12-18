`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/14 09:40:58
// Design Name: 
// Module Name: debounce_pulse
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module debounce_pulse(
    input clk, input rst,
    input Din, output Dout);
    
	wire A;
	reg B,C;
	integer cnt;
	 
	assign A = Din;
	 
	always @(posedge clk)
	   if(rst==1)
	       begin
	       B <= 0;
		   C <= 0;
		   end
		else
		    begin
			B <= A;
			C <= B;
		    end
		
    assign Dout = (~C & B);

endmodule
