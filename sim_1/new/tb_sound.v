`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/18 18:06:55
// Design Name: 
// Module Name: tb_sound
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


module tb_sound();

    reg clk, rst, en;
    wire AUD_PWM, AUD_SD;
    
    sound u0(.clk(clk), .rst(rst), .en(en), .AUD_PWM(AUD_PWM), .AUD_SD(AUD_SD));
    
    always #5 clk = ~clk;
    
    initial
        begin
        clk = 0;
        rst = 1;
        en = 0;
        #10 rst = 0; en = 1;
        #100 en = 0;
        #50 en = 1;
        #300 en = 0;
        #100 $finish;
        end

endmodule
