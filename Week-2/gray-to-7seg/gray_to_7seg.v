module gray_to_7seg (
    input [3:0] gray_in,
    output [6:0] seg_out
);
    //Convert to binary and then convert binary to 7 segment
    reg [3:0] bin_reg;
    gray_to_bin gtb (.gray_in(gray_in), .bin_out(bin_reg));
    bin_to_7seg bto7 (.bin_in(bin_reg), .seg_out(seg_out));
endmodule