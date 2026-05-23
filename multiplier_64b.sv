module multiplier_64b (
    input  logic [63:0] in0,
    input  logic [63:0] in1,

    output logic        product
);

always_comb begin

    product = in0 * in1;

end

endmodule

