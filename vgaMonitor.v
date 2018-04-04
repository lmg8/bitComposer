module datapath(
    input clk,
    input resetN, enable,
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
	reg [3:0] colCount;
	reg [2:0] c;
	reg [1:0] rowCount, xCount, yCount;
	reg cFill;
	
	wire cOutline;
	wire yEnable, colEnable, rowEnable;
	
	assign cOutline = (colCount == beat) ? 1 : 0;

	always @(*) begin
			case (rowCount)
				2'b00: cFill <= qOut1[colCount];
				2'b01: cFill <= qOut2[colCount];
				2'b10: cFill <= qOut3[colCount];
				2'b11: cFill <= qOut4[colCount];
				default: cFill <= qOut1[colCount];
			endcase
	end
	//START x = 8
	//y = 50;
	
	always @(posedge clk) begin
		x <= xIn + (colCount * 8'd8);
		y <= yIn + (rowCount * 7'd20);
		
		if (xCount == 2'b00 && yCount == 2'b01)
			c <= cFill ? 3'b001 : 3'b111;
		else
			c <= cOutline ? 3'b110 : 3'b000;
	end
	
	assign yEnable = (xCount == 2'b10) ? 1 : 0;
	assign colEnable = (yCount == 2'b10) ? 1 : 0;
	assign rowEnable = (colCount == 4'b1111) ? 1 : 0;
	
	always @(posedge clk) begin
		if (enable) begin
			if (xCount == 2'b10)
				xCount <= 2'b00;
			else	
				xCount <= xCount + 1'b1;
		end
	end
	
	always @(posedge clk) begin
		if (enable && yEnable) begin
			if (yCount == 2'b10)
				yCount <= 2'b00;
			else
				yCount <= yCount + 1'b1;
		end
	end
	
	always @(posedge clk) begin
		if (enable && yEnable && colEnable) begin
			if (colCount == 4'b1111)
				colCount <= 4'b0000;
			else
				colCount <= colCount + 1'b1;
		end
	end
	
	always @(posedge clk) begin
		if (enable && yEnable && colEnable && rowEnable) begin
			if (rowCount == 2'b11)
				rowCount <= 2'b00;
			else
				rowCount <= rowCount + 1'b1;
		end
	end
	
	assign xOut = x + xCount;
	assign yOut = y + yCount;
	assign cOut = c;

                                                                                                                                            
endmodule
