`timescale 1ns / 1ps

module Set_CU_op (
    op,
    CU_op
);

input [5:0] op;
output reg [3:0] CU_op;

always @(*) begin
    case(op)
        6'b000001: begin CU_op = 4'b0011; end // type of inst  ___ rd rt rs => rd = rs + rt
        6'b000010: begin CU_op = 4'b0100; end // type of inst ___ rd rt val
        6'b000011: begin CU_op = 4'b0101; end //lw
        6'b000100: begin CU_op = 4'b0110; end //sw
        6'b000101: begin CU_op = 4'b0111; end //lui r0 100 => r0[31:16] = 100
        6'b000110: begin CU_op = 4'b1000; end //conditional branch
        6'b000111: begin CU_op = 4'b1001; end //j
        6'b001000: begin CU_op = 4'b1100; end //jr
        6'b001001: begin CU_op = 4'b1101; end //jal
        6'b001010: begin CU_op = 4'b1010; end //slt and seq
        6'b001011: begin CU_op = 4'b1011; end //slti
        default: begin CU_op = 4'b0000; end
    endcase
end

endmodule

module Processor(
    clk, rst,
    inst_load, data_load,
    data, pc_curr, curr_inst, hi_out,
   lo_out 
);

    input clk, rst;
    input inst_load, data_load;
    input [31:0] data;
    output [31:0] hi_out;
    output [31:0] lo_out;
    output [31:0] curr_inst;  // Changed from reg to wire
    
    output reg [10:0] pc_curr = 0;

    wire [10:0] pc_next;
    wire [10:0] pc2;
    wire [1:0] is_jump;

    assign pc2 = pc_curr + 11'b1 + {add_imm[15], add_imm[15:6]};
    
    
    reg [31:0] jump_to;
    
    always @(*) begin
        case(CU_op) 
            4'b1001: begin jump_to = j_add[10:0]; end //j
            4'b1100: begin jump_to = r2_out[10:0]; end //jr
            4'b1101: begin jump_to = j_add[10:0]; end //jal
            default: begin jump_to = 11'b0; end
        endcase
    end
    
    assign pc_next = ( is_jump == 2'b10 ) ? jump_to : ( (is_jump == 2'b01 & res) ? pc2 : ( pc_curr + 11'b1 ));

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_curr <= 11'b0;
        end
        else begin
            pc_curr <= pc_next;
        end
    end

    // Instruction memory
    wire [10:0] add_i_mem;
    assign add_i_mem = pc_curr;

    wire [31:0] data_i_mem = data;

    reg we_i_mem = 0;
    dist_mem_gen_0 inst_mem(
        
        .a(add_i_mem),
        .dpra(add_i_mem),
        .d(data_i_mem),
        .we(we_i_mem),
        .clk(~clk),
        .dpo(curr_inst)
    );
    // Data memory
    // Data memory connections
//    wire [10:0] write_addr = data_load ? pc_curr : (add_imm[10:0] + r2_out[10:0]);
//    wire [10:0] read_addr = add_imm[10:0] + r2_out[10:0];

    // Sign-extend the 16-bit immediate to 32 bits
     wire [31:0] sign_ext_imm = {{16{add_imm[15]}}, add_imm};
     wire [31:0] effective_address = r2_out + sign_ext_imm;
     wire [10:0] mem_addr = effective_address[10:0];
     wire [10:0] write_addr = data_load ? pc_curr : mem_addr;
     wire [10:0] read_addr = mem_addr;
    
    wire [31:0] out0_d_mem;
    wire [31:0] data_d_mem = data_load ? data : r1_out;

    reg we_d_mem = 0;  // Changed from wire to reg
    dist_mem_gen_0 data_mem(
        .a(write_addr),
        .dpra(read_addr),
        .d(data_d_mem),
        .we(we_d_mem),
        .clk(~clk),
        .dpo(out0_d_mem)
    );

    // Instruction decoder
    wire [5:0] op, funct;
    wire [4:0] rd, rt, rs, shamt;
    wire [15:0] add_imm;
    wire [25:0] j_add;
    Inst_decoder inst_decoder(
        .inst(curr_inst),
        .op(op),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .shamt(shamt),
        .add_imm(add_imm),
        .j_add(j_add),
        .funct(funct),
        .clk(~clk)
    );

    // Register memory
    wire[4:0] ra1_reg = ( CU_op == 4'b0110 || CU_op == 4'b1000) ? rd : rs; //sw || cond branch
    wire[4:0] ra2_reg = rt;  // Added bit selection
    wire[4:0] wa_reg = ( CU_op == 4'b1101 ) ? 5'b11111 : rd;

    wire [31:0] r1_out;
    wire [31:0] r2_out;
    wire we_reg_mem;

    wire [3:0] CU_op;

//    wire [31:0] w_reg_data;
//    assign w_reg_data = (CU_op == 4'b0101) ? out0_d_mem : (CU_op == 4'b0111 ? {16'b0, add_imm} : out0);
    
    reg [31:0] w_reg_data;
    always @(*) begin
        case(CU_op) 
            4'b0101: begin w_reg_data = out0_d_mem; end
            4'b0111: begin w_reg_data = {add_imm, 16'b0}; end
            4'b1101: begin w_reg_data = (pc_curr + 11'b1); end   
            4'b1010: begin w_reg_data = res ? 32'b1 : 32'b0; end   //slt and seq
            4'b1011: begin w_reg_data = res ? 32'b1 : 32'b0; end   //slti
            default: begin w_reg_data = out0; end   
        endcase
    end

    Register_Memory reg_mem(
        .ra1(ra1_reg),
        .ra2(ra2_reg),
        .dout1(r1_out),
        .dout2(r2_out),
        .we(we_reg_mem),
        .wa(wa_reg),
        .data(w_reg_data),
        .clk(~clk)
    );

    // ALU
    wire [5:0] alu_op;

    assign alu_op = funct;
    
    wire alu_op_b;

    
    wire [31:0] alu_inp_a, alu_inp_b;
    wire [31:0] out1, out0;
    wire res;
    wire [31:0] hi_int, lo_int;

    assign alu_inp_a = CU_op == 4'b1000 ? r1_out : r2_out; //if cond branching 1000 cuop
    assign alu_inp_b = CU_op == 4'b1000 ? r2_out : ( alu_op_b ? {22'b0, add_imm[15:6]} : r1_out ); //if cond branching 1000 cuop

    Alu alu(
        .inst(alu_op),
        .A(alu_inp_a),
        .B(alu_inp_b),
        .hi(hi_int),
        .lo(lo_int),
        .out0(out0),
        .result(res)
    );

    assign hi_out = hi_int;
    assign lo_out = lo_int;
   
    // Control Unit
    Control_unit CU(
        .opcode(CU_op),
        .clk(clk),
        .alu_op_b(alu_op_b),
        .we_reg_mem(we_reg_mem),
        .is_jump(is_jump)
    );

    Set_CU_op setcu(
        .op(op),
        .CU_op(CU_op)
    );

    // always @(*) begin
    //     if(inst_load == 1'b1) begin
    //         we_i_mem <= 1'b1;
    //     end
    //     else begin
    //         we_i_mem <= 1'b0;
    //     end

    //     if(data_load == 1'b1 || CU_op == 4'b0110) begin
    //        we_d_mem <= 1'b1;
    //     end
    //     else begin
    //         we_d_mem <= 1'b0;
    //     end
    // end
    always @(posedge clk) begin
    we_i_mem <= inst_load;
    we_d_mem <= (data_load || CU_op == 4'b0110);
    end


endmodule
