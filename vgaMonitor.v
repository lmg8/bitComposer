module datapath(
    input clk,
    input resetN, enable,
    input [7:0] xIn,
	 input [6:0] yIn,
	 input [15:0] qOut,
    input [3:0] beat,
    output [7:0] xOut,
    output [6:0] yOut,
    output [2:0] cOut
    );
	 
	reg [7:0] x;
	reg [6:0] y;
	reg [3:0] colCount;
	reg [2:0] rowCount;
	reg [2:0] c, xCount, yCount; 
	
	wire cFill, cOutline;
	wire yEnable, colEnable, rowEnable;
	
	assign cFill = qOut[colCount];
	//assign cOutline = (colCount == beat) ? 1 : 0;

	//START x = 8
	//y = 50;
	
	always @(posedge clk) begin
		x <= xIn + (colCount * 8'd6);
		y <= yIn + (rowCount * 7'd15);
		c <= cFill ? 3'b010 : 3'b111;
	end
	
	always @(posedge clk) begin
		if (enable) begin
			if (colCount == 4'b1111)
				colCount <= 4'b0000;
			else
				colCount <= colCount + 1'b1;
		end
	end
	assign yEnable = (colCount == 4'b1111) ? 1 : 0;
	always @(posedge clk) begin
		if (enable && yEnable) begin
			if (rowCount == 3'b111)
				rowCount <= 3'b000;
			else
				rowCount <= rowCount + 1'b1;
		end
	end
	
	/*always @(posedge clk) begin
		x <= xIn + (colCount * 8'd6);
		y <= yIn + (rowCount * 7'd20);
		
		if (xCount == 2'b01 && yCount == 2'b01)
			c <= (cFill ? 3'b010 : 3'b111);
		else
			c <= (cOutline ? 3'b011 : 3'b000);
	end

	assign yEnable = (xCount == 2'b10) ? 1 : 0;
	assign colEnable = (yEnable && yCount == 2'b10) ? 1: 0;
	assign rowEnable = (yEnable && colEnable && colCount == 4'b1111) ? 1 : 0;
   
	// x coordinate
	always @(posedge clk) begi
		if (enable) begin
			if (xCount == 2'b10)
				xCount <= 2'b00;
			else
				xCount <= xCount + 1'b1;
		end
	end
	
	// y coordinate
	always @(posedge clk) begin
		if (enable && yEnable) begin
			if (yCount == 2'b10)
				yCount <= 2'b00;
				
			else 
				yCount <= yCount + 1'b1;
		end
	end
	
	// column number
	always @(posedge clk) begin
		if (enable && yEnable && colEnable) begin
			if (colCount == 4'b1111)
				colCount <= 4'b0000;
			else
				colCount <= colCount + 1'b1;
		end
	end
	
	//row number
	always @(posedge clk) begin
		if (enable && yEnable && colEnable && rowEnable) begin
			if (rowCount == 2'b01)
				rowCount <= 2'b00;
			else
				rowCount <= rowCount + 1'b1;
		end
	end*/
	
	assign xOut = x + colCount;
	assign yOut = y + yCount;
	assign cOut = c;

                                                                                                                                            
endmodule

module control(
    input clk, 
    input resetn,
    input draw,
	 input done,
	 input [15:0] qOut1, qOut2, qOut3,
	 
	 output reg [15:0] pattern,

    output reg writeEn, enable);
	    
	reg [3:0] current_state, next_state;
	reg [15:0] col;
	
	localparam S_WAIT = 3'd0,
	S_DRAW_ROW_1 = 3'd1,
	S_DRAW_ROW_2 = 3'd2,
	S_DRAW_ROW_3 = 3'd3;

	always @(*)
	begin: state_table
		case (current_state)
			S_WAIT: next_state = draw ? S_DRAW_ROW_1 : S_WAIT;
			S_DRAW_ROW_1: next_state = done ? S_DRAW_ROW_2 : S_DRAW_ROW_1;
			S_DRAW_ROW_2: next_state = done ? S_DRAW_ROW_3 : S_DRAW_ROW_2;
			S_DRAW_ROW_3: next_state = done ? S_WAIT : S_DRAW_ROW_3;
		endcase
	end  // state_table

	// Output Logicdraw
	always @(*) 
	begin: enable_signals
		writeEn = 1'b0;
	
		
	case (current_state)

			S_WAIT: begin

				writeEn = 0;
				enable = 1;
				end
				
			S_DRAW_ROW_1: begin

				writeEn = 1;
				enable = 1;
				pattern <= qOut1;

				end
				
			S_DRAW_ROW_2: begin

				writeEn = 1;
				enable = 1; 
				pattern <= qOut2;

				end
				
			S_DRAW_ROW_3: begin

				writeEn = 1;
				enable = 1; 
				pattern <= qOut3;

				end
			// default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block

		endcase
	end // enable_signals

	// current_state registers
	always @(posedge clk) 
	begin: state_FFs		
	if (resetn)
			
		current_state <= S_WAIT;
		
	else
			
		current_state <= next_state;
	
	end // state_FFS
endmodule
