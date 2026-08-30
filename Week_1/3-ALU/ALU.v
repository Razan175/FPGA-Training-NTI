module ALU #(parameter WIDTH = 8) (
    input [WIDTH - 1:0] in_a, in_b,
    input [2:0] opcode, 
    input alu_en,
    output [WIDTH - 1:0] alu_out,
    output a_is_zero 
);

reg [WIDTH - 1:0] alu_op_reg;

//Operation Selection logic
always @(*) begin
    case (opcode)
        3'b000: alu_op_reg = in_a + in_b; //add
        3'b001: alu_op_reg = in_a - in_b; // sub
        3'b010: alu_op_reg = in_a & in_b; // and
        3'b011: alu_op_reg = in_a ^ in_b; // xor
        3'b100: alu_op_reg = in_a | in_b; // or
        3'b101: alu_op_reg = in_a; //Pass A
        default: alu_op_reg = '0; //no operation
    endcase
end

//Output based on enable
assign alu_out = alu_en? alu_op_reg :'0;

//Outputs 1 is a is zero regardless of enable
assign a_is_zero = (in_a == 0);

endmodule