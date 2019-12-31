module MUX2 #(parameter WIDTH = 8)
             (input logic[WIDTH - 1:0] s0, s1, 
              input logic s,
              output logic [WIDTH - 1:0] out);
    
    always_comb
        out = s ? s1: s0;

endmodule

module FlipFlop #(parameter WIDTH = 8)
                 (input logic[WIDTH - 1:0] d,
                  input logic clk,
                  output logic[WIDTH - 1:0] out);
    
    always_ff @(posedge clk)
        out <= d;

endmodule

module FlipFlopEn #(parameter WIDTH = 8)
                   (input logic[WIDTH - 1:0] d,
                    input logic clk, en,
                    output logic[WIDTH - 1:0] out);
    
    always_ff @(posedge clk)
        if (en) out <= d;

endmodule

module MUX4 #(WIDTH = 8)
             (input logic [WIDTH - 1:0] s0, s1, s2, s3,
              input logic [1:0] s, 
              output logic [WIDTH - 1:0] out);
    
    logic [WIDTH - 1:0] out1, out2, out3;
    MUX2 m1(s0, s1, s[0], out1);
    MUX2 m2(s2, s3, s[0], out2);
    MUX2 m3(out1, out2, s[1], out);

endmodule

module ALU(input logic[2:0] alu_control,
           input logic[31:0] src_a, src_b,
           output logic[31:0] alu_result, 
           output logic zero);

    always_comb
		casex (alu_control[2:0])
			2'b000: alu_result = src_a & src_b;
			2'b001: alu_result = src_a | src_b;
            2'b010: alu_result = src_a + src_b;
            2'b110: alu_result = src_a - src_b;
            2'b111: alu_result = src_a < src_b;
		endcase

    assign zero = (alu_result == 32'b0);

endmodule

module Memory #(parameter WIDTH = 32, SIZE=1024)
               (input logic clk, write_enable, 
                input logic [WIDTH - 1:0] a, write_data,
                output logic[WIDTH - 1:0] read_data);
    
    initial
      $readmemh("memfile.dat", mem);
    
    logic [WIDTH - 1:0] mem[SIZE - 1:0];
    
    assign read_data = mem[a[WIDTH - 1:2]];

    always_ff @(posedge clk)
        if (write_enable) mem[a[WIDTH - 1:2]] <= write_data;

endmodule

module RegisterFile #(ADDRESS_SIZE = 5, WIDTH = 32, SIZE = 32)
                     (input logic [ADDRESS_SIZE - 1:0] a1, a2, a3,
                      input logic [WIDTH - 1:0] write_data,
                      input logic write_enable, clk,
                      output logic [WIDTH - 1: 0] read_data1, read_data2);

    logic [WIDTH - 1:0] rf[SIZE - 1:0];

    assign read_data1 = rf[a1[WIDTH - 1:2]];
    assign read_data2 = rf[a2[WIDTH - 1:2]];

    always_ff @(posedge clk)
        if (write_enable) rf[a3[WIDTH - 1:2]] <= write_data;

endmodule

module SignExtend (input logic[15:0] in, 
                   output logic[31:0] out);

    assign out = { { 16{in[15]}}, in[15:0]};

endmodule

module Shift #(WIDTH=32) 
              (input logic[WIDTH - 1:0] in,
              output logic[WIDTH - 1:0] out);

    assign out = in << 2;

endmodule
