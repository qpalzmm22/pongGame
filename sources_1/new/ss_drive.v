`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/15 09:23:04
// Design Name: 
// Module Name: ss_drive
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


module ss_drive(output reg [7:0] AN,
                 output CA, output CB, output CC, output CD, output CE, output CF, output CG, output DP,
                 input [3:0] data0, input [3:0] data1, input [3:0] data2, input [3:0] data3,
                 input [3:0] data4, input [3:0] data5, input [3:0] data6, input [3:0] data7,
                 input clk, input rst);

reg [2:0] sel;
wire [3:0] data;
integer cnt;

mux_8_to_1 uut0(.O(data), .A(data0), .B(data1), .C(data2), .D(data3), .E(data4), .F(data5), .G(data6), .H(data7), .sel(sel));
ss_decoder uut1(.a(CA), .b(CB), .c(CC), .d(CD), .e(CE), .f(CF), .g(CG), .Din(data), .rst(rst));

always @(posedge clk) begin
    if(rst)
        begin
        cnt <= 0;
        end
    else if (cnt < 20000)
        begin
        cnt <= cnt + 1;
        sel <= sel;
        end
    else
        begin
        cnt <= 0;
        sel <= sel + 1;
        end
end


always @(sel or rst) begin
    if(rst) AN = 8'b1111_1100;
    else
        AN = 8'b1111_1111;
    case (sel)
    3'd0: AN[0] = 0;
    3'd1: AN[1] = 0;
    default;
    endcase
end
endmodule