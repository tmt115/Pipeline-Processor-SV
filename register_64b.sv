module register_64b (
    input  logic [63:0] d,
    input  logic        rst,
    input  logic        clk,
    output logic [63:0] q
);

always_ff @(posedge clk) begin

    if (rst) 
        q <= 64'b0;
    else
        q <= d;

end

endmodule

