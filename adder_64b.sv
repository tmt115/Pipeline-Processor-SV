module adder_64b (
    input  logic in0
    input  logic in1

    output logic out
);

always_comb begin

    out = in0 + in1;

end

endmodule

