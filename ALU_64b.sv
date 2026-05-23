`include "equality_comparator_64b.sv"
`include "adder_64b.sv"

module ALU_64b (
    input  logic [63:0] in0,
    input  logic [63:0] in1,
    input  logic        op,

    output logic [63:0] result
    );

logic eq_comp_out;
logic [63:0] adder_out;
logic [63:0] eq_comp_out_64b;

equality_comparator_64b eq_comp (
    .in0 (in0),
    .in1 (in1),
    .eq  (eq_comp_out)
    );

adder_64b.sv adder (
    .in0 (in0),
    .in1 (in1),
    .sum (adder_out)
    );

assign eq_comp_out_64b[63:1] = 63'b0;
assign eq_comp_out_64b[0] = eq_comp_out;

always_comb begin

    if (op) begin
        result = eq_comp_out_64b;
    end
    else begin
        result = adder_out;
    end

end

endmodule

