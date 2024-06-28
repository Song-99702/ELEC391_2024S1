`timescale 1ns/1ps

module testbench_data_shifter_left();

    // Clock and input signals
    reg clk;
    reg signed [15:0] data_in;
    reg enn;
    wire [23:0] data_out;

    // Instantiate the data_shifter_left module
    data_shifter_left uut (
        .clk(clk),
        .data_in(data_in),
        .enn(enn),
        .data_out(data_out)
    );

    // Clock generation (40 kHz)
    initial begin
        clk = 1'b0;
        forever #12.5 clk = ~clk; // 40 kHz clock
    end

    // Test stimulus
    initial begin
        // Initialize signals
        enn = 1'b0;
        data_in = 16'sd0;

        // Apply test data
        @(posedge clk); // Wait for a clock edge
        data_in = 16'sd1234;
        enn = 1'b1;
        
        @(posedge clk); // Wait for a clock edge
        if (data_out !== (data_in << 8)) begin
            $display("ERROR at time %t: data_out = %h, expected = %h", $time, data_out, data_in << 8);
        end else begin
            $display("PASS at time %t: data_out = %h", $time, data_out);
        end

        // Test with another value
        @(posedge clk); // Wait for a clock edge
        data_in = -16'sd5678;
        
        @(posedge clk); // Wait for a clock edge
        if (data_out !== (data_in << 8)) begin
            $display("ERROR at time %t: data_out = %h, expected = %h", $time, data_out, data_in << 8);
        end else begin
            $display("PASS at time %t: data_out = %h", $time, data_out);
        end

        // Disable enable signal
        @(posedge clk); // Wait for a clock edge
        enn = 1'b0;
        
        @(posedge clk); // Wait for a clock edge
        if (data_out !== 24'b0) begin
            $display("ERROR at time %t: data_out = %h, expected = %h", $time, data_out, 24'b0);
        end else begin
            $display("PASS at time %t: data_out = %h", $time, data_out);
        end

        // End the simulation
        $stop;
    end

endmodule

