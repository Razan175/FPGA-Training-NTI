module stream_parity_gen_tb ();
    reg clk, reset, serial_in;
    wire parity_out;

    stream_parity_gen du (.*);
    
    reg[7:0] bits_sent;
    
    reg[7:0] bits_received;

    initial begin
        
        clear_all();
        reset_all();
        
    end

    task clear_all();
    begin
        @(negedge clk) 
        clk = 0; reset = 0; serial_in = 0;
    end
    endtask

    task reset_all; begin
        @(negedge clk) reset = 0;
        @(negedge clk) reset = 1;
    end
    endtask
endmodule