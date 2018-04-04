module clockSpeed(clk, key, OUT, count);
	input clk, key;
	output reg [27:0] OUT;
	output reg [1:0] count;
	
	wire debouncedKey;
	debouncer(clk, key, debouncedKey);
	
	always @(posedge debouncedKey)
	begin
		count <= count + 1'b1;
	end
	
	always @(*)
	begin
		case (count[1:0])
			2'b00: OUT = 28'd40000000;
			2'b01: OUT = 28'd20000000;
			2'b10: OUT = 28'd10000000;
			2'b11: OUT = 28'd5999999;
		endcase
	end
endmodule
