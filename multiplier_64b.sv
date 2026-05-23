module multiplier_64b (
    input  logic in0,
    input  logic in1,

    output logic product
);

always_comb begin

    product = in0 * in1;

end

endmodule

