`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/15 09:21:48
// Design Name: 
// Module Name: ss_decoder
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


module ss_decoder(output reg a, output reg b, output reg c, output reg d, output reg e, output reg f, output reg g, input [3:0] Din, input rst);

always @(Din or rst) begin
    a = 0; b = 0; c = 0; d = 0; e = 0; f = 0; g = 0;
    if(rst) g = 1;
    else
    case (Din)
    4'b0000:
        begin
        g = 1;
        end
    4'b0001:
        begin
        a = 1; d = 1; e = 1; f = 1; g = 1;
        end
    4'b0010:
        begin
        c = 1; f = 1;
        end
    4'b0011:
        begin
        e = 1; f = 1;
        end
    4'b0100:
        begin
        a = 1; d = 1; e = 1;
        end
    4'b0101:
        begin
        b = 1; e = 1;
        end
    4'b0110:
        begin
        b = 1;
        end        
    4'b0111:
        begin
        d = 1; e = 1; g = 1;
        end
    4'b1000:
        begin
        end
    4'b1001:
        begin
        e = 1;
        end
    4'b1010:
        begin
        f = 1;
        end
    4'b1011:
        begin
        a = 1; b = 1;
        end
    4'b1100:
        begin
        b = 1; c = 1; g = 1;
        end
    4'b1101:
        begin
        a = 1; f = 1;
        end
    4'b1110:
        begin
        b = 1; c = 1;
        end
    4'b1111:
        begin
        b = 1; c = 1; d = 1;
        end
    endcase
end

endmodule
