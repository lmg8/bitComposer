module BitComposer(SW, KEY, CLOCK_50, HEX7, GPIO, LEDR, LEDG, VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_R, VGA_G, VGA_B);
	input CLOCK_50;
	input [17:0] SW;
	input [3:0] KEY;
	
	output [6:0] HEX7;
	output [3:0] GPIO;
	output [17:0] LEDR;
	output [7:0] LEDG;
	
	//VGA output
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire [5:0] ledG2, ledG3, ledG4;
	wire new_clk;
	wire [15:0] ledR1 , ledR2, ledR3, ledR4;
	wire [27:0] speed;
	wire [3:0] currentSpeaker;
	
	// calculates how fast clock goes
	clockSpeed chooseSpeed(CLOCK_50, KEY[2], speed, LEDG[7:6]);
	rate_divider rate(CLOCK_50, speed, new_clk);
	//assign LEDR[17] = new_clk;
	
	// choose which speaker to edit (currently two speakers)
	speakerSelect s(SW[17:16], currentSpeaker[3:0]);
	assign LEDR[17:16] = SW[17:16]; // speaker selection
	hex_display_notes hex7 (currentSpeaker, HEX7[6:0]); // display current note 
	// play speakers
	speakerPlay s1(SW, KEY, currentSpeaker[0], CLOCK_50, new_clk, (50000000/880), GPIO[0], ledR1, LEDG[5:2]); //A
	speakerPlay s2(SW, KEY, currentSpeaker[1], CLOCK_50, new_clk, (50000000/1046), GPIO[1], ledR2, ledG2);	//C
	speakerPlay s3(SW, KEY, currentSpeaker[2], CLOCK_50, new_clk, (50000000/1147), GPIO[2], ledR3, ledG3);	//D
	speakerPlay s4(SW, KEY, currentSpeaker[3], CLOCK_50, new_clk, (50000000/1396), GPIO[3], ledR4, ledG4);	//F
	assign LEDG[0] =  ~KEY[0]; // reset
	assign LEDG[1] = ~KEY[1]; // load
	ledSelect(ledR1, ledR2, ledR3, ledR4, currentSpeaker, LEDR[15:0]);
	
	//VGA
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(1'b1),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
	
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire resetn;
	assign resetn = KEY[3];
	
	datapath d0(
		.clk(CLOCK_50),
		.resetN(resetn),
		.select(SW[17:16]),
		.xIn(8'd20),
		.yIn(7'd30),
		.qOut1(ledR1),
		.qOut2(ledR2),
		.qOut3(ledR3),
		.qOut4(ledR4),
		.beat(ledG2[3:0]),
		.xOut(x),
		.yOut(y),
		.cOut(colour)
	 );	

endmodule
