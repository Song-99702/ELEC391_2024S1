module Gilbert_tb;

    reg clk;
    reg reset;
    reg signed [15:0] input_signal;
    wire signed [15:0] output_signal;
    wire [4:0] SNR;
    wire state;
    wire [7:0] rand_num;

    // Instantiate the Gilbert module
    Gilbert uut (
        .clk(clk),
        .reset(reset),
        .input_signal(input_signal),
        .output_signal(output_signal),
        .SNR(SNR),
        .state(state)
    );

    initial begin
        // Initialize clock and reset
        clk = 0;
        reset = 0;
        input_signal = 16'd1000; // Example input signal

        // Apply reset
        #500 reset = 1;
        #1000 reset = 0;

        // Run simulation for sufficient time to observe state transitions and SNR changes
        #100000 $finish;
    end

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Monitor values
        $monitor("Time: %0d, SNR: %0d, State: %0b, Random: %0d", $time, SNR, state, uut.lfsr_inst.random);
    end

endmodule

