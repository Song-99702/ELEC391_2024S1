module data_shifter_left (
    input wire clk,              // Clock signal with frequency 40KHz
    input wire signed  [15:0] data_in,   // 16-bit signed input data
    input enn,
    output reg [23:0] data_out    // 24-bit output data
);

// On every positive edge of the clock, perform an arithmetic left shift by 8 bits
always @(posedge clk) begin
    if(enn) begin
        data_out <= data_in << 8; // Arithmetic left shift by 8 bits
    end
    else data_out <= 0;
end

endmodule

