 `timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/02/2025 04:42:26 PM
// Design Name:
// Module Name: Alu
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

module maddu(A, B, pro);

input signed [31:0]A, B;
output signed [63:0] pro;

assign pro = A * B;

endmodule

module Alu(inst, A, B, hi, lo, out0, result);

input [5:0] inst;
input [31:0] A, B;
output reg [31:0] out0, hi, lo;
output reg result;

wire [63:0] signed_pro;
maddu signed_mul(A, B, signed_pro);

wire sra_res = $signed(A) >>> B[4:0];
initial begin
    out0 = 0;
    hi = 0;
    lo = 0;
    result = 0;
end

always @(*) begin

case(inst)

    6'b000000: begin out0 = A + B; end //add 0
    6'b000001: begin out0 = A - B; end //sub 1
    6'b000010: begin out0 = A + B; end //addu 2
    6'b000011: begin out0 = A - B; end //subu 3
    6'b000100: begin out0 = A + B; end //addi 4
    6'b000101: begin out0 = A - B; end //addiu 5
    6'b000110: begin {hi, lo} = {hi, lo} + signed_pro; end //madd 6
    6'b000111: begin {hi, lo} = {hi, lo} + A * B; end //maddu 7
    6'b100111: begin {hi, lo} = signed_pro; end //mul 39 
    6'b001000: begin out0 = A & B; end //and 8
    6'b001001: begin out0 = A & B; end //andi 9
    6'b001010: begin out0 = A | B; end //or 10
    6'b001011: begin out0 = A | B; end //ori 11
    6'b001100: begin out0 = ~A; end //not 12
    6'b001101: begin out0 = A ^ B; end //xor 13
    6'b001110: begin out0 = A ^ B; end //xori 14
    6'b001111: begin out0 = A << B[4:0]; end //sll 15
    6'b010000: begin out0 = A >> B[4:0]; end //srl 16
    6'b010001: begin out0 = A << B[4:0]; end //sla 17
    6'b010010: begin out0 = sra_res; end //sra 18

    // Signed comparisons
    6'b010011: begin result = ($signed(A) > $signed(B)) ? 1'b1 : 1'b0; end //sgt 19
    6'b010100: begin result = ($signed(A) < $signed(B)) ? 1'b1 : 1'b0; end //slt 20
    6'b010101: begin result = ($signed(A) == $signed(B)) ? 1'b1 : 1'b0; end //seq 21

    // Unsigned comparisons
    6'b010110: begin result = (A > B) ? 1'b1 : 1'b0; end //sgtu 22
    6'b010111: begin result = (A < B) ? 1'b1 : 1'b0; end //sltu 23

    default: begin
    out0 = 0;
    hi = 0;
    lo = 0;
    result = 0;
    end
    
endcase


end

endmodule
