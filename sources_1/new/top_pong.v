`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/14 09:15:58
// Design Name: 
// Module Name: top_pong
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


module top_Pong(
    input CLK100MHZ, input BTNC,
    input BTNU, input BTNL, input BTNR, input BTND,
    input PS2_CLK, input PS2_DATA, 
    output VGA_HS, output VGA_VS,
    output [3:0] VGA_R, output [3:0] VGA_G, output [3:0] VGA_B,
    output CA, output CB, output CC, output CD, output CE, output CF, output CG, output DP, output [7:0] AN,
    output AUD_PWM, output AUD_SD,
    output LED16_R, LED17_B);
    
    wire [3:0] r_bar_buttons;
    wire [3:0] l_bar_buttons;

    clk_wiz_0 clk(
        .reset(BTNC), .clk_in1(CLK100MHZ),
        .clk_out1(clk100), .clk_out2(clk50), .locked());
        
    // KEYBOARD INTERFACE
    ps2_interface keyboard_Interface(
        .clk50(clk50), .clk100(clk100), .BTNC(BTNC),
        .PS2_CLK(PS2_CLK), .PS2_DATA(PS2_DATA), .r_bar_buttons(r_bar_buttons));
    
    
    assign l_bar_buttons = {BTNU, BTND, BTNL, BTNR}; // Up Down Left Right
    wire [2:0] rgb;
    
    wire aud_en;
    sound sound_unit(.clk(CLK100MHZ), .rst(BTNC), .en(aud_en), .AUD_PWM(AUD_PWM), .AUD_SD(AUD_SD));
    
    pong_game pong_game(
        .clk(clk50), .reset(BTNC),
        .r_bar_buttons(r_bar_buttons), .l_bar_buttons(l_bar_buttons),
        .hsync(VGA_HS), .vsync(VGA_VS), .rgb(rgb),
        .CA(CA), .CB(CB), .CC(CC), .CD(CD), .CE(CE), .CF(CF), .CG(CG), .DP(DP), .AN(AN),
        .aud_en(aud_en), .blue_light(LED17_B), .red_light(LED16_R) );

    assign VGA_R = 255 * rgb[2];
    assign VGA_G = 255 * rgb[1];
    assign VGA_B = 255 * rgb[0];
endmodule
