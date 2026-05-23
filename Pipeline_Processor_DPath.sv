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
    //
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
    //--------------------------//

    );
/*
 * Note: The stages will include anything on the
 * border to the next stage. 
 * Example: The PC register between F and D will be
 * considered part of the F stage for the sake of these
 * sections.
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


