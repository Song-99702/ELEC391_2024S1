module en_decoder_top (input logic [15:0] d_in, output logic [15:0] d_out);

    logic [20:0] encoded_data;
    logic [15:0] decoded_data;


    bch_encoder encode(.data_in(d_in), .data_out(encoded_data));

    bch_decoder decode(.de_data_in(encoded_data), .de_data_out(decoded_data));

    assign d_out = decoded_data;

endmodule