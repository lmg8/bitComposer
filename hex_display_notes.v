module hex_display_notes (IN, OUT);
    input [3:0] IN;
	 output reg [7:0] OUT;
	 
	 always @(*)
	 begin
		case(IN[3:0])
			4'b0001: OUT = 7'b0001000; // A
			4'b0010: OUT = 7'b1000110; // C
			4'b0100: OUT = 7'b0100001; // D
			4'b1000: OUT = 7'b0001110; // F
			default: OUT = 7'b0111111;
		endcase
	end
endmodule
