`timescale 1ns / 1ps

module dist_mem_gen_0 (
    input [10:0] a,      // Write address
    input [10:0] dpra,   // Read address
    input [31:0] d,      // Data input
    input we,            // Write enable
    input clk,           // Clock
    output reg [31:0] dpo // Data output
);

    reg [31:0] mem [0:2047]; // 2^11 = 2048 words

    // Write operation
    always @(posedge clk) begin
        if (we)
            mem[a] <= d;
    end

    // Read operation
    always @(*) begin
        dpo = mem[dpra];
    end

endmodule