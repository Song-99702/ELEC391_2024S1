module Transceiver_tb;

    reg clk;
    reg reset;
    reg signed [15:0] input_signal;
    wire signed [15:0] transmitter_output;
    wire signed [15:0] receiver_output;

    // Instantiate the Transmitter module
    Transmitter transmitter (
        .clk(clk),
        .reset(reset),
        .input_signal(input_signal),
        .encoded_signal(transmitter_output)
    );

    // Instantiate the Receiver module
    Receiver receiver (
        .clk(clk),
        .reset(reset),
        .input_signal(transmitter_output),
        .decoded_signal(receiver_output)
    );

    initial begin
        // Initialize clock and reset
        clk = 0;
        reset = 0;
        input_signal = 16'd0;

        // Apply reset
        #5 reset = 1;
        #10 reset = 0;

        // Change input signal over time to observe changes in output
        // Generate a sequence of 0s and 1s
        repeat (10) begin
            #200 input_signal = 16'd0;
            #200 input_signal = 16'd1;
        end
        
        // Run simulation for sufficient time to observe output
        #4000 $finish;
    end

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Monitor values
        $monitor("Time: %0d, Input Signal: %0d, Transmitter Output: %0d, Receiver Output: %0d", 
                  $time, input_signal, transmitter_output, receiver_output);
    end

endmodule

