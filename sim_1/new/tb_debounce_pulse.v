`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/18 17:51:57
// Design Name: 
// Module Name: tb_debounce_pulse
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


module tb_debounce_pulse();

    reg clk, rst;
    reg Din;
    wire Dout;

    debounce_pulse u0(
    .clk(clk), .rst(rst),
    .Din(Din), .Dout(Dout));
    
    always #5 clk = ~clk;
    
    initial
        begin
        clk = 0;
        rst = 1;
        Din = 0;
        #10 rst = 0; Din = 1;
        #4 Din = 0;
        #36 Din = 1;
        #2 Din = 0;
        #2 Din = 1;
        #3 Din = 0;
        #3 Din = 1;
        #50 Din = 0;
        #70 Din = 1;
        #100 rst = 1;
        #20 $finish;
        end

endmodule
