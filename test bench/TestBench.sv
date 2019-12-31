module TestBench();
    
    logic clk, reset;

    CPU cpu(clk, reset);

    initial begin
        reset = 1'b1;
        clk = 1'b0;
        #15;
        reset = 1'b0;
    end

    always begin
        clk <= 1;
        #5;
        clk <= 0;
        #5;
    end

endmodule