module RAM #(parameter DATA_WIDTH = 20, ADDR_WIDTH = 8) (
    input clk, rst_n,
    input wr_en,
    input [ADDR_WIDTH - 1:0] addr,
    input [DATA_WIDTH - 1:0] din,
    input rd_en,
    output reg [DATA_WIDTH - 1:0] dout,
    output reg valid
);

reg [DATA_WIDTH - 1:0] mem [0:2**ADDR_WIDTH - 1];

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        dout <= '0;
        valid <= 1'b0;
    end
    else begin
        //default values
        valid <= 1'b0;
        dout <= '0;
        
        //assuming that priority is given to write to avoid to race condition
        if (wr_en)
            mem[addr] <= din;
        else if (rd_en) begin
            dout <= mem[addr];
            valid <= 1'b1;
        end
    end
end

endmodule