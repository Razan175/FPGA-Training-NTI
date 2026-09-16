module gray_to_bin #(parameter WIDTH = 4)(
    input [WIDTH - 1:0] gray_in,
    output [WIDTH - 1:0] bin_out
);

// The MSB in gray code is the same as the MSB in binary
assign bin_out[WIDTH - 1] = gray_in[WIDTH - 1];

genvar i;
generate
    //Xor the corresponding bit to the previous binary bit
    // Example: bin_out[2] = bin_out[3] ^ gray_in[2]
    for (i = WIDTH - 2; i >= 0 ; i = i - 1) begin
        assign bin_out[i]  = bin_out[i + 1] ^ gray_in[i];
    end
endgenerate

endmodule