module mod_demod_top (input logic [20:0] mod_in, output logic [20:0] demod_out);
    
    logic [20:0] mod_input;
    logic [20:0] demod_output;
    logic signed [10:0] real_connect;
    logic signed [10:0] imaginary_connect;

    assign mod_input = mod_in;
    assign demod_out = demod_output;

    qpsk_modulator mod(
        .mod_data_in(mod_input),
        .real_part(real_connect),
        .imaginary(imaginary_connect)
    );

    qpsk_demodulator demod(
        .real_part(real_connect),
        .imaginary(imaginary_connect),
        .demod_data_out(demod_output)
    );

endmodule