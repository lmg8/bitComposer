module flipflop(clock, d, reset_n, q);
	input clock; 
	input d;
	input reset_n;
	output reg q;

	always @(posedge clock)
	begin
		if (reset_n == 1'b1)
			q <= 0;
		else
			q <= d;
	end
endmodule
