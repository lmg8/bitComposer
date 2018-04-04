module ledSelect(led1, led2, currentSpeaker, ledOut);
	input [15:0] led1, led2;
	input [1:0]currentSpeaker;
	output reg [15:0] ledOut;
	always @(*) begin
	case (currentSpeaker)
			2'b01: begin ledOut = led1;
			end
			2'b10: begin ledOut = led2;
			end
	endcase
	end
endmodule
