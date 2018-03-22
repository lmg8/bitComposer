module vgaMonitor
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
    wire cFill, cOutline, xStart, yStart;
	 wire pattern, beatCount, plot;
    // Instansiate datapath
	vgaDatapath d0(clk, cFill, cOutline, xStart, yStart, x, y, colour);

    // Instansiate FSM control
    vgaControl c0(clk, pattern, beatCount, plot, cFill, cOutline, xStart, yStart);
    
endmodule

module vgaDatapath(clk, cFill, cOutline, xStart, yStart, xOut, yOut, cOut);
	input clk, plot;
	input [2:0] cFill, cOutline;
	input [7:0] xStart;
	input [6:0] yStart;
	
	output [7:0] xOut;
	output [6:0] yOut;
	output [2:0] cOut;
	
	reg [7:0] x, xAdd;
	reg [6:0] y, yAdd;
	
	reg enable, fill;
	wire done;
	
	/* 
	xBig interval = 3
	xSmall interval = 5
	yBig interval = 7
	ySmall interval = 9
	
	one row:
	big = 58
	small = 59
	*/
	
	always @(posedge clk) begin
	
		if (plot) begin
			fill = 1'b0;
			x <= xStart
			y <= yStart;
			plot  1'b0;
		end
		
		else if (~fill) begin
			enable = 1;
			xMax = 2'b10;
			yMax = 2'b10;
			x <= x + xAdd;
			y <= y + yAdd;
			cOut = cOutline ? 3'b100 : 3'b000
			if (done) begin
				fill = 1'b1;
			end
		end
		
		else if (fill) begin
			enable = 0;
			x <= xStart + 1;
			y <= yStart + 1;
			cOut = cFill ? 3'b010 : 3'b111;
		end
	end
	
	drawSquare(clk, enable, reset, xMax, yMax, xAdd, yAdd, done);
	
	xOut = x;
	yOut = y;
	cOut = c;

endmodule

module drawSquare(clk, enable, reset, xMax, yMax, x, y, done);
	input clk, enable;
	input [1:0] xMax, yMax;
	output [7:0] x;
	output [6:0] y;
	output done;
	
	reg [1:0] xCount, yCount;
	wire yEnable;
	
	
	always @(posedge clk) begin
		if (!reset)
			xCount <= 2'b00;
		else if (enable) begin
			if (xCount == xMax)
				xCount <= 2'b00;
			else begin
				xCount <= xCount + 1'b1;
			end
		end
	end
	
	assign yEnable = (xCount == xMax) ? 1 : 0;
	
	always @(posedge clk) begin
		if (!reset)    
			yCount <= 2'b00;
		else if (enable && yEnable) begin
			if (yCount == yMax)
				yCount <= 2'b00;
				
			else 
				yCount <= yCount + 1'b1;
		end
	end

	assign x = xCount;
	assign y = yCount;
endmodule

module vgaControl(clk, pattern, beatCount, plot, cFill, cOutline, xOut, yOut);
	input clk;
	input [15:0] pattern;
	
	output plot;
	output [2:0] cFill, cOutline;
	output [7:0] xOut;
	output [6:0] yOut;
	
	reg [3:0] xCount;
	reg [1:0] yCount;
	wire yEnable;
	
	always @{posedge clk) begin
		if (xCount == 4'b1111)
			xCount <= 1'b0;
			
		else begin
			xCount <= xCount + 1'b1;
			plot = 1'b0;
		end
		
		assign yEnable = (xCount == xMax) ? 1 : 0;
	
		if (yEnable) begin
			if (yCount == 1'b1)
				yCount <= 2'b00;
				
			else 
				yCount <= yCount + 1'b1;
		end
	end
	
	xOut = (1'd30 + (xCount * 1'd8));
	yOut = ( 2'd42 + (yCount * 2'd23));
	cFill = pattern[xCount];
	cOutline = (beatCount == xCount);
	
endmodule
