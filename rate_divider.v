module rate_divider(clk, speed, new_clk);
	input clk;
	input [27:0] speed;
	output new_clk;
	reg tmp_clk = 1'b0;
	reg [27:0] count;
	
	always @(posedge clk)
		begin
			if (count == 28'd0) begin
				tmp_clk <= ~tmp_clk;
				count <= speed;
				end
			else 
				count <= count - 1'b1;
		end
	assign new_clk = tmp_clk;
endmodule
