`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/14 09:43:01
// Design Name: 
// Module Name: sound
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


module sound(input clk, input rst, input en, output AUD_PWM, output AUD_SD);

    reg sound_on;
    reg [15:0] frequency_generator;
    reg [22:0] timer;

    always @(posedge clk)
        if(rst)
            begin
            frequency_generator <= 0;
            timer <= 0;
            sound_on <= 0;
            end
        else if (!en)
            begin
            frequency_generator <= 1;
            timer <= 1;
            end
        else if (timer != 0)
            begin
            frequency_generator <= frequency_generator + 1;
            timer <= timer + 1;
            sound_on <= 1;
            end
        else
            begin
            frequency_generator <= 0;
            timer <= 0;
            sound_on <= 0;
            end

    assign AUD_PWM = frequency_generator[15];
    assign AUD_SD = sound_on;
    
endmodule
