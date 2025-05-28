
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/09/2025 12:07:57 AM
// Design Name:
// Module Name: Control_unit
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

module Control_unit(
    opcode, clk,
    we_reg_mem, is_jump, alu_op_b
    );

    input [3:0] opcode;
    input clk;
//    input [31:26] inst;
    output reg we_reg_mem, alu_op_b;
    output reg [1:0] is_jump;

    always @(*) begin
        case(opcode)
        4'b0011: begin // type of inst  ___ rd rt rs => rd = rs + rt
//            we_d_mem = 1'b0;
            alu_op_b = 1'b0;
            we_reg_mem = 1'b1;
            is_jump = 2'b0;
        end
        4'b0100: begin // type of inst ___ rd rt val
//            we_d_mem = 1'b0;
            alu_op_b = 1'b1;
            we_reg_mem = 1'b1;
            is_jump = 2'b0;
        end
        4'b0101: begin //lw type lw r0 offset(r1)
//            we_d_mem = 1'b0;
            alu_op_b = 1'b0;
            we_reg_mem = 1'b1;
            is_jump = 2'b0;
        end
        4'b0110: begin //sw type sw r0 offset(r1)
//            we_d_mem = 1'b1;
            alu_op_b = 1'b0;
            we_reg_mem = 1'b0;
            is_jump = 2'b0;
        end
        4'b0111: begin //lui r0 100 => r0[31:16] = 100
//            we_d_mem = 1'b0;
            alu_op_b = 1'b0;
            we_reg_mem = 1'b1;
            is_jump = 2'b0;
        end
        4'b1000: begin //conditional branching
//            we_d_mem = 1'b0;
            alu_op_b = 1'b0;
            we_reg_mem = 1'b0;
            is_jump = 2'b01;
        end
        4'b1001: begin //j
//            we_d_mem = 1'b0;
            alu_op_b = 1'b0;
            we_reg_mem = 1'b0;
            is_jump = 2'b10;
        end
        4'b1100: begin //jr
//            we_d_mem = 1'b0;
            alu_op_b = 1'b0;
            we_reg_mem = 1'b0;
            is_jump = 2'b10;
        end
        4'b1101: begin //jal
//            we_d_mem = 1'b0;
            alu_op_b = 1'b0;
            we_reg_mem = 1'b1;
            is_jump = 2'b10;
        end    
        4'b1010: begin //slt and seq
//            we_d_mem = 1'b0;
            alu_op_b = 1'b0;
            we_reg_mem = 1'b1;
            is_jump = 2'b0;
        end
        4'b1011: begin //slti
//            we_d_mem = 1'b0;
            alu_op_b = 1'b1;
            we_reg_mem = 1'b1;
            is_jump = 2'b0;
        end
        default : begin
            alu_op_b = 1'b0;
            we_reg_mem = 1'b0;
            is_jump = 2'b0;
        end
        endcase
    end

endmodule