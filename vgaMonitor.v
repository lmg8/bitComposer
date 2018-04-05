module datapath(
    input clk,
    input resetN,
	 input [1:0] select,
    input [7:0] xIn,
	 input [6:0] yIn,
	 input [15:0] qOut1, qOut2, qOut3, qOut4,
    input [3:0] beat,
    output [7:0] xOut,
    output [6:0] yOut,
    output [2:0] cOut
    );
	 
	reg [7:0] x;
	reg [6:0] y;
	reg [3:0] colCount, letterCount;
	reg [2:0] c;
	reg [1:0] rowCount, xCount, yCount;
	reg cFill, xEnable;
	
	wire cOutline, enable, yEnable, colEnable, rowEnable;
	wire [3:0] doneLetter;
	
	wire [7:0] letterX;
	wire [6:0] letterY;
	
	drawLetter letter(clk, letterCount, rowCount, 8'd5, (y-7'd1), letterX, letterY);
	
	assign cOutline = (colCount == beat) ? 1 : 0;
	assign enable = ~xEnable;

	always @(*) begin
			case (rowCount)
				2'b00: cFill <= qOut1[colCount];
				2'b01: cFill <= qOut2[colCount];
				2'b10: cFill <= qOut3[colCount];
				2'b11: cFill <= qOut4[colCount];
				default: cFill <= qOut1[colCount];
			endcase
	end
	
	always @(posedge clk) begin
		if (xCount == 0 && yCount == 0 && colCount == 0) begin
			xEnable <= 1'b0;
		end
		
		if (enable) begin
			if (letterCount == 4'b1001) begin
				letterCount = 4'b0000;
				xEnable <= 1'b1;
			end
			else
				letterCount <= letterCount + 1'b1;
		end
	end
	
	always @(*) begin
		x <= xIn + (colCount * 8'd8);
		y <= yIn + (rowCount * 7'd20);
		
		if (xOut <= 8'd	19)
			c <= (rowCount == select) ? 3'b100 : 3'b111;
		else if (xCount == 2'b01 && yCount == 2'b01)
			c <= cFill ? 3'b001 : 3'b111;
		else
			c <= cOutline ? 3'b110 : 3'b000;
	end
	
	assign yEnable = (xCount == 2'b10) ? 1 : 0;
	assign colEnable = (yCount == 2'b10) ? 1 : 0;
	assign rowEnable = (colCount == 4'b1111) ? 1 : 0;
	
	always @(posedge clk) begin
		if (xEnable) begin
			if (xCount == 2'b10)
				xCount <= 2'b00;
			else	
				xCount <= xCount + 1'b1;
		end
	end
	
	always @(posedge clk) begin
		if (xEnable && yEnable) begin
			if (yCount == 2'b10)
				yCount <= 2'b00;
			else
				yCount <= yCount + 1'b1;
		end
	end
	
	always @(posedge clk) begin
		if (xEnable && yEnable && colEnable) begin
			if (colCount == 4'b1111)
				colCount <= 4'b0000;
			else
				colCount <= colCount + 1'b1;
		end
	end
	
	always @(posedge clk) begin
		if (xEnable && yEnable && colEnable && rowEnable) begin
			if (rowCount == 2'b11)
				rowCount <= 2'b00;
			else
				rowCount <= rowCount + 1'b1;
		end
	end
	
	assign xOut = xEnable ? (x + xCount) : letterX;
	assign yOut = xEnable ? (y + yCount) : letterY;
	assign cOut = c;

                                                                                                                                            
endmodule

module drawLetter(
	input clk,
	input [3:0] count,
	input [1:0] select,
	input [7:0] xStart,
	input [6:0] yStart,
	output [7:0] xOut,
	output [6:0] yOut
	);
	
	reg [29:0] letterX;
	reg [29:0] letterY;
	reg [2:0] x, y;
	
	always @(*) begin
		case (select)
			2'b00: begin //A
				letterX <= 30'b001_000_010_000_001_010_000_010_000_010;
				letterY <= 30'b000_001_001_010_010_010_011_011_100_100;
				end
			2'b01: begin //C
				letterX <= 30'b010_011_001_000_001_010_011_011_011_011;
				letterY <= 30'b000_000_001_010_011_100_100_100_100_100;
				end
			2'b10: begin //D
				letterX <= 30'b000_001_000_010_000_011_000_010_000_001;
				letterY <= 30'b000_000_001_001_010_010_011_011_100_100;
				end
			2'b11: begin //F
				letterX <= 30'b000_001_010_011_000_000_001_010_000_000;
				letterY <= 30'b000_000_000_000_001_010_010_010_011_100;
				end
			default: begin //A
				letterX <= 30'b001_000_010_000_001_010_000_001_000_001;
				letterY <= 30'b000_001_001_010_010_010_011_011_100_100;
				end
		endcase
	end
	
	always @(*) begin
		
		case (count)
			4'b0000: begin
				x = letterX[29:27];
				y = letterY[29:27];
			end
			4'b0001: begin
				x = letterX[26:24];
				y = letterY[26:24];
			end
			4'b0010: begin
				x = letterX[23:21];
				y = letterY[23:21];
			end
			4'b0011: begin
				x = letterX[20:18];
				y = letterY[20:18];
			end
			4'b0100: begin
				x = letterX[17:15];
				y = letterY[17:15];
			end
			4'b0101: begin
				x = letterX[14:12];
				y = letterY[14:12];
			end
			4'b0110: begin
				x = letterX[11:9];
				y = letterY[11:9];
			end
			4'b0111: begin
				x = letterX[8:6];
				y = letterY[8:6];
			end
			4'b1000: begin
				x = letterX[5:3];
				y = letterY[5:3];
			end
			4'b1001: begin
				x = letterX[2:0];
				y = letterY[2:0];
			end
			default: begin
				x = letterX[29:27];
				y = letterY[29:27];
			end
		endcase
	end

	assign xOut = xStart + x;
	assign yOut = yStart + y;
endmodule
