module MUX_tb ();
    reg [4:0] in0,in1;
    reg sel;
    wire [4:0] mux_out;
    MUX #(.WIDTH(5)) dut (.in0(in0), .in1(in1), .sel(sel), .mux_out(mux_out));

    initial begin
        sel = 0; in0 = 5'b10101; in1 = 5'b00000; #10;
        $display("At time %0t sel=%b in0=%b mux_out=%b", $time, sel, in0, in1, mux_out);
        if (mux_out == in0)
            $display("test 1 passed");
        else 
            $display("Test 1 failed");

        sel = 0; in0 = 5'b01010; in1 = 5'b00000; #10;
        $display("At time %0t sel=%b in0=%b mux_out=%b", $time, sel, in0, in1, mux_out);
        if (mux_out == in0)
            $display("test 2 passed");
        else 
            $display("Test 2 failed");

        sel = 1; in0 = 5'b00000; in1 = 5'b10101; #10;
        $display("At time %0t sel=%b in0=%b mux_out=%b", $time, sel, in0, in1, mux_out);
        if (mux_out == in1)
            $display("test 3 passed");
        else 
            $display("Test 3 failed");

        sel = 1; in0 = 5'b00000; in1 = 5'b01010; #10;
        $display("At time %0t sel=%b in0=%b mux_out=%b", $time, sel, in0, in1, mux_out);
        if (mux_out == in1)
            $display("test 4 passed");
        else 
            $display("Test 4 failed");
        $stop;
    end
endmodule