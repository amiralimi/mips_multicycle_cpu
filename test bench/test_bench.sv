module TestBench();
    
    logic clk;

    initial begin
        clk <= 1;
        #5;
        clk <= 0;
        #5;
    end

endmodule