module SIPO #(parameter WIDTH = 20)  (
    input clk, rst_n, serial_in, shift_en,
    output [WIDTH - 1:0] parallel_out, 
    output busy_flag
);

reg [WIDTH - 1:0] shift_reg;
reg [($clog2(WIDTH)) - 1:0] busy_count_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        shift_reg <= 0;
        busy_count_reg <= 0;
    end
    else if (shift_en) begin
        //Shift left
        shift_reg <= {shift_reg[WIDTH - 2:0], serial_in};
        
        //Count the number of bits received, reset counter when done (the same cycle as the last bit)
        busy_count_reg <= busy_count_reg + 1;
        if (busy_count_reg == WIDTH - 1)
            busy_count_reg <= 0;
    end
end

//Output wire
assign parallel_out = shift_reg;

//Asserts the Busy flag when the counter starts
assign busy_flag = (busy_count_reg > 0);
endmodule