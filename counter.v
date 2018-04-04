module counter(clock, q);
	input clock;
	output reg [3:0] q;

	always @(posedge clock)
	begin
		q <= q + 1'b1;
	end
endmodule
