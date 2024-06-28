module bch_decoder (input logic clk, input logic [20:0] de_data_in, output logic [15:0] de_data_out);

    logic s1, s2, s3, s4, s5;
    logic [20:0] corrected_code;
    logic [4:0] i;

    assign i = {s5, s4, s3, s2, s1};

    //Calculate syndrome bits
    assign s5 = de_data_in[20]+de_data_in[19]+de_data_in[18]+de_data_in[17]+de_data_in[16]+de_data_in[15];
    assign s4 = de_data_in[14]+de_data_in[13]+de_data_in[12]+de_data_in[11]+de_data_in[10]+de_data_in[9]+de_data_in[8]+de_data_in[7];
    assign s3 = de_data_in[20]+de_data_in[19]+de_data_in[14]+de_data_in[13]+de_data_in[12]+de_data_in[11]+de_data_in[6]+de_data_in[5]+de_data_in[4]+de_data_in[3];
    assign s2 = de_data_in[18]+de_data_in[17]+de_data_in[14]+de_data_in[13]+de_data_in[10]+de_data_in[9]+de_data_in[6]+de_data_in[5]+de_data_in[2]+de_data_in[1];
    assign s1 = de_data_in[20]+de_data_in[18]+de_data_in[16]+de_data_in[14]+de_data_in[12]+de_data_in[10]+de_data_in[8]+de_data_in[6]+de_data_in[4]+de_data_in[2]+de_data_in[0];

    always_comb begin

        //Error detection and correction
        corrected_code = de_data_in;

        if (i != 5'b0) begin
            corrected_code[i-1] = ~corrected_code[i-1];
            de_data_out = {corrected_code[20:16],corrected_code[14:8],corrected_code[6:4],corrected_code[2]};
        end
        else
            de_data_out = {corrected_code[20:16],corrected_code[14:8],corrected_code[6:4],corrected_code[2]};
        
    end

endmodule