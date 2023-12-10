module Comb(
	rst,clk,ND,
	Xin,Yout
);

input 	rst;
input	clk;
input	ND;		//输入数据准备完成标志
input	signed [43:0] Xin;	//输入数据频率为2KHz
output	signed [43:0] Yout;	//滤波后输出数据

reg signed [43:0]	d1,d2,d3,d4,d5,d6,d7;
wire signed [43:0]	c1,c2,c3,c4,c5;
wire signed [43:0]	You_tem;

//3级梳状器结构
always@(posedge rst or posedge clk)
	if(rst)
		begin
			d1 <= 44'd0;
			d2 <= 44'd0;
			d3 <= 44'd0;
			d4 <= 44'd0;
			d5 <= 44'd0;
			d6 <= 44'd0;
			d7 <= 44'd0;
		end
	else
		begin
			if(ND)
				begin
					d1<= Xin;
					d2<= d1;
					d3<= c1;
					d4<= c2;
					d5<= c3;
					d6<= c4;
					d7<= c5;
				end
		end
//第一级梳状器输出
assign c1 = (rst ? 44'd0 : (d1-d2));
//第二级梳状器输出
assign c2 = (rst ? 44'd0 : (c1-d3));
//第三级梳状器输出
assign c3 = (rst ? 44'd0 : (c2-d4));
//第四级梳状器输出
assign c4 = (rst ? 44'd0 : (c3-d5));
//第五级梳状器输出
assign c5 = (rst ? 44'd0 : (c4-d6));
//第六级梳状器输出
assign You_tem = (rst ? 44'd0 : (c5-d7));

assign Yout = You_tem;
	

endmodule
