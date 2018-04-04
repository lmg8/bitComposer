module BitComposer(SW, KEY, CLOCK_50, GPIO, LEDR, LEDG);
	input CLOCK_50;
	input [17:0] SW;
	input [3:0] KEY;
	output [2:0] GPIO;
	output [17:0] LEDR;
	output [7:0] LEDG;
	wire ledG2, new_clk;
	wire [15:0] ledR1 , ledR2;
	wire [27:0] speed;
	wire [1:0] currentSpeaker;
	
	// calculates how fast clock goes
	clockSpeed chooseSpeed(CLOCK_50, KEY[2], speed, LEDG[7:6]);
	rate_divider rate(CLOCK_50, speed, new_clk);
	//assign LEDR[17] = new_clk;
	
	// choose which speaker to edit (currently two speakers)
	speakerSelect s(SW[17:16], currentSpeaker[1:0]);
	assign LEDR[17:16] = SW[17:16];
	// play speakers
	speakerPlay s1(SW, KEY, currentSpeaker[0], CLOCK_50, new_clk, (50000000/880), GPIO[0], ledR1, LEDG);
	speakerPlay s2(SW, KEY, currentSpeaker[1], CLOCK_50, new_clk, (50000000/1318), GPIO[1], ledR2, ledG2);
	ledSelect(ledR1, ledR2, currentSpeaker, LEDR[15:0]);

endmodule
