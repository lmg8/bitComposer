module counter(clock, clear_b, q);
	input clock;
	input clear_b;
	output reg [3:0] q;

	always @(posedge clock)
	begin 
		if(clear_b == 1'b1)
			q <= 4'b0000;
		else
			q <= q + 1'b1;
	end
endmodule
