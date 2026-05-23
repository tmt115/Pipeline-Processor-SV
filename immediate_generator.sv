module immediate_generator (
    input  logic [1:0]  imm_type,
    input  logic [31:0] instr,
    
    output logic [31:0] sext_imm
    );

always_comb begin

    case(imm_type) begin
        (00) : sext_imm = {21{instr[31]}, instr[30:25], instr[24:21], instr[20]};
        (01) : sext_imm = {21{instr[31]}, instr[30:25], instr[11:8], instr[7]};
        (10) : sext_imm = {12{instr[31]}, instr[19:12], instr[20], instr[30:25], instr[24:21], 1'b0};
        (11) : sext_imm = {20{instr[31]}, instr[7], instr[30:25], instr[11:8], 1'b0};
        default : sext_imm = 'x;
    end

end

endmodule

