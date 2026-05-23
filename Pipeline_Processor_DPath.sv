`include "register_32b.sv"
`include "register_64b.sv"
`include "mux4to1_64b.sv"
`include "adder_64b.sv"
`include "immediate_generator.sv"
`include "mux2to1_64b.sv"
`include "ALU_64b.sv"

module Pipeline_Processor_DataPath (
    input  logic       en,
    input  logic       rst,
    input  logic       clk,

    //------ Control Signals ------// 
    input  logic [1:0] imm_type,
    input  logic [1:0] pc_sel,
    input  logic       pc_en,
    input  logic       decode_reg_en,
    input  logic [1:0] op1_bypass_sel,
    input  logic [1:0] op2_bypass_sel,
    input  logic       op1_sel,
    input  logic       op2_sel,
    input  logic       alu_func,
    input  logic       res_sel,
    input  logic       wb_sel,
    input  logic       rf_waddr,
    input  logic       rf_wen,
    input  logic       pc_reg_f_en,
    input  logic       reg_en_fd,
    //------ (TO BE DRIVEN) -------//

    //---- Memory Interfacing ----//
    input  logic [63:0] imem_rdata,
    output logic [5:0]  imem_addr,

    input  logic [63:0] dmem_rdata,
    output logic [4:0]  dmem_addr,
    output logic [63:0] dmem_wdata,
    //---------------------------//
    
    //------- To Control -------// 
    output logic        eq,
    output logic [31:0] instr
    //--------------------------//

    );
/* 
 * Note: The stages will include anything on the
 * border to the next stage. 
 * Example: The PC register between F and D will be
 * considered part of the F stage for the sake of these
 * sections.
 * The register file, which is in both the D and W stages
 * will be in W, since it cannot be split.
 */

//---------- Fetch Stage ----------//

logic [63:0] pc_mux_out;
logic [63:0] bne_target;
logic [63:0] jal_target;
logic [63:0] jr_target;
logic [63:0] pc_p4;
logic [63:0] pc_f_out;
logic [63:0] pd_fd_out;

mux4to1_64b pc_mux (
    .in0 (bne_target),
    .in1 (jal_target),
    .in2 (jr_target),
    .in3 (pc_p4),
    .sel (pc_sel),
    .out (pc_mux_out)
    );

register_64b pc_f (
    .d   (pc_mux_out),
    .rst (rst),
    .en  (pc_reg_f_en),
    .clk (clk),
    .q   (pc_f_out)
    );

adder_64b pc_plus4_adder (
    .in0 (pc_f_out),
    .in1 (64'd4),
    .out (pc_p4)
    );

register_64b pc_fd (
    .d   (pc_f_out),
    .rst (rst),
    .en  (reg_en_fd),
    .clk (clk),
    .q   (pc_fd_out)
    );

assign imem_addr = pc_f_out;

register_32b ir_fd (
    .d   (imem),
    .rst (rst),
    .en  (reg_en_fd),
    .clk (clk),
    .q   (instr)
    );

//---------- Decode Stage ----------//

logic [31:0] sext_imm;
logic [63:0] sext_imm_64b;

immediate_generator immgen (
    .imm_type (imm_type),
    .instr    (instr),
    .sext_imm (sext_imm)
    );

assign sext_imm_64b[63:32] = 32'b0;
assign sext_imm_64b[31:0] = sext_imm;

logic [63:0] w_bypass;
logic [63:0] m_bypass;
logic [63:0] x_bypass;
logic [63:0] op1_byp_out;
logic [63:0] op2_byp_out;
logic [63:0] rf_rdata0;
logic [63:0] rf_rdata1;

mux4to1_64b op1_byp_mux (
    .in0 (w_bypass),
    .in1 (m_bypass),
    .in2 (x_bypass),
    .in3 (rf_rdata0),
    .sel (op1_bypass_sel),
    .out (op1_byp_out)
    );

mux4to1_64b op2_byp_mux (
    .in0 (w_bypass),
    .in1 (m_bypass),
    .in2 (x_bypass),
    .in3 (rf_rdata1),
    .sel (op2_bypass_sel),
    .out (op2_byp_out)
    );

logic [63:0] op1_out;
logic [63:0] op2_out;

mux2to1_64b op1_mux (
    .in0 (pc_fd_out),
    .in1 (op1_byp_out),
    .sel (op1_sel),
    .out (op1_out)
    );

mux2to1_64b op2_mux (
    .in0 (pc_fd_out),
    .in1 (op2_byp_out),
    .sel (op2_sel),
    .out (op2_out)
    );

adder_64b pc_imm_adder (
    .in0 (pc_fd_out),
    .in1 (sext_imm),
    .sum (jal_target)
    );

register_64b branch_targ_reg (
    .d   (jal_targ),
    .rst (rst),
    .en  (en),
    .clk (clk),
    .q   (bne_target)
    );

logic [63:0] op1_reg_out;
logic [63:0] op2_reg_out;
logic [63:0] dmem_d_reg_out;

register_64b op1_reg (
    .d   (op1_out),
    .rst (rst),
    .en  (en),
    .clk (clk),
    .q   (op1_reg_out)
    );

register_64b op2_reg (
    .d   (op2_out),
    .rst (rst),
    .en  (en),
    .clk (clk),
    .q   (op2_reg_out)
    );

register_64b dmem_d_reg (
    .d   (op2_out),
    .rst (rst),
    .en  (en),
    .clk (clk),
    .q   (dmem_d_reg_out)
    );

//---------- Execute Stage ----------//

logic [63:0] mul_out;
logic [63:0] alu_out;

multiplier_64b multiplier (
    .in0     (op1_reg_out),
    .in1     (op2_reg_out),
    .product (mul_out)
    );

ALU_64b alu (
    .in0    (op1_reg_out),
    .in1    (op2_reg_out),
    .op     (alu_func),
    .result (alu_out)
    );

mux2to1_64b res_mux (
    .in0 (mul_out),
    .in1 (alu_out),
    .sel (res_sel),
    .out (x_bypass)
    );

register_64b res_reg (
    .d   (x_bypass),
    .rst (rst),
    .en  (en),
    .clk (clk),
    .q   (dmem_addr)
    );

register_64b dmem_x_reg (
    .d   (dmem_d_reg_out),
    .rst (rst),
    .en  (en),
    .clk (clk),
    .q   (dmem_wdata)
    );

//---------- Memory Stage ----------//

mux2to1_64b mem_mux (
    .in0 (dmem_addr),
    .in1 (dmem_rdata),
    .sel (wb_sel),
    .out (m_bypass)
    );

register_64b mem_reg (
    .d   (m_bypass),
    .rst (rst),
    .en  (en),
    .clk (clk),
    .q   (w_bypass)
    );

//---------- Writeback Stage ----------//

regfile_32x64 regfile (
    .clk (clk),
    .rst (rst),
    .raddr0 (instr[19:15]),
    .raddr1 (instr[24:20]),
    .rdata0 (rf_rdata0),
    .rdata1 (rf_rdata1),
    .w_en   (rf_wen),
    .waddr  (rf_waddr),
    .wdata  (w_bypass)
    );
