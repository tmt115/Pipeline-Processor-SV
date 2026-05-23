module register_32b (
    input  logic [31:0] d,
    input  logic        rst,
    input  logic        en,
    input  logic        clk,
    output logic [31:0] q
);

always_ff @(posedge clk) begin

    if (rst) 
        q <= 32'b0;
    else if (en)
        q <= d;

end

endmodule

