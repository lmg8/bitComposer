module flipflop(clock, d, load, reset_n, q);
	input clock; 
	input d;
	input reset_n, load;
	output reg q;

	always @(posedge clock)
	begin
		if (reset_n == 1'b1)
			q <= 0;
		else if (load == 1'b1)
			q <= d;
	end
endmodule
