module datapath(
    input clk,
    input resetN, enable,
    input ld_x, ld_y, ld_c,
    input [7:0] xIn,
	 input [6:0] yIn,
    input [2:0] cFill, cOutline,
    output [7:0] xOut,
    output [6:0] yOut,
    output [2:0] cOut
    );
	 
	reg [7:0] x;
	reg [6:0] y;
	reg [2:0] c, xCount, yCount; 
	wire yEnable;
	

	always@(posedge clk) begin
		if (resetN) begin
         x <= 8'b0; 
			y <= 7'b0;
			c <= 3'b0;
		end
		else begin
			x <= xIn;
			y <= yIn;
		end
	end

              
	always @(posedge clk) begin
		if (resetN)
			xCount <= 2'b00;
		else if (enable) begin
			if (xCount == 2'b10)
				xCount <= 2'b00;
			else begin
				xCount <= xCount + 1'b1;
			end
		end
	end
	
	assign yEnable = (xCount == 2'b10) ? 1 : 0;
	
	always @(posedge clk) begin
		if (!resetN)    
			yCount <= 2'b00;
		else if (enable && yEnable) begin
			if (yCount == 2'b10)
				yCount <= 2'b00;
				
			else 
				yCount <= yCount + 1'b1;
		end
	end
	
	if (xCount == 2'b01 && yCount == 2'b01)
		c = cFill ? 3'b010 : 3'b111;
	else
		c = cOutline ? 3'b100 : 3'b000;

	assign xOut = x + xCount;
	assign yOut = y + yCount;
	assign cOut = c;

                                                                                                                                            
endmodule

module control(
    input clk, 
    input resetn,
    input draw,
	 input pattern,
	 input beatCount,

    output reg  xIn, yIn, cFill, cOutline, writeEn, enable);
	    
	reg [3:0] current_state, next_state;
	reg [15:0] col;
	wire done;
	
	localparam S_WAIT = 3'd0,
	S_DRAW = 3'd1;

	always @(*)
	begin: state_table
		case (current_state)
			S_WAIT: next_state = draw ? S_DRAW : S_WAIT;
			S_DRAW: next_state = done ? S_WAIT : S_DRAW;
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
				
			S_DRAW: begin

				writeEn = 1;
				enable = 1; 

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
