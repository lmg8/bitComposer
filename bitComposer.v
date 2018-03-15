 module bitComposer(SW, KEY, CLOCK_50, GPIO, LEDR, LEDG);
	input CLOCK_50;
	input [17:0] SW;
	input [3:0] KEY;
	output [7:0] GPIO;
	output [18:0] LEDR;
	output [2:0] LEDG;
	
	wire sound;
	
	shift shiftOne(CLOCK_50, SW[2:0], KEY[0], KEY[1], LEDR[0]);
	play speaker(CLOCK_50, KEY[2], GPIO[0]);
	
endmodule

module noteHandler(clk, pattern, select, load, note1, note2, note3, note4);
	input clk, load;
	input [15:0] pattern;
	input [1:0] select;
	output [15:0] note1, note2, note3, note4;
	
	reg [15:0] pat1, pat2, pat3, pat4;
	
	always @(posedge load)
	begin
	case(select)
		2'b00: pat1 <= pattern;
		2'b01: pat2 <= pattern;
		2'b10: pat3 <= pattern;
		2'b11: pat4 <= pattern;
	endcase
	end
	
	assign note1 = pat1;
	assign note2 = pat2;
	assign note3 = pat3;
	assign note4 = pat4;
	
endmodule
