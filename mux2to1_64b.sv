module mux2to1_64b (
    input  logic [63:0] in0,
    input  logic [63:0] in1,
    input  logic        sel,

    output logic [63:0] out
    );

always_comb begin
    
    case(sel) begin
        0 : out = in0;
        1 : out = in1;
        default : out = 'x;
    end

end

endmodule

