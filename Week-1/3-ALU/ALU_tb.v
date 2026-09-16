module ALU_tb ();
    reg [7:0] in_a,in_b;
    reg [2:0] opcode;
    
    wire [7:0] alu_out;
    wire a_is_zero;

    ALU #(.WIDTH(8)) dut (.in_a(in_a), .in_b(in_b), .opcode(opcode), .alu_out(alu_out), .a_is_zero(a_is_zero));

    initial begin
        in_a =8'b01000010; in_b = 8'b10000110; opcode = 0; #10;
        $display("At time %0t opcode =%b in_a=%b in_b=%b a_is_zero=%b alu_out=%b", $time, opcode, in_a, in_b, a_is_zero, alu_out);
        if (alu_out == in_a && !a_is_zero)
            $display("test 1 passed");
        else 
            $display("Test 1 failed");

        opcode = 1;#10;
        $display("At time %0t opcode =%b in_a=%b in_b=%b a_is_zero=%b alu_out=%b", $time, opcode, in_a, in_b, a_is_zero, alu_out);
        if (alu_out == in_a - in_b && !a_is_zero)
            $display("test 2 passed");
        else 
            $display("Test 2 failed");

        opcode = 2;#10;
        $display("At time %0t opcode =%b in_a=%b in_b=%b a_is_zero=%b alu_out=%b", $time, opcode, in_a, in_b, a_is_zero, alu_out);
        if (alu_out == in_a + in_b && !a_is_zero)
            $display("test 3 passed");
        else 
            $display("Test 3 failed");

        opcode = 3;#10;
        $display("At time %0t opcode =%b in_a=%b in_b=%b a_is_zero=%b alu_out=%b", $time, opcode, in_a, in_b, a_is_zero, alu_out);
        if (alu_out == (in_a & in_b) && !a_is_zero)
            $display("test 4 passed");
        else 
            $display("Test 4 failed");
        
        opcode = 4;#10;
        $display("At time %0t opcode =%b in_a=%b in_b=%b a_is_zero=%b alu_out=%b", $time, opcode, in_a, in_b, a_is_zero, alu_out);
        if ((alu_out == in_a ^ in_b) && !a_is_zero)
            $display("test 5 passed");
        else 
            $display("Test 5 failed");

        opcode = 5;#10;
        $display("At time %0t opcode =%b in_a=%b in_b=%b a_is_zero=%b alu_out=%b", $time, opcode, in_a, in_b, a_is_zero, alu_out);
        if (alu_out == in_b && !a_is_zero)
            $display("test 6 passed");
        else 
            $display("Test 6 failed");

        opcode =6;#10;
        $display("At time %0t opcode =%b in_a=%b in_b=%b a_is_zero=%b alu_out=%b", $time, opcode, in_a, in_b, a_is_zero, alu_out);
        if (alu_out == in_a && !a_is_zero)
            $display("test 7 passed");
        else 
            $display("Test 7 failed");
        
        opcode = 7; in_a = 0; #10;
        $display("At time %0t opcode =%b in_a=%b in_b=%b a_is_zero=%b alu_out=%b", $time, opcode, in_a, in_b, a_is_zero, alu_out);
        if (alu_out == in_a && a_is_zero)
            $display("test 8 passed");
        else 
            $display("Test 8 failed");
        $stop;
        
    end
endmodule