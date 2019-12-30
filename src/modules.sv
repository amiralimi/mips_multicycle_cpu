module MUX2 #(parameter WIDTH = 8)
             (input logic[WIDTH-1:0] s0, s1, 
              input logic s,
              output logic [WIDTH-1:0] out);
    
    always_comb
        out = s ? s1: s2;

endmodule
