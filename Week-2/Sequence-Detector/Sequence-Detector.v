module Sequence_Detector (
    input clk, rst_n,
    input serial_in,
    output reg detected_overlapping, detected_non_overlapping
);

parameter   IDLE = 3'h0,
            DETECTED_1 = 3'h1,
            DETECTED_01 = 3'h2,
            DETECTED_101 = 3'h3,
            DETECTED_0101 = 3'h4,
            DETECTED_10101 = 3'h5,
            DETECTED_110101 = 3'h6;


reg [6:0] seq_reg;
reg [3:0] current_state_ol, next_state_ol, current_state_nol, next_state_nol;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        current_state_ol <= 0;
        current_state_nol <= 0;
        detected_overlapping <= 0;
        detected_non_overlapping <= 0;

    end else begin
        current_state_ol <= next_state_ol;
        current_state_nol <= next_state_nol;
        detected_overlapping <= current_state_ol == DETECTED_110101;
        detected_non_overlapping <= current_state_nol == DETECTED_110101;
    end
    
end

//Non Overlapping fsm
always @(*) begin
    case (current_state_nol)
    IDLE:            next_state_nol = serial_in? DETECTED_1:IDLE;
    DETECTED_1:      next_state_nol = serial_in? DETECTED_1:DETECTED_01;
    DETECTED_01:     next_state_nol = serial_in? DETECTED_101:IDLE;
    DETECTED_101:    next_state_nol = serial_in? DETECTED_1:DETECTED_0101;
    DETECTED_0101:   next_state_nol = serial_in? DETECTED_10101:IDLE;
    DETECTED_10101:  next_state_nol = serial_in? DETECTED_110101:DETECTED_0101;
    DETECTED_110101: next_state_nol = serial_in? DETECTED_1:IDLE;
    endcase
end



//Overlapping fam
always @(*) begin
    case (current_state_ol)
    IDLE:            next_state_ol = serial_in? DETECTED_1:IDLE;
    DETECTED_1:      next_state_ol = serial_in? DETECTED_1:DETECTED_01;
    DETECTED_01:     next_state_ol = serial_in? DETECTED_101:IDLE;
    DETECTED_101:    next_state_ol = serial_in? DETECTED_1:DETECTED_0101;
    DETECTED_0101:   next_state_ol = serial_in? DETECTED_10101:IDLE;
    DETECTED_10101:  next_state_ol = serial_in? DETECTED_110101:DETECTED_0101;
    DETECTED_110101: next_state_ol = serial_in? DETECTED_1:DETECTED_01;
    endcase
end
endmodule