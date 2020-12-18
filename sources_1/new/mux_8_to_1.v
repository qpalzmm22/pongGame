`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/15 09:23:55
// Design Name: 
// Module Name: mux_8_to_1
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


module mux_8_to_1(output reg [3:0] O,
                   input [3:0] A, input [3:0] B, input [3:0] C, input [3:0] D, input [3:0] E, input [3:0] F, input [3:0] G, input [3:0] H,
                   input [2:0] sel);

always @(A or B or C or D or E or F or G or H or sel) begin
    O <= 4'b0;
    case (sel)
    3'd0: O <= A;
    3'd1: O <= B;
    3'd2: O <= C;
    3'd3: O <= D;
    3'd4: O <= E;
    3'd5: O <= F;
    3'd6: O <= G;
    3'd7: O <= H;
    endcase
end

endmodule
