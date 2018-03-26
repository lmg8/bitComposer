module rate_divider(clk, new_clk);
	input clk;
	output new_clk;
	reg tmp_clk = 1'b0;
	reg [27:0] count = 28'd19999999;
	
	always @(posedge clk)
		begin
			if (count == 28'd0) begin
				tmp_clk <= ~tmp_clk;
				count <= 28'd19999999;
				end
			else 
				count <= count - 1'b1;
		end
	assign new_clk = tmp_clk;
endmodule
