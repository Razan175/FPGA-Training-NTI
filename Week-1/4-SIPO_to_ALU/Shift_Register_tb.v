module SIPO_tb;
reg clk, rst_n, serial_in, shift_en;
wire busy_flag;
wire [19:0] parallel_out;

Shift_Register #(.WIDTH(20)) dut (
    .clk(clk),
    .rst_n(rst_n),
    .serial_in(serial_in),
    .shift_en(shift_en),
    .busy_flag(busy_flag),
    .parallel_out(parallel_out)
    );

reg [19:0] expected_data;
initial forever #10 clk = ~clk;

integer i, timeout;
initial begin
    clk = 0; rst_n = 0;
    repeat(20) begin
        @(negedge clk) rst_n = 1;
        expected_data = $random;
        
        //Send data serially starting from the MSB
        for (i = 19; i >= 0; i = i - 1) begin
            //Enable and send bit
            @(negedge clk) shift_en = 1;
            serial_in = expected_data[i];

            //Disable for one cycle to test the busy flag (busy flag is not asserted on the last cycle)
            @(negedge clk) shift_en = 0;
            if (~busy_flag && i != 0)
                $error("Busy flag not asserted");
        end

        //Wait for the busy flag to be lowered 
        while (busy_flag) begin
            @(negedge clk)
            timeout = timeout + 1;
            if (timeout > 20) begin
                $error("busy flag reached wait time limit");
                //break; (works in systemverilog only)
            end
        end

        //Check the output
        if (parallel_out == expected_data)
            $display ("SIPO output is correct, expected: %h actual: %h", expected_data, parallel_out);
        else
            $error("SIPO output is not as expected, expected: %h actual: %h", expected_data, parallel_out);

        @(negedge clk) rst_n = 0;
    end

    $stop;
end
endmodule