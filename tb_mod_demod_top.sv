module tb_mod_demod_top();

    logic [20:0] sim_mod_in;
    logic [20:0] sim_demod_out;

    mod_demod_top dut(
        .mod_in(sim_mod_in),
        .demod_out(sim_demod_out)
    );

    initial begin
        sim_mod_in = 21'b100110011001100110011;
        #10;

        sim_mod_in = 21'b011001100110011001100;
        #10;

        sim_mod_in = 21'b111111111100000000000;
        #10;

        sim_mod_in = 21'b000000000001111111111;
        #10;
        $stop();
    end


endmodule