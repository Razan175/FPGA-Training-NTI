module Sequence_detector_tb;
    reg clk, rst_n;
    reg serial_in;
    reg detected_overlapping, detected_non_overlapping;

    Sequence_Detector DUT (.*);
    reg [5:0] seq;

    initial forever #10 clk = ~clk;
    
    initial begin
        clk = 0; rst_n = 0; serial_in = 0;
        @(negedge clk) rst_n = 1;

        $display("Checking normal sequence");
        seq = 6'b110101;
        for (int i = 0; i < 6; i = i + 1) begin
           @(negedge clk) serial_in = seq[i];
        end
        
        @(negedge clk);
        
        if (detected_overlapping && detected_non_overlapping) 
            $display("Success");
        else
            $display("fail");
        
        $display("Checking overlapping sequence.. ");

        serial_in = 0;
        for (int i = 2; i < 6; i = i + 1) begin
           @(negedge clk) serial_in = seq[i];
        end

        @(negedge clk);
       // @(negedge clk);

        if (detected_overlapping && ~detected_non_overlapping) 
            $display("Success");
        else
            $display("fail");
    end
endmodule