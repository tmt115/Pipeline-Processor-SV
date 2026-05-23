module equality_comparator_64b (
    input [63:0] in0,
    input [63:0] in1,

    output       eq
);

always_comb begin
    
    eq = 'x;
    
    if (in0 == in1) begin
        eq = 1'b1;
    end
    else begin
        eq = 1'b0;
    end

end

endmodule

