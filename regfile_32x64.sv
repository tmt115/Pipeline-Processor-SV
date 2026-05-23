module regfile_64x64 (
    input  logic clk,
    input  logic rst,

    input  logic [4:0]  raddr0,
    input  logic [4:0]  raddr1,
    output logic [63:0] rdata0,
    output logic [63:0] rdata1,

    input  logic        w_en,
    input  logic [4:0]  waddr,
    input  logic [63:0] wdata
);

logic [63:0] file[32];

always_ff @(posedge clk) begin

    if (res) begin
        for (int x = 0; x < 32; x++) begin
            file[x] <= 0;
        end
    end
    if (w_en) begin
        if (waddr == 0) begin
            file[waddr] <= 64'b0;
        end
        else begin
            file[waddr] <= wdata;
        end
    end
end

always_comb begin
    
    rdata0 = file[raddr0];
    rdata1 = file[raddr1];

end

endmodule

