
module LFSR_tb;

reg clk;
reg reset;
wire [7:0] random;

// Instantiate the LFSR module
LFSR uut (
.clk(clk),
.reset(reset),
.random(random)
);

initial begin
// Initialize clock and reset
clk = 0;
reset = 0;

// Apply reset
#5 reset = 1;
#10 reset = 0;

// Run simulation for some time
#1000 $stop();
end

// Clock generation
always #5 clk = ~clk;

initial begin
// Monitor values
$monitor("Time: %0d, Random: %0h", $time, random);
end

endmodule