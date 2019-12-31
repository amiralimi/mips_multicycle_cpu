module DataPath(input logic mem_to_reg, reg_dest, i_or_d, alu_src_a, ir_write, mem_write, pc_write, branch, reg_write, clk, 
                input logic[1:0] alu_src_b, pc_src,
                input logic[2:0] alu_control,
                output logic[5:0] opcode, funct);

    logic[31:0] pc_out, pc_in, mem_adr, mem_data, instr,  register_mux_input,  register_data_input, 
                register_data1, register_data2, a, b, src_a, src_b, FOUR = 4, imm_exit, imm_exit_shift,
                alu_result, alu_out, ZERO = 0;
    logic[1:0] TWO_BIT_ZERO = 2'b00;
    logic[4:0] register_file_a3_input;
    logic zero, pc_en;

    initial begin
        pc_out = 0;
    end

    assign opcode = instr[31:26];
    assign funct = instr[5:0];

    FlipFlopEn #(32)pc_flop(pc_in, clk, pc_en, pc_out);
    MUX2 #(32)pc_mux(pc_out, alu_out, i_or_d, mem_adr);
    Memory memory(clk, mem_write, mem_adr, b, mem_data);
    FlipFlopEn #(32) mem_data_flop1(mem_data, clk, ir_write, instr);
    FlipFlop #(32) mem_data_flop2(mem_data, clk,  register_mux_input);
    MUX2 #(5) register_file_a3_mux(instr[20:16], instr[15:11], reg_dest, register_file_a3_input);
    MUX2 #(32)  register_w3_input_mux(alu_out,  register_mux_input, mem_to_reg,  register_data_input);
    RegisterFile rf(instr[25:21], instr[20:16], register_file_a3_input, register_data_input, reg_write, clk,register_data1, register_data2);
    FlipFlop #(32) register_output_flop1(register_data1, clk, a);
    FlipFlop #(32) register_output_flop2(register_data2, clk, b);
    MUX2 #(32) alu_src_a_flop(pc_out, a, alu_src_a, src_a);
    MUX4 #(32) alu_src_b_flop(b, FOUR, imm_exit, imm_exit_shift, alu_src_b, src_b);
    SignExtend sign_extend(instr[15:0], imm_exit);
    Shift sign_extend_shift(imm_exit, imm_exit_shift);
    ALU alu(alu_control, src_a, src_b, alu_result, zero);
    FlipFlop #(32) alu_flop(alu_result, clk, alu_out);
    
    logic[31:0] pc_jump;
	 assign pc_jump = {pc_out[31:28], instr[25:0], TWO_BIT_ZERO};
    
    MUX4 #(32)pc_input_mux(alu_result, alu_out, pc_jump, ZERO, pc_src, pc_in);

    assign pc_en = (zero && branch) || pc_write;

endmodule
