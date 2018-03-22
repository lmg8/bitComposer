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
