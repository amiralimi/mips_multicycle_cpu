module ControlUnit(input logic[5:0] opcode, funct, 
                  input logic clk, reseet, 
                  output logic mem_to_reg, reg_dest, i_or_d, alu_src_a, ir_write, mem_write, pc_write, branch, reg_write,
                  output logic[1:0] alu_src_b, pc_src,
                  output logic[2:0] alu_control);
   
   logic [1:0] alu_op; 
   state_machine sm(clk, reset, opcode, mem_to_reg, reg_dest, i_or_d, alu_src_a, ir_write, mem_write, pc_write, branch, reg_write, alu_src_b, pc_src, alu_op);
   ALUDecoder ad(funct, alu_op, alu_control);

endmodule
