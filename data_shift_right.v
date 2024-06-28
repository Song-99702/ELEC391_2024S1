module data_shifter_right (
    input wire clk,              // Clock signal with frequency 40KHz
    input wire signed [23:0] data_in,   // 24-bit signed input data
    input enn,
    output reg [15:0] data_out    // 16-bit output data
);

// On every positive edge of the clock, perform an arithmetic right shift by 8 bits
always @(posedge clk) begin
    if(enn) begin
        data_out <= data_in >> 8; // Arithmetic right shift by 8 bits
    end
    else data_out <= 0;
   
end

endmodule
