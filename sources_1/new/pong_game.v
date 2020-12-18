`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/14 09:45:16
// Design Name: 
// Module Name: pong_game
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


module pong_game(
    input clk, input reset,
    input [3:0] l_bar_buttons, input [3:0] r_bar_buttons,
    output hsync, output vsync, output [2:0] rgb, output aud_en,
    output CA, output CB, output CC, output CD, output CE, output CF, output CG, output DP, output [7:0] AN,
    output blue_light, output red_light);

   // syate declaration
   localparam [1:0] newgame = 2'b00;
   localparam [1:0] play    = 2'b01;
   localparam [1:0] newball = 2'b10;
   localparam [1:0] over    = 2'b11;

   // signal declaration
   reg [1:0] state_reg, state_next;
   wire [9:0] pixel_x, pixel_y;
   
   wire video_on, pixel_tick, graph_on, hit, miss;
   wire [2:0] graph_rgb;
   reg [2:0] rgb_reg, rgb_next;
   reg gra_still, timer_start;
   reg [3:0] r_win_score, l_win_score;  // stores the score of each player
   wire count_en;

// instantiate video synchronization unit
    vga_sync vsync_unit(
        .clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync),
        .video_on(video_on), .p_tick(pixel_tick),
        .pixel_x(pixel_x), .pixel_y(pixel_y));

// instantiate graph module
    pong_graph graph_unit(
        .clk(clk), .reset(reset), .l_bar_buttons(l_bar_buttons), .r_bar_buttons(r_bar_buttons),
        .pix_x(pixel_x), .pix_y(pixel_y), .vsync(vsync), .hsync(hsync),
        .gra_still(gra_still), .hit(hit), .miss(miss), .l_win(l_win), .r_win(r_win),
        .graph_on(graph_on), .graph_rgb(graph_rgb), .aud_en(aud_en),
        .blue_light(blue_light), .red_light(red_light));
        
    
// SevenSegmentDisplay
    ss_drive ss_drive (
        .clk(clk), .rst(reset),
        .data7(), .data6(), .data5(), .data4(),
        .data3(), .data2(), .data1(l_win_score), .data0(r_win_score),
        .CA(CA), .CB(CB), .CC(CC), .CD(CD), .CE(CE), .CF(CF), .CG(CG), .DP(DP), .AN(AN));    
        
       
// FSM state & data registers
    always @(posedge clk, posedge reset)
        if (reset)
            begin
            state_reg <= newgame;
            rgb_reg <= 0;
            end
        else
            begin
            state_reg <= state_next;
            if (pixel_tick)
                rgb_reg <= rgb_next;
            else
                rgb_reg <= 0;
            end
            
// FSMD next-state logic
    always @*
        begin
        gra_still = 1'b1;
        state_next = state_reg;   
        
        case (state_reg)
            newgame:
                begin
            
                if ((l_bar_buttons != 4'b0000) || (r_bar_buttons != 4'b0000))  // button pressed
                    begin
                    state_next = play;
                    end
                else
                    state_next = newgame;
                end
            play:
                begin
                gra_still = 1'b0;  // animated screen
                if (miss)
                    begin
                    if (r_win_score > 9 || l_win_score > 9)
                        state_next = over;
                    else
                        begin
                            state_next = newball;
                        
                        end
                    end
                end
            newball:
                // wait until buttons are pressed
                if ((l_bar_buttons != 4'b0000) || (r_bar_buttons != 4'b0000))
                    state_next = play;
                else
                    state_next = newball;
                    
            over:
                    state_next = newgame;
        endcase
        end
// count score

assign count_en = (state_next == newball && state_reg == play);

    always@(posedge clk)
        if(reset) begin
            r_win_score = 4'b0;
            l_win_score = 4'b0;
        end    
        else
            if(count_en && r_win)
                if(r_win_score < 'd9)
                    r_win_score = r_win_score + 1;
                else
                begin
                    r_win_score = 'd0;
                    l_win_score = 'd0;
                end
            else if (count_en && l_win)
                if(l_win_score < 'd9)
                    l_win_score = l_win_score + 1;
                else
                begin
                    l_win_score = 'd0;          
                    r_win_score = 'd0;         
                end

// rgb
    always @*
        if (~video_on)
            rgb_next = "000"; // blank the edge/retrace
        else if (graph_on)  // display graph
            rgb_next = graph_rgb;
        else
            rgb_next = 3'b000; // black background
            
// output
    assign rgb = rgb_reg;
    
endmodule
