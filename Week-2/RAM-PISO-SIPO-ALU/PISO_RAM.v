module PISO_RAM #(parameter DATA_WIDTH = 20, ADDR_WIDTH = 8)  (
    input clk, rst_n,
    input wr_en,
    input [ADDR_WIDTH - 1:0] addr,
    input [DATA_WIDTH - 1:0] din,
    input rd_en,
    output  serial_out, valid
);

wire PISO_en;
wire [DATA_WIDTH - 1:0] parallel_data;

RAM #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) ram 
(
    .clk(clk), .rst_n(rst_n),
    .wr_en(wr_en),
    .addr(addr),
    .din(din),
    .rd_en(rd_en),
    .dout(parallel_data),
    .valid(PISO_en)
);

PISO #(.WIDTH(DATA_WIDTH)) piso 
(
    .clk(clk),
    .rst_n(rst_n),
    .parallel_in(parallel_data),
    .en(PISO_en),
    .serial_out(serial_out),
    .valid(valid)
);

endmodule