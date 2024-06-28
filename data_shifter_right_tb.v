`timescale 1ns/1ps

module testbench_data_shifter_right();

    // Clock and input signals
    reg clk;
    reg signed [23:0] data_in;
    reg enn;
    wire [15:0] data_out;

    // Instantiate the data_shifter_right module
    data_shifter_right uut (
        .clk(clk),
        .data_in(data_in),
        .enn(enn),
        .data_out(data_out)
    );

    // Clock generation (50 MHz)
    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk; // 50 MHz clock (period = 20 ns, half-period = 10 ns)
    end

    // Test stimulus
    initial begin
        // Initialize signals
        enn = 1'b0;
        data_in = 24'sd0;

        // Apply test data
        @(posedge clk); // Wait for a clock edge
        data_in = 24'sd123456;
        enn = 1'b1;
        
        @(posedge clk); // Wait for a clock edge
        if (data_out !== (data_in >> 8)) begin
            $display("ERROR at time %t: data_out = %h, expected = %h", $time, data_out, data_in >> 8);
        end else begin
            $display("PASS at time %t: data_out = %h", $time, data_out);
        end

        // Test with another value
        @(posedge clk); // Wait for a clock edge
        data_in = -24'sd654321;
        
        @(posedge clk); // Wait for a clock edge
        if (data_out !== (data_in >> 8)) begin
            $display("ERROR at time %t: data_out = %h, expected = %h", $time, data_out, data_in >> 8);
        end else begin
            $display("PASS at time %t: data_out = %h", $time, data_out);
        end

        // Disable enable signal
        @(posedge clk); // Wait for a clock edge
        enn = 1'b0;
        
        @(posedge clk); // Wait for a clock edge
        if (data_out !== 16'b0) begin
            $display("ERROR at time %t: data_out = %h, expected = %h", $time, data_out, 16'b0);
        end else begin
            $display("PASS at time %t: data_out = %h", $time, data_out);
        end

        // End the simulation
        $stop;
    end

endmodule

