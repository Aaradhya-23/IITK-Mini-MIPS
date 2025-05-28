`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2025 03:52:36 PM
// Design Name: 
// Module Name: PC
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


module PC(next, out, clk, rst);
    
input [10:0] next;
input clk, rst;
output reg [10:0] out;
   
always @(posedge clk or negedge rst) begin
    if (!rst)  begin
        out <= 11'b0;
    end
    else begin
        out <= next;
    end
end
    
endmodule
