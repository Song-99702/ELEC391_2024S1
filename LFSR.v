module LFSR(
input wire clk,
input wire reset,
output reg [7:0] random
);
reg [7:0] lfsr;

always @(posedge clk or posedge reset) begin
if (reset) begin
lfsr <= 8'hAC; // Initialize seed value
random <= 8'hAC; // Initialize output as well
end else begin
lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};
random <= lfsr;
end
end
endmodule
