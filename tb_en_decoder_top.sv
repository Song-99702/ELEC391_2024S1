module tb_en_decoder_top ();

    logic [15:0] sim_d_in;
    logic [15:0] sim_d_out;

    en_decoder_top dut (
        .d_in(sim_d_in),
        .d_out(sim_d_out)
    );

    initial begin

        sim_d_in = 16'b0000000000000000; 
        #10;
        $display("Input: %b, Encoded Output: %b", sim_d_in, sim_d_out);

        sim_d_in = 16'b0000000000000001; 
        #10;
        $display("Input: %b, Encoded Output: %b", sim_d_in, sim_d_out);

        sim_d_in = 16'b0000000000000010; 
        #10;
        $display("Input: %b, Encoded Output: %b", sim_d_in, sim_d_out);

        sim_d_in = 16'b0000000000000011; 
        #10;
        $display("Input: %b, Encoded Output: %b", sim_d_in, sim_d_out);

        sim_d_in = 16'b0000000000000100; 
        #10;
        $display("Input: %b, Encoded Output: %b", sim_d_in, sim_d_out);

        sim_d_in = 16'b0000000000000101; 
        #10;
        $display("Input: %b, Encoded Output: %b", sim_d_in, sim_d_out);

        sim_d_in = 16'b0000000000000110; 
        #10;
        $display("Input: %b, Encoded Output: %b", sim_d_in, sim_d_out);

        sim_d_in = 16'b0000000000000111; 
        #10;
        $display("Input: %b, Encoded Output: %b", sim_d_in, sim_d_out);

        sim_d_in = 16'b0000000000001000; 
        #10;
        $display("Input: %b, Encoded Output: %b", sim_d_in, sim_d_out);

        sim_d_in = 16'b0000000000001001; 
        #10;
        $display("Input: %b, Encoded Output: %b", sim_d_in, sim_d_out);

        sim_d_in = 16'b0000000000001010; 
        #10;
        $display("Input: %b, Encoded Output: %b", sim_d_in, sim_d_out);

        sim_d_in = 16'b0000000000001011; 
        #10;
        $display("Input: %b, Encoded Output: %b", sim_d_in, sim_d_out);

        sim_d_in = 16'b0000000000001100; 
        #10;
        $display("Input: %b, Encoded Output: %b", sim_d_in, sim_d_out);

        sim_d_in = 16'b0000000000001101; 
        #10;
        $display("Input: %b, Encoded Output: %b", sim_d_in, sim_d_out);

        sim_d_in = 16'b0000000000001110; 
        #10;
        $display("Input: %b, Encoded Output: %b", sim_d_in, sim_d_out);

        sim_d_in = 16'b0000000000001111; 
        #10;
        $display("Input: %b, Encoded Output: %b", sim_d_in, sim_d_out);

        $stop();       
    end

endmodule