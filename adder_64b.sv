module adder_64b (
    input  logic [63:0] in0,
    input  logic [63:0] in1,

    output logic        out
);

always_comb begin

    out = in0 + in1;

end

endmodule

