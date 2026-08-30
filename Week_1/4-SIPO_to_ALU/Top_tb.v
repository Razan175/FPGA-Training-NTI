module Top_tb;
reg clk, rst_n, serial_in, shift_en;
wire busy_flag;
wire [7:0] alu_out;
wire a_is_zero;

Top dut (.*);

reg [19:0] input_instruction;
reg [7:0] expected_out;
initial forever #10 clk = ~clk;

integer i, timeout;
initial begin
    clk = 0; rst_n = 0; serial_in = 0; shift_en = 0;
    repeat(200) begin
        @(negedge clk) rst_n = 1;
        input_instruction = $random;
        
        //Send data serially starting from the MSB
        for (i = 19; i >= 0; i = i - 1) begin
            //Enable and send bit
            @(negedge clk) shift_en = 1;
            serial_in = input_instruction[i];

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

        //Calculate the expected value
        if (input_instruction[19] == 0)
            expected_out = 0;
        else begin
            case(input_instruction[18:16])
            3'b000: expected_out = input_instruction[15:8] + input_instruction[7:0];
            3'b001: expected_out = input_instruction[15:8] - input_instruction[7:0];
            3'b010: expected_out = input_instruction[15:8] & input_instruction[7:0];
            3'b011: expected_out = input_instruction[15:8] ^ input_instruction[7:0];
            3'b100: expected_out = input_instruction[15:8] | input_instruction[7:0];
            3'b101: expected_out = input_instruction[15:8];
            default: expected_out = 0;
            endcase
        end

        //Compare the output to the expected output
        if (alu_out == expected_out)
            $display ("ALU output is correct, expected: %h actual: %h,  opcode:%b, A: %h B: %h,", expected_out, alu_out, input_instruction[18:16], input_instruction[15:8], input_instruction[7:0]);
        else
            $error("ALU output is not as expected, expected: %h actual: %h", expected_out, alu_out);

        @(negedge clk) rst_n = 0;
    end

    $stop;
end
endmodule