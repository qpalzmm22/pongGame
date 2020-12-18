`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/18 17:45:57
// Design Name: 
// Module Name: tb_vga_sync
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


module tb_vga_sync();

    reg clk, reset;
    wire hsync, vsync;
    wire video_on, p_tick;
    wire [9:0] pixel_x, pixel_y;

    vga_sync u0(
        .clk(clk), .reset(reset),
        .hsync(hysnc), .vsync(vsync), 
        .video_on(video_on), .p_tick(p_tick),
        .pixel_x(pixel_x), .pixel_y(pixel_y));
    
    always #5 clk = ~clk;
    
    initial
        begin
        clk = 0;
        reset = 1;
        #10 reset = 0;
        #100
        #100
        #100
        #100
        #100
        #100 $finish;
        end

endmodule
