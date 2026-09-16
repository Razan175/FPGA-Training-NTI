module stream_parity_gen (
    input clk, reset, serial_in,
    output parity_out
);

reg [7:0] bits_rec;

function parity_gen (input[7:0] bits_rec); 
begin
    parity_gen = ^bits_rec;
end
endfunction

assign parity_out = parity_gen(bits_rec);

always @(posedge clk or negedge reset) begin
    if (~reset) begin
        bits_rec <= 0;
    end else begin
        bits_rec <= {serial_in, bits_rec[7:1]};
    end
end

    
endmodule