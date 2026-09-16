module Top (
    input clk, rst_n, serial_in, shift_en,
    output busy_flag,
    output [7:0] alu_out,
    output a_is_zero
);

wire [19:0] parallel_out;

SIPO #(.WIDTH(20)) sipo (
    .clk(clk), 
    .rst_n(rst_n), 
    .shift_en(shift_en), 
    .serial_in(serial_in), 
    .parallel_out(parallel_out), 
    .busy_flag(busy_flag)
);

ALU #(.WIDTH(8)) alu (
    .alu_en(parallel_out[19]), 
    .opcode(parallel_out[18:16]), 
    .in_a(parallel_out[15:8]), 
    .in_b(parallel_out[7:0]),
    .alu_out(alu_out),
    .a_is_zero(a_is_zero)
    );

endmodule