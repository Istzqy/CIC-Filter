//抽取模块
module Decimate(
	rst,clk,Iin,
	dout,rdy
);

input	rst;
input	clk;
input	signed[43:0] Iin;
output	signed[43:0] dout;
output	rdy;

reg [6:0] c;
reg signed [43:0] dout_tem;
reg rdy_tem;
always@(posedge clk or posedge rst)
	if(rst)
		begin
			c = 7'd0;
			dout_tem <= 44'd0;
			rdy_tem <= 1'b0;
		end
	else
		begin
			if(c==7'd127)	//抽取因子为5时，每隔4个数据抽取一次
				begin
					rdy_tem <= 1'b1;
					dout_tem <= Iin;
					c =7'd0;
				end
			else
				begin
					rdy_tem <= 1'b0;
					c=c+1;
				end
		end
assign dout = dout_tem;
assign rdy	= rdy_tem;



endmodule
