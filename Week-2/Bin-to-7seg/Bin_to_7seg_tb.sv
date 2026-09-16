module Bin_to_7seg_tb;
    reg [3:0] bin_in;
    wire [6:0] seg_out;

    Bin_to_7seg dut (.*);

    initial begin
        for (int i = 0; i < 15; i++) begin
            bin_in = i;
        end
    end
endmodule