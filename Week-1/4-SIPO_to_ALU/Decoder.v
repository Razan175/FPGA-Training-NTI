module Decoder #(parameter WIDTH = 3)(
    input [WIDTH - 1:0] i_in,
    output reg [(2**WIDTH) - 1:0] o_out 
);

always @(*) begin
    o_out = 0;
    o_out[i_in] = 1'b1;
end
    
endmodule