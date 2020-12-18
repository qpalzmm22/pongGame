`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/18 10:47:07
// Design Name: 
// Module Name: tb_ss_decoder
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


module tb_ss_decoder();

wire CA, CB, CC, CD, CE, CF, CG;
reg [3:0] D;
reg reset;

ss_decoder u0 (.a(CA), .b(CB), .c(CC), .d(CD), .e(CE), .f(CF), .g(CG), .Din(D), .rst(reset));

initial
    begin
    reset = 1;
    #10 reset = 0; D = 0;
    #10 D = 1;
    #10 D = 2;
    #10 D = 3;
    #10 D = 4;
    #10 D = 5;
    #10 D = 6;
    #10 D = 7;
    #10 D = 8;
    #10 D = 9;
    #10 D = 11;
    #10 D = 12;
    #10 D = 13;
    #10 D = 14;
    #10 D = 15;
    #10 $finish;
    end
    
endmodule
