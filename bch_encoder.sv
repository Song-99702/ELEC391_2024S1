module bch_encoder (input logic [15:0] data_in, output logic [20:0] data_out);

    //Since BCH code and Hamming code can be used interchangeably, 
    //we implement the (21, 16) BCH encoder using the logic of Hamming encoder.

    logic p1, p2, p3, p4, p5; //5 parity bits

    assign p1 = data_in[0] + data_in[1] + data_in[3] + data_in[4] + data_in[6] + data_in[8] + data_in[10] + data_in[11] + data_in[13] + data_in[15];
    assign p2 = data_in[0] + data_in[2] + data_in[3] + data_in[5] + data_in[6] + data_in[9] + data_in[10] + data_in[12] + data_in[13];
    assign p3 = data_in[1] + data_in[2] + data_in[3] + data_in[7] + data_in[8] + data_in[9] + data_in[10] +data_in[14] + data_in[15];
    assign p4 = data_in[4] + data_in[5] + data_in[6] + data_in[7] + data_in[8] + data_in[9] + data_in[10];
    assign p5 = data_in[11] + data_in[12] + data_in[13] + data_in[14] + data_in[15];

    assign data_out = {data_in[15:11], p5, data_in[10:4], p4, data_in[3:1], p3, data_in[0], p2, p1};

endmodule