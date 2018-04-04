// source: https://github.com/ItsMeWithTheFace/DE2Keyboard/blob/master/SingleNotePlayer.v
module playSpeaker(clk, sound, note, speaker);
	/* REFERNCED CODE */
	input sound, clk;
	input [31:0] note;
	output speaker;

	reg [31:0] counter;
	always @(posedge clk)
		begin
			if(counter==0)
				counter <= note-1;
			else
				counter <= counter-1;
		end

	reg speaker;
	always @(posedge clk)
		if((counter==0) && sound)
			speaker <= ~speaker;
	/* REFERNCE CODE END */
	
endmodule

