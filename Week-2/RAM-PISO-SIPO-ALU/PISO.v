module PISO #(parameter WIDTH = 20) (
    input clk, rst_n,
    input [WIDTH - 1:0] parallel_in,
    input en, //Driven by RAM when reading is valid
    output reg serial_out, valid
);

reg [$ceil($clog2(WIDTH)) - 1:0] serial_count;
reg [WIDTH - 1:0] parallel_in_reg;

//insures that the data in parallel_in_reg is taken from the ram before 
reg parallel_in_valid;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        serial_count <= '0;
        parallel_in_reg <= '0;
        parallel_in_valid <= 1'b0;
        serial_out <= 1'b0;
        valid <= 1'b0;
    end
    else begin
        //Default values
        valid <= 1'b0;
        serial_out <= 1'b0;

        //Load the parallel_in value only when enable is on and when not busy
        if (en && ~parallel_in_valid) begin
            parallel_in_reg <= parallel_in;
            parallel_in_valid <= 1'b1;
        end

        if (parallel_in_valid) begin
            //Output MSB first
            serial_out <= parallel_in_reg[WIDTH - 1];

            //Shift the register for the next iteration
            parallel_in_reg <= {parallel_in_reg[WIDTH - 2:0], 1'b0};

            //Increment counter and set valid
            serial_count <= serial_count + 1;
            valid <= 1'b1;

            //For the last iteration, reset counter and deassert parallel_in_valid to end serialization
            if (serial_count == WIDTH - 1) begin
                serial_count <= '0;
                parallel_in_valid <= 1'b0;
            end
        end
    end
    
end
endmodule