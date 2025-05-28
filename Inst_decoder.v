`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/07/2025 02:58:44 PM
// Design Name:
// Module Name: Inst_decoder
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

module Inst_decoder(
    inst,
    op, rs, rt, rd, shamt, funct,
    add_imm, j_add,
    clk
    );

    input [31:0] inst;
    input clk;
    output reg [5:0] op, funct;
    output reg [4:0] rs, rt, rd, shamt;
    output reg [15:0] add_imm;
    output reg [25:0] j_add;

    always @(*) begin

        op = inst[31:26];
        rs = inst[15:11];
        rt = inst[20:16];
        rd = inst[25:21];
        shamt = inst[10:6];
        funct = inst[5:0];

        add_imm = inst[15:0];

        j_add = inst[25:0];
    end

endmodule