module qpsk_demodulator (
    input logic [10:0] real_part,
    input logic [10:0] imaginary,
    output logic [20:0] demod_data_out
    //output logic ready
);  
    logic [10:0] real_buffer;
    logic [10:0] imaginary_buffer;
    logic [21:0] buffer;
    integer i;

    assign real_buffer = real_part;
    assign imaginary_buffer = imaginary;

    assign demod_data_out = buffer[21:1];

    // Internal signals for each symbol
    logic [1:0] symbol [10:0];

    // Demodulate each pair of I and Q components
    always_comb begin

        for (i = 0; i < 11; i = i + 1) begin
            if (real_buffer[i] == 1 && imaginary_buffer[i] == 1) begin
                symbol[i] = 2'b00; 
            end 
            else if (real_buffer[i] == 0 && imaginary_buffer[i] == 1) begin
                symbol[i] = 2'b01; 
            end 
            else if (real_buffer[i] == 1 && imaginary_buffer[i] == 0) begin
                symbol[i] = 2'b10; 
            end 
            else if (real_buffer[i] == 0 && imaginary_buffer[i] == 0) begin
                symbol[i] = 2'b11; 
            end
            else begin
                symbol[i] = 2'b00; 
            end
        end

        // Combine the demodulated symbols into the output data stream
        buffer = {symbol[10], symbol[9], symbol[8], symbol[7], symbol[6], symbol[5], symbol[4], symbol[3], symbol[2], symbol[1], symbol[0]};
    end



endmodule