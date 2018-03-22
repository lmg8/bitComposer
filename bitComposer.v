module BitComposer(SW, KEY, CLOCK_50, GPIO,LEDR, LEDG);
	input CLOCK_50;
	input [15:0] SW;
	input [3:0] KEY;
	output [1:0] GPIO;
	output [17:0] LEDR;
	output [3:0] LEDG;
	wire [15:0] enable;
	wire reset;
	wire [15:0] qOut;
	wire counterEn = 1'b1;
	wire new_clk, play;
	wire [3:0] currentBeat;
	
	//assign reset = 1'b0;
	//assign load = KEY[1];
	
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

	clock_divider cd(CLOCK_50, new_clk);
	assign LEDR[17] = new_clk;
	counter c(new_clk, reset, currentBeat);
	assign LEDG[0] = currentBeat[0];
	assign LEDG[1] = currentBeat[1];
	assign LEDG[2] = currentBeat[2];
	assign LEDG[3] = currentBeat[3];
	beatSelect bs(currentBeat, qOut, play, LEDR[15:0]); 

	SingleNotePlayer p(CLOCK_50, GPIO[0], sound);
	
endmodule

module beatSelect(currentBeat, qOut, play, led);
	input [3:0]currentBeat;
	input [15:0] qOut;
	output reg play;
	output reg [15:0] led;
	always@(*)
	begin
		case (currentBeat)
			4'b0000: begin play = qOut[0];
			led[0] = play;
			end
			4'b0001: begin play = qOut[1];
			led[1] = play;
			end
			4'b0010: begin play = qOut[2];
			led[2] = play;
			end
			4'b0011: begin play = qOut[3];
			led[3] = play;
			end
			4'b0100: begin play = qOut[4];
			led[4] = play;
			end
			4'b0101: begin play = qOut[5];
			led[5] = play;
			end
			4'b0110: begin play = qOut[6];
			led[6] = play;
			end
			4'b0111: begin play = qOut[7];
			led[7] = play;
			end
			4'b1000: begin play = qOut[8];
			led[8] = play;
			end
			4'b1001: begin play = qOut[9];
			led[9] = play;
			end
			4'b1010: begin play = qOut[10];
			led[10] = play;
			end
			4'b1011: begin play = qOut[11];
			led[11] = play;
			end
			4'b1100: begin play = qOut[12];
			led[12] = play;
			end
			4'b1101:	begin play = qOut[13];
			led[13] = play;
			end
			4'b1110: begin play = qOut[14];
			led[14] = play;
			end
			4'b1111: begin play = qOut[15];
			led[15] = play;
			end
		endcase
	end
endmodule

module flipflop(clock, d, reset_n, q);
	input clock; 
	input d;
	input reset_n;
	output reg q;

	always @(posedge clock)
	begin
		if (reset_n == 1'b1)
			q <= 0;
		else
			q <= d;
	end
endmodule

module clock_divider(clk, new_clk);
	input clk;
	output new_clk;
	reg tmp_clk = 1'b0;
	reg [27:0] count = 28'd19999999;
	
	always @(posedge clk)
		begin
			if (count == 28'd0) begin
				tmp_clk <= ~tmp_clk;
				count <= 28'd19999999;
				end
			else 
				count <= count - 1'b1;
		end
	assign new_clk = tmp_clk;
endmodule

module counter(clock, clear_b, q);
	input clock;
	input clear_b;
	output reg [3:0] q;

	always @(posedge clock)
	begin 
		if(clear_b == 1'b1)
			q <= 4'b0000;
		else
			q <= q + 1'b1;
	end
endmodule

module SingleNotePlayer(clk, speaker, sound);
    input clk, sound;
	 output speaker;
    reg [31:0] clkdivider = 50000000/880; 


    reg [31:0] counter;
    always @(posedge clk) if(counter==0) counter <= clkdivider-1; else counter <= counter-1;

    reg speaker;
    always @(posedge clk) if((counter==0) && sound) speaker <= ~speaker;
endmodule
