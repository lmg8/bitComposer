module beatSelect(currentBeat, qOut, play);
	input [3:0]currentBeat;
	input [15:0] qOut;
	output reg play;
	always@(*)
	begin
		case (currentBeat)
			4'b0000: begin play = qOut[0];
			end
			4'b0001: begin play = qOut[1];
			end
			4'b0010: begin play = qOut[2];
			end
			4'b0011: begin play = qOut[3];
			end
			4'b0100: begin play = qOut[4];
			end
			4'b0101: begin play = qOut[5];
			end
			4'b0110: begin play = qOut[6];
			end
			4'b0111: begin play = qOut[7];
			end
			4'b1000: begin play = qOut[8];
			end
			4'b1001: begin play = qOut[9];
			end
			4'b1010: begin play = qOut[10];
			end
			4'b1011: begin play = qOut[11];
			end
			4'b1100: begin play = qOut[12];
			end
			4'b1101:	begin play = qOut[13];
			end
			4'b1110: begin play = qOut[14];
			end
			4'b1111: begin play = qOut[15];
			end
		endcase
	end
endmodule
