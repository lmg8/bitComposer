module ledSelect(led1, led2, led3, led4, currentSpeaker, ledOut);
	input [15:0] led1, led2, led2, led3, led4;
	input [3:0] currentSpeaker;
	output reg [15:0] ledOut;
	always @(*) begin
	case (currentSpeaker)
			4'b0001: ledOut = led1;
			4'b0010: ledOut = led2;
			4'b0100: ledOut = led3;
			4'b1000: ledOut = led4;
	endcase
	end
endmodule
