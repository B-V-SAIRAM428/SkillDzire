`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.12.2025 12:54:58
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU#(parameter in_width =8,
               out_width=16,
               alu_op_width =4 )
    (
    input [in_width-1:0] op1,    // input 1
    input [in_width-1:0] op2,    // input 2
    input [alu_op_width-1:0] alu_op, //function tell's what operation needs to be done
    input not_in,// NOT input, it will help to know which operator need to be inversed(logic "1" for op1 and logic "0" for op2)
    output wire zero_flag, // Check the result was Zero or not
    output reg carry,       //carry flag
    output reg LT,          // lessthan
    output reg GT,          //greaterthan
    output reg EQ,          // same
    output reg [out_width-1:0] result      // output 
    );
    always@(*) begin
        result = 16'd0;
        LT = 0;
        GT = 0;
        EQ = 0;
        carry = 0;
        case(alu_op)
            4'd0: {carry,result} = op1+op2;         // Addition
            4'd1: {carry,result} = op1-op2;         // Sub
            4'd2: result = op1*op2;                 // mul
            4'd3: result = op1>op2?op1/op2:op2/op1; // Division gone depends upon the value of op
            4'd4: result = op1&op2;                 // bit wise AND
            4'd5: result = op1|op2;                 // bit wise OR
            4'd6: result = op1>>op2;                // right shift by op2
            4'd7: result = op1<<op2;                // left shift by op2
            4'd8: result = op1 ^ op2;               // XOR
            4'd9: result = ~(op1^op2);              // NXOR
            4'd10: result = ~(op1&op2);                 // NAND
            4'd11: result = ~(op1|op2);                 // NOR 
            4'd12: LT = op1<op2;                 // LESSTHAN
            4'd13: GT = op1>op2;                 // GREATER THAN
            4'd14: EQ = (op1==op2);              // Equal
            4'd15: result = not_in?~op1:~op2;    //NOT 
            default: begin
                result = 16'd0;
                LT = 0;
                GT = 0;
                EQ = 0;
                carry = 0;
            end
        endcase
    end
    assign zero_flag = (result==16'd0);
endmodule
