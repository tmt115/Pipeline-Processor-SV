module mux4to1_32b (
    input  logic [31:0] in0,
    input  logic [31:0] in1,
    input  logic [31:0] in2,
    input  logic [31:0] in3,
    input  logic [1:0]  sel,

    output logic [31:0] out
);

always_comb begin

    case (sel) begin
        00 : out = in0;
        01 : out = in1;
        10 : out = in2;
        11 : out = in3;
        default : out = 'x;
    end

end

endmodule

