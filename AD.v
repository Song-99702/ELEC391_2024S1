module AD (CLOCK_50, CLOCK2_50, KEY, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, 
		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);

	input CLOCK_50, CLOCK2_50;
	input [0:0] KEY;
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	
	// Local wires.
	wire CLK12M, CLK1M, CLK06M,CLK1;
	wire read_ready, write_ready, read, write;
   wire [15:0] decoder_out1,decoder_out2;
	wire [23:0] readdata_left, readdata_right;
	wire [23:0] writedata_left, writedata_right;
	wire [15:0] middle_left,middle_right;
	wire [23:0] out_l,out_r;
	wire reset = ~KEY[0];
	wire [20:0] encoder_out1,encoder_out2;
	wire [10:0] mod_out_real1,mod_out_real2,mod_out_imagine1,mod_out_imagine2;
	wire [15:0] trans_real1, trans_real2, trans_ima1, trans_ima2;
	wire [15:0] gilbert_r1,gilbert_r2,gilbert_im1,gilbert_im2;
	wire [15:0] channel_r1,channel_r2,channel_im1,channel_im2;
	wire [4:0] SNR1,SNR2,SNR3,SNR4;
	wire [0:0] state1,state2,state3,state4;
	wire [10:0] rec_real1, rec_real2, rec_ima1, rec_ima2;
	wire [20:0] demod_out1,demod_out2; 
//	wire [23:0] filtered_data1,filtered_data2;
//	/wire [0:0] rdy1,rdy2,rdy3,rdy4;
	/////////////////////////////////
	// Your code goes here 
	/////////////////////////////////
	
	assign writedata_left =out_l;
	assign writedata_right = out_r;
	assign read = read_ready;
	assign write = write_ready;
	
/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		reset,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		reset,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		reset,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);
	
	pll pll_inst1 (
		.refclk   (CLOCK_50),   //  refclk.clk
		.rst      (reset),      //   reset.reset
		.outclk_0 (CLK12M), // outclk0.clk--1.2MHz
		.outclk_1 (CLK1M), // outclk1.clk--1MHz
		.outclk_2 (CLK06M), // outclk2.clk--0.6MHz
		.locked   ()    //  locked.export
	);
	
	clock_divider gen1(
	   .clk_in(CLK06M),
		.reset(reset),
		.clk_out(CLK1)
		);
	
	data_shifter_right sampl(
		.clk(CLK1),
		.data_in(readdata_left),
		.enn(1'b1),
		.data_out(middle_left)
	);
	data_shifter_right sampr(
		.clk(CLK1),
		.data_in(readdata_right),
		.enn(1'b1),
		.data_out(middle_right)
	);

    data_shifter_left samp1(
      .clk(CLK1),
		.data_in(decoder_out1),
		.enn(1'b1),
		.data_out(out_l)
    );

	data_shifter_left samp2(
      .clk(CLK1),
		.data_in(decoder_out2),
		.enn(1'b1),
		.data_out(out_r)
    );
	 
//	FIFO_filter16 filterL(
//	.clk(CLK1),
//	.reset(reset),
//	.data_in(out_l),
//	.data_out(filtered_data1)
//	);
//	
//	FIFO_filter16 filterR(
//	.clk(CLK1),
//	.reset(reset),
//	.data_in(out_r),
//	.data_out(filtered_data2)
//	);
	

   bch_encoder en1(
	  .data_in(middle_left),
	  .data_out(encoder_out1)

   );
   bch_encoder en2(
	  .data_in(middle_right),
	  .data_out(encoder_out2)

   );


   qpsk_modulator mod1(
	.mod_data_in(encoder_out1),
	.real_part(mod_out_real1),
	.imaginary(mod_out_imagine1)
	);
	
	qpsk_modulator mod2(
	.mod_data_in(encoder_out2),
	.real_part(mod_out_real2),
	.imaginary(mod_out_imagine2)
	);
	
	Transmitter trans1(
	.clk(CLOCK_50),
	.reset(reset),
	.input_signal(mod_out_real1),
	.encoded_signal(trans_real1)
	);
	
	Transmitter trans2(
	.clk(CLOCK_50),
	.reset(reset),
	.input_signal(mod_out_real2),
	.encoded_signal(trans_real2)
	);
	
	
	Transmitter trans3(
	.clk(CLOCK_50),
	.reset(reset),
	.input_signal(mod_out_imagine1),
	.encoded_signal(trans_ima1)
	);
	
	Transmitter trans4(
	.clk(CLOCK_50),
	.reset(reset),
	.input_signal(mod_out_imagine2),
	.encoded_signal(trans_ima2)
	);
	
	Gilbert G1(
	.clk(CLK1M),
	.reset(reset),
	.input_signal(trans_real1),
	.output_signal(gilbert_r1),
	.SNR(SNR1),
	.state(state1)
	);
	
	Gilbert G2(
	.clk(CLK1M),
	.reset(reset),
	.input_signal(trans_real2),
	.output_signal(gilbert_r2),
	.SNR(SNR2),
	.state(state2)
	);
	
	Gilbert G3(
	.clk(CLK1M),
	.reset(reset),
	.input_signal(trans_ima1),
	.output_signal(gilbert_im1),
	.SNR(SNR3),
	.state(state3)
	);
	
	Gilbert G4(
	.clk(CLK1M),
	.reset(reset),
	.input_signal(trans_ima2),
	.output_signal(gilbert_im2),
	.SNR(SNR4),
	.state(state4)
	);
	
	AWGN_Channel C1(
	.clk(CLK1M),
	.reset(reset),
	.input_signal(gilbert_r1),
	.SNR(SNR1),
	.state(state1),
	.output_signal(channel_r1)
	);
	
	
	
	AWGN_Channel C2(
	.clk(CLK1M),
	.reset(reset),
	.input_signal(gilbert_r2),
	.SNR(SNR2),
	.state(state2),
	.output_signal(channel_r2)
	);
	
	
	AWGN_Channel C3(
	.clk(CLK1M),
	.reset(reset),
	.input_signal(gilbert_im1),
	.SNR(SNR3),
	.state(state3),
	.output_signal(channel_im1)
	);
	
	
	AWGN_Channel C4(
	.clk(CLK1M),
	.reset(reset),
	.input_signal(gilbert_im2),
	.SNR(SNR4),
	.state(state4),
	.output_signal(channel_im2)
	);
	
	
	Receiver rec1(
	.clk(CLOCK_50),
	.reset(reset),
	.input_signal(channel_r1),
	.decoded_signal(rec_real1)
	);
	
	Receiver rec2(
	.clk(CLOCK_50),
	.reset(reset),
	.input_signal(channel_r2),
	.decoded_signal(rec_real2)
	);
	
	Receiver rec3(
	.clk(CLOCK_50),
	.reset(reset),
	.input_signal(channel_im1),
	.decoded_signal(rec_ima1)
	);
	
	Receiver rec4(
	.clk(CLOCK_50),
	.reset(reset),
	.input_signal(channel_im2),
	.decoded_signal(rec_ima2)
	);
	

	qpsk_demodulator demod1(
	.real_part(rec_real1),
	.imaginary(rec_ima1),
	.demod_data_out(demod_out1)
	);
	
	qpsk_demodulator demod2(
	.real_part(rec_real2),
	.imaginary(rec_ima2),
	.demod_data_out(demod_out2)
	);
	
	bch_decoder de1(
	.de_data_in(demod_out1),
	.de_data_out(decoder_out1)
   );

    bch_decoder de2(
	.de_data_in(demod_out2),
	.de_data_out(decoder_out2)
   );
	

endmodule


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
