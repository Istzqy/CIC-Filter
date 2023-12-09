 module Sig_CIC(
 
	rst,clk,din,
	rdy,dout);

input 	rst;
input 	clk;
input	signed [9:0]	din;
output	rdy;
output	signed [12:0]	dout;

reg rdy_tem;
reg [2:0] c;
reg signed [12:0] tem;
reg signed [12:0] dout_tem;

always @(posedge clk or posedge rst)
	if(rst)
		begin
			c <= 3'd0;
			tem<=13'd0;
			dout_tem<=13'd0;
			rdy_tem<=1'b0;
		end
	else
		begin
			if(c==4)
				begin
					rdy_tem <= 1'b1;
					dout_tem <= tem + din;
					c = 3'd0;
					tem =13'd0;
				end
			else
				begin
					rdy_tem <= 1'b0;
					tem = tem +din;
					c=c+1;
				end
		end
	assign dout = dout_tem;
	assign rdy = rdy_tem;
	
endmodule
