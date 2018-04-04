module speakerPlay(switch, key, currentSpeaker, clock, new_clk, note, gpio, ledR, ledG);
	input clock, new_clk;
	input [15:0] switch;
	input [1:0] key; 
	input currentSpeaker;
	input [31:0] note;
	output gpio;
	output [15:0] ledR;
	output [3:0] ledG;
	wire [15:0] enable;
	wire reset, play;
	wire [15:0] qOut;
	wire [3:0] currentBeat;
	
	assign reset = ~key[0];
	assign load = ~key[1] & currentSpeaker;
	
	genvar i;
	generate
		for (i = 0; i < 16; i = i + 1) begin: enabling
			assign enable[i] = switch[i];
		end
	endgenerate
	

	flipflop f0 (clock, enable[0], load, reset, qOut[0]);
	flipflop f1 (clock, enable[1], load, reset, qOut[1]);
	flipflop f2 (clock, enable[2], load, reset, qOut[2]);
	flipflop f3 (clock, enable[3], load, reset, qOut[3]);
	flipflop f4 (clock, enable[4], load, reset, qOut[4]);
	flipflop f5 (clock, enable[5], load, reset, qOut[5]);
	flipflop f6 (clock, enable[6], load, reset, qOut[6]);
	flipflop f7 (clock, enable[7], load, reset, qOut[7]);
	flipflop f8 (clock, enable[8], load, reset, qOut[8]);
	flipflop f9 (clock, enable[9], load, reset, qOut[9]);
	flipflop f10 (clock, enable[10], load, reset, qOut[10]);
	flipflop f11 (clock, enable[11], load, reset, qOut[11]);
	flipflop f12 (clock, enable[12], load, reset, qOut[12]);
	flipflop f13 (clock, enable[13], load, reset, qOut[13]);
	flipflop f14 (clock, enable[14], load, reset, qOut[14]);
	flipflop f15 (clock, enable[15], load, reset, qOut[15]);
	assign ledR = qOut;
	// counts through each beat based on new_clk
	counter c(new_clk, currentBeat);
	assign ledG[3:0] = currentBeat;
	// chooses which beat to play
	beatSelect bs(currentBeat, qOut, play); 
	// output currentBeat to speaker
	playSpeaker p(clock, play, note, gpio);
endmodule
