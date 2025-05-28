module Register_Memory(ra1, ra2, dout1, dout2, we, wa, data, clk);

parameter W = 5;        // Address width (2^5 = 32 registers)
parameter D = 32;       // Data width

input [W-1:0] ra1, ra2;
output reg [D-1:0] dout1, dout2;
input we, clk;
input [W-1:0] wa;
input [D-1:0] data;

reg [31:0] RM [0:31];  // 2^W registers, each D bits wide

integer i;
initial begin
    for (i = 0; i < 32; i = i + 1) begin
        RM[i] = 32'b0;  // Initialize all registers to 0
    end
end

//always @(*) begin
//    RM[5'b0] <= 32'b0;
//end

always @(posedge clk) begin
    if (we && wa != 0) begin  // Prevent writing to register 0
        RM[wa] <= data;
    end
    RM[0] <= 32'b0; 
end

// Read operation (asynchronous)
always @(*) begin
    dout1 = RM[ra1];
    dout2 = RM[ra2];
end

endmodule