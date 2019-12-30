module StateMachine(input logic clk, reset,
                    input logic[5:0] opcode,
                    output logic mem_to_reg, reg_dest, i_or_d, alu_src_a, ir_write, mem_write, pc_write, branch, reg_write,
                    output logic[1:0] alu_src_b, pc_src, alu_op);
    
    parameter LW = 100011;
    parameter SW = 6'b101011;
    parameter RTYPE = 6'b000000;
    parameter BEQ = 6'b000100;
    parameter ADDI = 6'b001000;
    parameter J = 6'b000010;

    typedef enum logic [3:0] {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11} statetype;
	statetype state, nextstate;

	always_ff @(posedge clk, posedge reset)
		if (reset)
			state <= s0;
		else
			state <= nextstate;

	always_comb
		case (state)
			s0:
                nextstate = s1;
            s1:
                if (opcode == LW || opcode == SW)
                    nextstate = s2;
                else if (opcode == RTYPE)
                    nextstate = s6;
                else if (opcode == BEQ)
                    nextstate = s8;
                else if (opcode == ADDI)
                    nextstate = s9;
                else if (opcode == J)
                    nextstate = s11;
            s2:
                if (opcode == LW)
                    nextstate = s3;
                else
                    nextstate = s5;
            s3:
                nextstate = s4;
            s4:
                nextstate = s0;
            s5:
                nextstate = s0;
            s6:
                nextstate = s7;
            s7:
                nextstate = s0;
            s8:
                nextstate = s0;
            s9:
                nextstate = s10;
            s10:
                nextstate = s0;
            s11:
                nextstate = s0;
            default: 
                nextstate = s0;
        endcase

    
    assign mem_to_reg = (state == s7 || state == s10) ? 0 : ((state == s4) ? 1 : 1'bX);
    assign reg_dest = (state == s4 || state == s10) ? 0 : ((state == s7) ? 1 : 1'bX);
    assign i_or_d = (state == s3 || state == s5) ? 1 : ((state == s0) ? 0 : 1'bX);
    assign pc_src = (state == s0) ? 2'b00 : ((state == s8) ? 2'b01 : ((state == s11) ? 2'b10 : 2'bXX));
    assign alu_src_a = (state == s2 || state == s6 || state == s8 || state == s9) ? 1 : ((state == s0 || state == s1) ? 0 : 1'bX);
    assign alu_src_b = (state == s2 || state == s9) ? 2'b10 : ((state == s6 || state == s8) ? 2'b00 : ((state == s1) ? 2'b11 : ((state == s0) ? 2'b01 : 2'bXX)));
    assign ir_write = (state == s0) ? 1 : 0;
    assign mem_write = (state == s5) ? 1 : 0;
    assign pc_write = (state == s0) ? 1 : 0;
    assign branch = (state == s8) ? 1 : 1'bX;
    assign reg_write = (state == s4 || state == s7 || state == s10) ? 1 : 0;
    assign alu_op = (state == s0 || state == s1 || state == s2 || state == s9) ? 2'b00 : ((state == s6) ? 2'b10 : ((state == s8) ? 2'b01 : 2'bXX));

endmodule

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

module ControlUnit(input logic[5:0] opcode, funct, 
                   output logic mem_to_reg, reg_dest, i_or_d, alu_src_a, ir_write, mem_write, pc_write, branch, reg_write,
                   output logic[1:0] alu_src_b, pc_src,
                   output logic[2:0] alu_control);
    logic [1:0] alu_op; 
    StateMachine sm(clk, reset, opcode, mem_to_reg, reg_dest, i_or_d, alu_src_a, ir_write, mem_write, pc_write, branch, reg_write, alu_src_b, pc_src, alu_op);
    ALUDecoder ad(funct, alu_op, alu_control);
endmodule
