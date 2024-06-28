module AWGN_Channel_tb;

reg clk;
reg reset;
reg signed [15:0] input_signal;
reg [4:0] SNR;
reg state;
wire signed [15:0] output_signal;

// Instantiate the AWGN_Channel module
AWGN_Channel uut (
.clk(clk),
.reset(reset),
.input_signal(input_signal),
.SNR(SNR),
.state(state),
.output_signal(output_signal)
);

initial begin
// Initialize clock and reset
clk = 0;
reset = 0;
input_signal = 16'd1000; // Example input signal
SNR = 5'd9; // Example SNR
state = 1; // Bad state to add noise

// Apply reset
#5 reset = 1;
#10 reset = 0;

// Change input signal over time
#20 input_signal = 16'd2000;
#40 input_signal = 16'd3000;
#60 input_signal = 16'd4000;

// Run simulation for some time
#1000 $finish;
end

// Clock generation
always #5 clk = ~clk;

initial begin
// Monitor values
$monitor("Time: %0d, Input: %0d, Output: %0d", $time, input_signal, output_signal);
end

endmodule
