module bitComposer(SW, KEY, CLOCK_50, LEDR);
	input CLOCK_50;
	input [2:0] SW;
	input [3:0] KEY;
	output [0:0] LEDR;
	
	shift shiftOne(CLOCK_50, SW[2:0], KEY[0], KEY[1], LEDR[0]);
endmodule

module play();
	/* REFERNCED CODE */
	
	// Note Table (Hz)
	always@(posedge clk)
	begin
		case (note[2:0])
			3'b001: clkdivider <= 50000000/880; 	// A
			3'b010: clkdivider <= 50000000/986;     // B
			3'b011: clkdivider <= 50000000/1046;    // C
			3'b100: clkdivider <= 50000000/1147;    // D
			3'b101: clkdivider <= 50000000/1318;    // E
			3'b110: clkdivider <= 50000000/1396;    // F
			3'b111: clkdivider <= 50000000/1566;    // G
		endcase
	end


	reg [31:0] counter;
	always @(posedge clk)
		begin
			if(counter==0)
				counter <= clkdivider-1;
			else
				counter <= counter-1;
			freq_out <= clkdivider[18:0];
		end

	reg speaker;
	always @(posedge clk)
		if((counter==0) && note)
			speaker <= ~speaker;
	/* REFERNCE CODE END */
	
endmodule