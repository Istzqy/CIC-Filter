module Comb(
	rst,clk,ND,
	Xin,Yout
);

input 	rst;
input	clk;
input	ND;		//输入数据准备完成标志
input	signed [16:0] Xin;	//输入数据频率为2KHz
output	signed [16:0] Yout;	//滤波后输出数据

reg signed [16:0]	d1,d2,d3,d4;
wire signed [16:0]	c1,c2;
wire signed [16:0]	You_tem;


//3级梳状器结构
always@(posedge rst or posedge clk)
	if(rst)
		begin
			d1 <= 17'd0;
			d2 <= 17'd0;
			d3 <= 17'd0;
			d4 <= 17'd0;
		end
	else
		begin
			if(ND)
				begin
					d1<= Xin;
					d2<= d1;
					d3<= c1;
					d4<= c2;
				end
		end
assign c1 = (rst ? 17'd0 : (d1-d2));
assign c2 = (rst ? 17'd0 : (c1-d3));
assign You_tem = (rst ? 17'd0 : (c2-d4));
assign Yout = You_tem[16:0];


endmodule
