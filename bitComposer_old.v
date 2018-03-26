module BitComposer(SW, KEY, CLOCK_50, GPIO,LEDR, LEDG);
	input CLOCK_50;
	input [15:0] SW;
	input [3:0] KEY;
	output [1:0] GPIO;
	output [17:0] LEDR;
	output [5:0] LEDG;
	wire [15:0] enable;
	wire reset;
	wire [15:0] qOut;
	wire counterEn = 1'b1;
	wire new_clk, play;
	wire [3:0] currentBeat;
	
	assign reset = KEY[0];
	assign load = KEY[1];
	assign LEDG[0] = reset;
	assign LEDG[1] = load
	genvar i;

	generate
		for (i = 0; i < 16; i = i + 1) begin: enabling
			assign enable[i] = SW[i];
		end
	endgenerate
	

	flipflop f0 (CLOCK_50, enable[0], reset, qOut[0]);
	flipflop f1 (CLOCK_50, enable[1], reset, qOut[1]);
	flipflop f2 (CLOCK_50, enable[2], reset, qOut[2]);
	flipflop f3 (CLOCK_50, enable[3], reset, qOut[3]);
	flipflop f4 (CLOCK_50, enable[4], reset, qOut[4]);
	flipflop f5 (CLOCK_50, enable[5], reset, qOut[5]);
	flipflop f6 (CLOCK_50, enable[6], reset, qOut[6]);
	flipflop f7 (CLOCK_50, enable[7], reset, qOut[7]);
	flipflop f8 (CLOCK_50, enable[8], reset, qOut[8]);
	flipflop f9 (CLOCK_50, enable[9], reset, qOut[9]);
	flipflop f10 (CLOCK_50, enable[10], reset, qOut[10]);
	flipflop f11 (CLOCK_50, enable[11], reset, qOut[11]);
	flipflop f12 (CLOCK_50, enable[12], reset, qOut[12]);
	flipflop f13 (CLOCK_50, enable[13], reset, qOut[13]);
	flipflop f14 (CLOCK_50, enable[14], reset, qOut[14]);
	flipflop f15 (CLOCK_50, enable[15], reset, qOut[15]);

	// calculates how fast clock goes
	rate_divider cd(CLOCK_50, new_clk);
	assign LEDR[17] = new_clk;
	// counts through each beat based on new_clk
	counter c(new_clk, reset, currentBeat);
	assign LEDG[5:2] = currentBeat;
	// chooses which beat to play
	beatSelect bs(currentBeat, qOut, play, LEDR[15:0]); 
	// output currentBeat to speaker
	playSpeaker p(CLOCK_50, GPIO[0], play);
endmodule
