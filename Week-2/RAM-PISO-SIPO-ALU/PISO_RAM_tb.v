module PISO_RAM_TB;
    reg clk, rst_n;
    reg wr_en;
    reg [7:0] addr;
    reg [19:0] din;
    reg rd_en;
    wire serial_out;
    wire valid;

    PISO_RAM #(.DATA_WIDTH(20), .ADDR_WIDTH(8)) dut (.*);

    reg [19:0] expected_data;
    reg [19:0] actual_data;

    integer timeout, i;
    initial forever #10 clk = ~clk; 
    
    initial begin
        clk = 0; rst_n = 1'b0; rd_en = 0; wr_en = 0;
        @(negedge clk) rst_n = 1'b1;

        repeat (20) begin
            //Randomize
            randomize_input();
            
            //Write data 
            set_ram_enables(1'b1,1'b0);

            //Disable write, enable read to drive piso
            set_ram_enables(1'b0, 1'b1);

            //Clear enables for next iteration
            set_ram_enables(1'b0, 1'b0);

            //waiting for valid to be asserted 
            wait_for_valid();

            //Collect the serial output while valid is 1 to verify it
            collect_output();

            //Compare
            validate_output();
        end
        $stop;
    end

    task randomize_input();
    begin
        //Randomize parallel data and address
        expected_data = $random;
        din = expected_data;

        addr = $random;
    end
    endtask

    task set_ram_enables(input reg write, read); begin
        @(negedge clk)
        wr_en = write; rd_en = read;
    end
    endtask

    task wait_for_valid(); begin
        //wait for valid
        timeout = 0;
        while (~valid)
        begin
            @(negedge clk);
            timeout = timeout + 1;
            if (timeout > 20)
                $fatal("Valid signal never asserted");
        end
    end
    endtask

    task collect_output();
    begin
        i = 19;
        while (valid) begin
            if (i < 0)
                $fatal("Valid remained on after 20 cycles");
            else begin
                actual_data[i] = serial_out;
                i = i - 1;
                @(negedge clk);
            end
        end
    end    
    endtask

    task validate_output;
        if (expected_data == actual_data)
            $display("Test Succesful, expected data: %h, actual_data: %h",expected_data, actual_data);
        else 
            $error("Test fail, expected data: %h, actual_data: %h",expected_data, actual_data);
    endtask
endmodule