`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/18 10:58:53
// Design Name: 
// Module Name: tb_mux_8_to_1
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


module tb_mux_8_to_1();
    
    wire [3:0] O;
    reg [3:0] A, B, C, D, E, F, G, H;
    reg [2:0] sel;
    mux_8_to_1 u0 (.O(O), .A(A), .B(B), .C(C), .D(D), .E(E), .F(F), .G(G), .H(H), .sel(sel));
    
    initial
        begin
        A = 7; B = 6; C = 5; D = 4; E = 3; F = 2; G = 1; H = 0;
        #10 sel = 0;
        #10 sel = 1;
        #10 sel = 2;
        #10 sel = 3;
        #10 sel = 4;
        #10 sel = 5;
        #10 sel = 6;
        #10 sel = 7;
        #10 $finish;
        end

endmodule
