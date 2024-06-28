module qpsk_modulator (
    input logic [20:0] mod_data_in,
    //input logic enable,
    output logic [10:0] real_part,
    output logic [10:0] imaginary
    //output logic ready
);
    logic R_signal [3:0];
    logic I_signal [3:0];
    logic [21:0] buffer;

    assign buffer = {mod_data_in, 1'b0};

    // 1 indicates positive, 0 indicates negative
    assign R_signal[0] = 1;  // Symbol 00 -> R = +1/sqrt(2)
    assign I_signal[0] = 1;  // Symbol 00 -> I = +1/sqrt(2)

    assign R_signal[1] = 0;  // Symbol 01 -> R = -1/sqrt(2)
    assign I_signal[1] = 1;  // Symbol 01 -> I = +1/sqrt(2)

    assign R_signal[2] = 1; // Symbol 10 -> R = 1/sqrt(2)
    assign I_signal[2] = 0; // Symbol 10 -> I = -1/sqrt(2)

    assign R_signal[3] = 0;  // Symbol 11 -> R = -1/sqrt(2)
    assign I_signal[3] = 0; // Symbol 11 -> I = -1/sqrt(2)

    // Determine I and Q outputs based on input data
    assign real_part = { R_signal[buffer[21:20]], 
                     R_signal[buffer[19:18]], 
                     R_signal[buffer[17:16]], 
                     R_signal[buffer[15:14]], 
                     R_signal[buffer[13:12]], 
                     R_signal[buffer[11:10]], 
                     R_signal[buffer[9:8]], 
                     R_signal[buffer[7:6]], 
                     R_signal[buffer[5:4]], 
                     R_signal[buffer[3:2]], 
                     R_signal[buffer[1:0]] };

    assign imaginary = { I_signal[buffer[21:20]], 
                     I_signal[buffer[19:18]], 
                     I_signal[buffer[17:16]], 
                     I_signal[buffer[15:14]], 
                     I_signal[buffer[13:12]], 
                     I_signal[buffer[11:10]], 
                     I_signal[buffer[9:8]], 
                     I_signal[buffer[7:6]], 
                     I_signal[buffer[5:4]], 
                     I_signal[buffer[3:2]], 
                     I_signal[buffer[1:0]] };



endmodule