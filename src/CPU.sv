module CPU(input clk, reset);

    logic mem_to_reg, reg_dest, i_or_d, alu_src_a, ir_write, mem_write, pc_write, branch, reg_write;
    logic[1:0] alu_src_b, pc_src;
    logic[2:0] alu_control;
    logic[5:0] opcode, funct;

    DataPath data_path(mem_to_reg, reg_dest, i_or_d, alu_src_a, ir_write, 
                       mem_write, pc_write, branch, reg_write, clk, 
                       alu_src_b, pc_src, alu_control, opcode, funct);

    ControlUnit control_unit(opcode, funct, clk, reset, 
                             mem_to_reg, reg_dest, i_or_d, alu_src_a, ir_write, 
                             mem_write, pc_write, branch, reg_write, alu_src_b, 
                             pc_src, alu_control);

endmodule