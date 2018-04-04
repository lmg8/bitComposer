module speakerSelect(select, currentSpeaker);
	input [1:0]select;
	output reg [1:0]currentSpeaker;
	always@(*)
	begin
		case (select)
			4'b00: begin currentSpeaker[0] = 1'b1;
			currentSpeaker[1] = 1'b0;
			end
			4'b01: begin currentSpeaker[1] = 1'b1;
			currentSpeaker[0] = 1'b0;
			end
		endcase
	end
endmodule
