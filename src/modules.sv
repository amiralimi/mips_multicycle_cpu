module MUX2 #(parameter WIDTH = 8)
             (input logic[WIDTH-1:0] s0, s1, 
              input logic s,
              output logic [WIDTH-1:0] out);
    
    always_comb
        out = s ? s1: s2;

endmodule

module FlipFlop #(parameter WIDTH = 8)
                      (input logic[WIDTH-1:0] d,
                       input logic clk,
                       output logic[WIDTH-1:0] out);
    
    always_ff @(posedge clk)
        out <= d;

endmodule

module FlipFlopEn #(parameter WIDTH = 8)
                      (input logic[WIDTH-1:0] d,
                       input logic clk, en,
                       output logic[WIDTH-1:0] out);
    
    always_ff @(posedge clk)
        if (en) out <= d;

endmodule
