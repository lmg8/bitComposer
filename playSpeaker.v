module playSpeaker(clk, sound, speaker);
	/* REFERNCED CODE */
	input sound, clk;
	output speaker;
	reg [31:0] clkdivider = (50000000/880);


	reg [31:0] counter;
	always @(posedge clk)
		begin
			if(counter==0)
				counter <= clkdivider-1;
			else
				counter <= counter-1;
		end

	reg speaker;
	always @(posedge clk)
		if((counter==0) && sound)
			speaker <= ~speaker;
	/* REFERNCE CODE END */
	
endmodule

