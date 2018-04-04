module BitComposer(SW, KEY, CLOCK_50, GPIO, LEDR, LEDG);
	input CLOCK_50;
	input [17:0] SW;
	input [3:0] KEY;
	output [3:0] GPIO;
	output [17:0] LEDR;
	output [7:0] LEDG;
	wire ledG2, new_clk;
	wire [15:0] ledR1 , ledR2, ledR3, ledR4;
	wire [27:0] speed;
	wire [3:0] currentSpeaker;
	
	// calculates how fast clock goes
	clockSpeed chooseSpeed(CLOCK_50, KEY[2], speed, LEDG[7:6]);
	rate_divider rate(CLOCK_50, speed, new_clk);
	//assign LEDR[17] = new_clk;
	
	// choose which speaker to edit (currently two speakers)
	speakerSelect s(SW[17:16], currentSpeaker[3:0]);
	assign LEDR[17:16] = SW[17:16];
	// play speakers
	speakerPlay s1(SW, KEY, currentSpeaker[0], CLOCK_50, new_clk, (50000000/880), GPIO[0], ledR1, LEDG[5:2]); //A
	speakerPlay s2(SW, KEY, currentSpeaker[1], CLOCK_50, new_clk, (50000000/1046), GPIO[1], ledR2, ledG2);	//C
	speakerPlay s3(SW, KEY, currentSpeaker[2], CLOCK_50, new_clk, (50000000/1147), GPIO[2], ledR3, ledG2);	//D
	speakerPlay s4(SW, KEY, currentSpeaker[3], CLOCK_50, new_clk, (50000000/1396), GPIO[3], ledR4, ledG2);	//F
	assign LEDG[1:0] =  ~KEY[1:0];
	ledSelect(ledR1, ledR2, ledR3, ledR4, currentSpeaker, LEDR[15:0]);

endmodule
