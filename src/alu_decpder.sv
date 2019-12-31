module ALUDecoder(input logic[5:0] funct,
                 input logic[1:0] alu_op,
                 output logic[2:0] alu_control);

   always_comb
       if (alu_op[1:0] == 2'b10 && funct[3:0] == 4'b0000)
           alu_control = 3'b010;
       else if (alu_op[1:0] == 2'b10 && funct[3:0] == 4'b0010)
           alu_control = 3'b110;
       else if (alu_op[1:0] == 2'b10 && funct[3:0] == 4'b0100)
           alu_control = 3'b000;
       else if (alu_op[1:0] == 2'b10 && funct[3:0] == 4'b0101)
           alu_control = 3'b001;
       else if (alu_op[1:0] == 2'b10 && funct[3:0] == 4'b1010)
           alu_control = 3'b111;
       else if (alu_op[1:0] == 2'b00)
           alu_control = 3'b010;
       else if (alu_op[1:0] == 2'b01)
           alu_control = 3'b110;

endmodule
