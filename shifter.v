module shift(clk, select, clear, load, out);
	input clk, clear, load;
	input [2:0] select;
	output out;

	wire [27:0] q;
	wire rateClk;
	
	wire [11:0] pattern;
	wire [11:0] shiftOut;
	
	assign rateClk = (q == 0 ? 1 : 0);
	
	LUT lut(select, pattern);
	RateDivider rd(clk, clear, 28'b0001011111010111100000111111, q);
	
	shifter my_shifter(pattern, clear, load, rateClk, 1'b0, 1'b1, shiftOut);
	
	assign out = shiftOut[0];
endmodule

module LUT(select, pattern);
	input [2:0] select;
	output reg [11:0] pattern;

	always @(select)
	begin
	case(select)
		3'b000: pattern = 12'b000000011101;
		3'b001: pattern = 12'b000101010111;
		3'b010: pattern = 12'b010111010111;
		3'b011: pattern = 12'b000001010111;
		3'b100: pattern = 12'b000000000001;
		3'b101: pattern = 12'b000101110101;
		3'b110: pattern = 12'b000101110111;
		3'b111: pattern = 12'b000001010101;
	endcase
	end
endmodule

module RateDivider(clock, reset, d, q);
	input clock, reset;
	input [27:0] d;
	output reg [27:0] q;

	always @(posedge clock)
	begin
		if(reset == 1'b0) 
			q <= 0;
		else if(q == 0)
			q <= d;
		else 
			q <= q - 1'b1;
	end
endmodule

module shifter(load_val, reset, load, clk, asr, shift, q);
	input [11:0] load_val;
	input reset, asr, shift;
	input load;
	input clk;
	output [11:0] q;

	wire [11:0] shiftWire;
	
	shifterBit bit11(asr, load_val[11], shift, load, reset, clk, shiftWire[11]);
	shifterBit bit10(shiftWire[11], load_val[10], shift, load, reset, clk, shiftWire[10]);
	shifterBit bit9(shiftWire[10], load_val[9], shift, load, reset, clk, shiftWire[9]);
	shifterBit bit8(shiftWire[9], load_val[8], shift, load, reset, clk, shiftWire[8]);
	shifterBit bit7(shiftWire[8], load_val[7], shift, load, reset, clk, shiftWire[7]);
	shifterBit bit6(shiftWire[7], load_val[6], shift, load, reset, clk, shiftWire[6]);
	shifterBit bit5(shiftWire[6], load_val[5], shift, load, reset, clk, shiftWire[5]);
	shifterBit bit4(shiftWire[5], load_val[4], shift, load, reset, clk, shiftWire[4]);
	shifterBit bit3(shiftWire[4], load_val[3], shift, load, reset, clk, shiftWire[3]);
	shifterBit bit2(shiftWire[3], load_val[2], shift, load, reset, clk, shiftWire[2]);
	shifterBit bit1(shiftWire[2], load_val[1], shift, load, reset, clk, shiftWire[1]);
	shifterBit bit0(shiftWire[1], load_val[0], shift, load, reset, clk, shiftWire[0]);

	assign q = shiftWire;
endmodule

module shifterBit (in, load_val, shift, load_n, reset_n, clk, out);
	input in, load_val, shift, load_n, reset_n, clk;
	output out;
	
	wire mux_out, mux2_out;
	mux2to1 mux1(out, in, shift, mux_out);
	mux2to1 mux2(load_val, mux_out, load_n, mux2_out);
	flipflop F0(reset_n, clk, mux2_out, out);
endmodule

module flipflop(reset, clk, d, q);
	input clk, reset, d;
	output reg q;

	always @(posedge clk)
	begin 
		if (reset == 1'b0)
			q <= 1'b0;
		else
			q <= d;
	end
endmodule

module mux2to1(x, y, s, m);
    input x, y, s; 
    output m; 
  
    assign m = s & y | ~s & x;
	 // OR
    // assign m = s ? y : x;

endmodule