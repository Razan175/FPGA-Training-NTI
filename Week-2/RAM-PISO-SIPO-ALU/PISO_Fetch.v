module PISO_Fetch #(parameter DATA_WIDTH = 20, ADDR_WIDTH = 8) (
    input clk, rst_n,
    input [DATA_WIDTH - 1:0] parallel_in,
    input valid_in, //Extra signal driven by RAM when dout(parallel_in) is valid
    output reg [ADDR_WIDTH - 1:0] RAM_addr, //Extra signal to send address to the PISO
    output reg en,
    output reg serial_out, valid_out
);

reg [$ceil($clog2(DATA_WIDTH)) - 1:0] serial_count;
reg [DATA_WIDTH - 1:0] parallel_in_reg;
reg [ADDR_WIDTH - 1:0] next_addr;

//insures that the data in parallel_in_reg is taken from the ram before 
reg parallel_in_valid;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
    end
    else begin
        //Default values
        en <= 1'b0;
        serial_out <= 1'b0;
        valid_out <= 1'b0;

        //When idle, request data
        if (serial_count == 0) begin
            en <= 1'b1;
            serial_count <= '1;
            RAM_addr <= next_addr;
            next_addr <= next_addr + 1;
        end else if (parallel_in_valid) begin
            //Serial output with LSB first
            serial_out <= parallel_in_reg[DATA_WIDTH - 1];

            //Shift the register values for the next iteration
            parallel_in_reg <= {parallel_in_reg[DATA_WIDTH - 2:1], 1'b0};

            //Increment Counter and assert valid_out
            serial_count <= serial_count + 1;
            valid_out <= 1'b1;

            //Reset values when serialization is done
            if (serial_count == DATA_WIDTH) begin
                serial_count <= '0;
                parallel_in_valid <= 1'b0;
            end
        end

        //Load data only when there is valid data from the RAM and no data is currently being set
        if (valid_in && (~parallel_in_valid)) begin
            parallel_in_reg <= parallel_in;
            parallel_in_valid <= 1'b1;
        end
    end
    
end
endmodule