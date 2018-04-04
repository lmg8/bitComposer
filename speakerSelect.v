module speakerSelect(select, currentSpeaker);
	input [1:0]select;
	output reg [3:0]currentSpeaker;
	always@(*)
	begin
		case (select)
			4'b00: currentSpeaker = 4'b0001;
			4'b01: currentSpeaker = 4'b0010;
			4'b10: currentSpeaker = 4'b0100;
			4'b11: currentSpeaker = 4'b1000;
		endcase
	end
endmodule
