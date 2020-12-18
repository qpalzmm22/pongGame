`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/14 09:22:29
// Design Name: 
// Module Name: ps2_interface
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


module ps2_interface(
    input clk50,input clk100, input BTNC,
    input PS2_CLK, input PS2_DATA,
    output [3:0] r_bar_buttons);
    
    wire [7:0] scancode;
    wire [7:0] data;
    wire err_ind;
    
    ps2_kbd_top ps2_kbd (
        .clk(clk50), .rst(BTNC),
        .ps2clk(PS2_CLK), .ps2data(PS2_DATA),
        .scancode(scancode), .released_out(released_out), .err_ind(err_ind)); 
          
    assign data = released_out ? 0 : scancode;

    assign r_bar_buttons[3] = (data == 146) ? 1 : 0;  // right bar up
    assign r_bar_buttons[2] = (data == 147) ? 1 : 0;  // right bar down
    assign r_bar_buttons[1] = (data == 145) ? 1 : 0;  // right bar left
    assign r_bar_buttons[0] = (data == 144) ? 1 : 0;  // right bar right

endmodule
