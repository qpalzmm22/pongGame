`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/14 10:14:04
// Design Name: 
// Module Name: pong_graph
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


module pong_graph(
    input clk, input reset,
    input vsync, input hsync,
    input [3:0] l_bar_buttons, input [3:0] r_bar_buttons,
    input [9:0] pix_x, input [9:0] pix_y, input gra_still,
    output graph_on,
    output reg hit, output reg miss, output reg l_win, output reg r_win,
    output reg [2:0] graph_rgb, output reg aud_en,
    output blue_light, output red_light);

// costant and signal declaration
    // x, y coordinates (0,0) to (639,479)
    localparam MAX_X = 640;
    localparam MAX_Y = 480;
    wire refr_tick;


    localparam INITIAL_BARR_X = 600;
    
    
// bar top, bottom boundary
    wire [9:0] barr_y_t, barr_y_b;
    wire [9:0] barr_x_l, barr_x_r;
    localparam BARR_Y_SIZE = 72;
    localparam BARR_X_SIZE = 10;
    
// register to track top boundary
    reg [9:0] barr_y_reg, barr_y_next;
    reg [9:0] barr_x_reg, barr_x_next;
   
   /*
   // random item 
   wire item_on;
   reg item_en;
   wire [2:0] item_rgb;
   wire [9:0] item_y_t, item_y_b;
   wire [9:0] item_x_l, item_x_r;
   assign item_y_b = item_y_t + 8;
   assign item_x_r = item_x_l + 8;
   lfsr random_position(.clk(vsync), .rst(rst), .en(item_en), .xpos(item_x_l), .ypos(item_y_t));
   assign item_on = (item_x_l <= pix_x) && (pix_x <= item_x_r) &&
                    (item_y_t <= pix_y) && (pix_y <= item_y_b);
   assign item_rgb = 3'b111;   // white

   */
   
   
// bar moving velocity when the button are pressed
    localparam BARR_V = 4;
    // left bar
    localparam INITIAL_BARL_X = 40;
    // bar top, bottom boundary
    wire [9:0] barl_y_t, barl_y_b;
    wire [9:0] barl_x_l, barl_x_r;
   
    localparam BARL_Y_SIZE = 72;
    localparam BARL_X_SIZE = 10;
    
    // register to track top boundary
    reg [9:0] barl_y_reg, barl_y_next;
    reg [9:0] barl_x_reg, barl_x_next;
    
    // bar moving velocity when the button are pressed
    localparam BARL_V = 4;

    // square ball
    localparam BALL_SIZE = 8;
    // ball left, right boundary
    wire [9:0] ball_x_l, ball_x_r;
    // ball top, bottom boundary
    wire [9:0] ball_y_t, ball_y_b;
    
    // reg to track left, top position
    reg [9:0] ball_x_reg, ball_y_reg;
    wire [9:0] ball_x_next, ball_y_next;
    
    // reg to track ball speed
   reg [9:0] x_delta_reg, x_delta_next;
   reg [9:0] y_delta_reg, y_delta_next;
   
   // ball velocity can be pos or neg)
   localparam BALL_V_P = 2;
   localparam BALL_V_N = -2;
   
   // round ball 
   wire [2:0] rom_addr, rom_col;
   reg [7:0] rom_data;
   wire rom_bit;
   // object output signals
   wire wall_on, barr_on, barl_on, sq_ball_on, rd_ball_on;
   wire [2:0] wall_rgb, barr_rgb, barl_rgb, ball_rgb;

   reg [9:0] ball_center;

   // Angle varibles
   reg [9:0] hit_point;
   reg red_hit, blue_hit;
   // round ball image ROM


   always @*
   begin
        rom_data = 8'b0000_0000;
   case (rom_addr)
      3'h0: rom_data = 8'b00111100; //   ****
      3'h1: rom_data = 8'b01111110; //  ******
      3'h2: rom_data = 8'b11111111; // ********
      3'h3: rom_data = 8'b11111111; // ********
      3'h4: rom_data = 8'b11111111; // ********
      3'h5: rom_data = 8'b11111111; // ********
      3'h6: rom_data = 8'b01111110; //  ******
      3'h7: rom_data = 8'b00111100; //   ****
   endcase
   end
   // registers
   always @(posedge clk, posedge reset)
      if (reset)
         begin
            barr_y_reg <= 0;
            barr_x_reg <= 0;
            
            barl_y_reg <= 0;
            barl_x_reg <= 0;
            
            ball_x_reg <= 0;
            ball_y_reg <= 0;
            x_delta_reg <= 10'h004;
            y_delta_reg <= 10'h004;
         end   
      else
         begin
            barr_y_reg <= barr_y_next;
            barr_x_reg <= barr_x_next;
            
            barl_y_reg <= barl_y_next;
            barl_x_reg <= barl_x_next;
            
            ball_x_reg <= ball_x_next;
            ball_y_reg <= ball_y_next;
            x_delta_reg <= x_delta_next;
            y_delta_reg <= y_delta_next;
         end   

   // refr_tick: 1-clock tick asserted at start of v-sync
   assign refr_tick = (pix_y==481) && (pix_x==0);
   

   // right vertical bar
   
   // boundary
   assign barr_y_t = barr_y_reg;
   assign barr_x_l = barr_x_reg;
   
   assign barr_y_b = barr_y_t + BARR_Y_SIZE - 1;
   assign barr_x_r = barr_x_l + BARR_X_SIZE - 1;
   // pixel within bar
   assign barr_on = (barr_x_l <=pix_x) && (pix_x<= barr_x_r) &&
                   (barr_y_t<=pix_y) && (pix_y<=barr_y_b); 
   // bar rgb output
   assign barr_rgb = 3'b100; // red
   // new bar y-position
   always @*
   begin
      barr_y_next = barr_y_reg; // no move
      if (gra_still) begin// initial position of bar
         barr_y_next = (MAX_Y-BARR_Y_SIZE)/2;
         end
      else if (refr_tick)
         if (r_bar_buttons[2] & (barr_y_b < (MAX_Y-1-BARR_V)))
            barr_y_next = barr_y_reg + BARR_V; // move down
         else if (r_bar_buttons[3] & (barr_y_t > BARR_V)) 
            barr_y_next = barr_y_reg - BARR_V;  // move up
   end
   
   always @*
   begin
      barr_x_next = barr_x_reg;
      if (gra_still) begin// initial position of paddle
         barr_x_next = (INITIAL_BARR_X);
         end
      else if (refr_tick)
         if (r_bar_buttons[0] &(barr_x_r < (MAX_X-1-BARR_V)))     
            barr_x_next = barr_x_reg + BARR_V;  // move right
         else if (r_bar_buttons[1] & (barr_x_l > MAX_X/2 + BARR_V)) 
            barr_x_next = barr_x_reg - BARR_V; // move left
   end
   
   
   
   // left bar
   // boundary
    assign barl_y_t = barl_y_reg;
    assign barl_x_l = barl_x_reg;
    assign barl_y_b = barl_y_t + BARL_Y_SIZE - 1;
    assign barl_x_r = barl_x_l + BARL_X_SIZE - 1;
    // pixel within bar
    assign barl_on = (barl_x_l<=pix_x) && (pix_x<=barl_x_r) &&
                    (barl_y_t<=pix_y) && (pix_y<=barl_y_b); 
    // bar rgb output
    assign barl_rgb = 3'b001; // blue
    // new bar y-position
    always @*
    begin
       barl_y_next = barl_y_reg; // no move
       if (gra_still) // initial position of paddle
          barl_y_next = (MAX_Y-BARL_Y_SIZE)/2;
       else if (refr_tick)
          if (l_bar_buttons[2] & (barl_y_b < (MAX_Y-1-BARL_V)))
             barl_y_next = barl_y_reg + BARL_V; // move down
          else if (l_bar_buttons[3] & (barl_y_t > BARL_V)) 
             barl_y_next = barl_y_reg - BARL_V; // move up
    end
   
   always @*
   begin
       barl_x_next = barl_x_reg; // no move
       if (gra_still) // initial position of paddle
          barl_x_next = (INITIAL_BARL_X);
       else if (refr_tick)
           if (l_bar_buttons[0] & (barl_x_r < (MAX_X/2-1-BARL_V)))     
            barl_x_next = barl_x_reg + BARL_V;  // move right
         else if (l_bar_buttons[1] & (barl_x_l > BARL_V)) 
            barl_x_next = barl_x_reg - BARL_V; // move left
    end

   // square ball
   // boundary
   assign ball_x_l = ball_x_reg;
   assign ball_y_t = ball_y_reg;
   assign ball_x_r = ball_x_l + BALL_SIZE - 1;
   assign ball_y_b = ball_y_t + BALL_SIZE - 1;
   // pixel within ball
   assign sq_ball_on =
            (ball_x_l<=pix_x) && (pix_x<=ball_x_r) &&
            (ball_y_t<=pix_y) && (pix_y<=ball_y_b);
   // map current pixel location to ROM addr/col
   assign rom_addr = pix_y[2:0] - ball_y_t[2:0];
   assign rom_col = pix_x[2:0] - ball_x_l[2:0];
   assign rom_bit = rom_data[rom_col];
   // pixel within ball
   assign rd_ball_on = sq_ball_on & rom_bit;
   // ball rgb output
   assign ball_rgb = 3'b101;   // purple
  
   // new ball position
   assign ball_x_next = (gra_still) ? MAX_X/2 :
                        (refr_tick) ? ball_x_reg+x_delta_reg :
                        ball_x_reg ;
   assign ball_y_next = (gra_still) ? MAX_Y/2 :
                        (refr_tick) ? ball_y_reg+y_delta_reg :
                        ball_y_reg ;
   
   
   // new ball velocity
   always @*   
   begin
      hit = 1'b0;
      miss = 1'b0;
      aud_en = 1'b0;
      l_win = 1'b0;
      r_win = 1'b0;
      blue_hit = 1'b0;
      red_hit = 1'b0;
    //  item_en = 1'b0;
      x_delta_next = x_delta_reg;
      y_delta_next = y_delta_reg;
      
      
      ball_center = ball_y_t + ((ball_y_b - ball_y_t) / 2);
      
      if (gra_still)     // initial velocity
         begin
            aud_en = 0;
            //item_en = 0;
            x_delta_next = BALL_V_N;
            y_delta_next = BALL_V_P;
         end   
      else if (ball_y_t <= 1) // reach top
        begin
        aud_en = 0;
        //item_en = 0;
         y_delta_next = BALL_V_P;
         end
      else if (ball_y_b >= (MAX_Y-1)) // reach bottom
        begin
        aud_en = 0;
        //item_en = 0;
         y_delta_next = BALL_V_N;
         end
      else if ((barr_x_l<=ball_x_r) && (ball_x_r<=barr_x_r) &&
               (barr_y_t<=ball_y_b) && (ball_y_t<=barr_y_b))
         begin
            // reach x of right bar and hit, ball bounce back
            //x_delta_next = BALL_V_N;
            red_hit = 1'b1;
            aud_en = 1;
            //item_en = 1;
            hit_point = ball_center - barr_y_t;
            if (hit_point < (BARR_Y_SIZE / 5))
               x_delta_next = -4;
            else if (hit_point < 2*(BARR_Y_SIZE / 5))
               x_delta_next = -3;
            else if (hit_point < 3*(BARR_Y_SIZE / 5))
               x_delta_next = -2;
            else if (hit_point < 4*(BARR_Y_SIZE / 5))
               x_delta_next = -3;
            else
               x_delta_next = -4;
               hit = 1'b1;
         end
      else if ((barl_x_l<=ball_x_r) && (ball_x_l<=barl_x_r) &&
               (barl_y_t<=ball_y_b) && (ball_y_t<=barl_y_b))
         begin
            // reach x of left bar and hit, ball bounce back
            //x_delta_next = BALL_V_P;
            blue_hit = 1'b1;
            aud_en = 1;
           // item_en = 1;
            hit_point = ball_center - barr_y_t;
            if (hit_point < (BARR_Y_SIZE / 5))
               x_delta_next = 4;
            else if (hit_point < 2*(BARR_Y_SIZE / 5))
               x_delta_next = 3;
            else if (hit_point < 3*(BARR_Y_SIZE / 5))
               x_delta_next = 2;
            else if (hit_point < 4*(BARR_Y_SIZE / 5))
               x_delta_next = 3;
            else
               x_delta_next = 4;
            hit = 1'b1;
         end
      else if (ball_x_r >= MAX_X - 10)   // reach right border
         begin
            aud_en = 0;
           // item_en = 0;
            miss = 1'b1;            
            l_win = 1'b1;
         end
      else if (ball_x_r <= 10)   // reach left border
         begin
           aud_en = 0;
           // item_en = 0;
           miss = 1'b1;
           r_win = 1'b1;
         end
   end 
   // rgb multiplexing circuit
   always @* 
      if (wall_on)
         graph_rgb = wall_rgb;
      else if (barr_on)
         graph_rgb = barr_rgb;
      else if (barl_on)
         graph_rgb = barl_rgb;
      else if (rd_ball_on)
         graph_rgb = ball_rgb;
/*      else if (item_on)
        graph_rgb = item_rgb; */
      else
         graph_rgb = 3'b000; // black background
   // new graphic_on signal
   assign graph_on =  barr_on | barl_on | rd_ball_on /*| item_on*/;
   
   // red, blue rgb
   assign blue_light = (blue_hit) ? 1 : 0;
   assign red_light = (red_hit) ? 1 : 0;
endmodule 