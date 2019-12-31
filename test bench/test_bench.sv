module TestBench();
    
    logic clk;

    CPU cpu(clk);

    always begin
        clk <= 1;
        #5;
        clk <= 0;
        #5;
    end

endmodule