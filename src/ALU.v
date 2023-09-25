//! @title Unidad Aritmetica Logica
//! @author Gerard Brian - Rodriguez Emanuel
//! @date 08-09-2023

//! This module implements an Arithmetic Logic Unit (ALU) that performs arithmetic and logical operations on two signed inputs of NB_AB bits each, based on the operation code i_operation of NB_OP bits. The output o_result is also a signed number of NB_AB bits.
`timescale 1ns/100ps
module ALU
#(
    parameter     NB_OP   =    6,  //! Number of bits of the operation
    parameter     NB_AB   =    8   //! Number of bits of the operands

)
(
    input            [NB_OP - 1: 0]  i_operation, //! Operation code
    input    signed  [NB_AB - 1: 0]      i_Adata, //! First operand
    input    signed  [NB_AB - 1: 0]      i_Bdata, //! Second operand
    output   signed  [NB_AB - 1: 0]     o_result  //! Result of the operation
);

reg signed [NB_AB - 1:0] temp_result;

always @(*) begin
    case (i_operation)
    6'b100000: temp_result =    i_Adata  +   i_Bdata ; //! Addition
    6'b100010: temp_result =    i_Adata  -   i_Bdata ; //! Subtraction
    6'b100100: temp_result =    i_Adata  &   i_Bdata ; //! Bitwise AND
    6'b100101: temp_result =    i_Adata  |   i_Bdata ; //! Bitwise OR
    6'b100110: temp_result =    i_Adata  ^   i_Bdata ; //! Bitwise XOR
    6'b100111: temp_result =  ~(i_Adata  ^   i_Bdata); //! Bitwise NOT XOR
    6'b000011: temp_result =    i_Adata >>>  i_Bdata ; //! Logical right shift
    6'b000010: temp_result =    i_Adata  >>  i_Bdata ; //! Arithmetic right shift
    default  : temp_result =           {NB_AB{1'b0}} ; //! Default value
    endcase
end

assign o_result = temp_result;

endmodule