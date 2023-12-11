/*
	2023.12.11 东南大学
作者：		张启元
文件名：	Decimate.v
所属项目:	Bit流抽取滤波器设计
顶层模块：	Mul_CIC
模块名称及其描述:	
	Decimate模块：
		CIC滤波器中的抽取模块：根据Sigma-Delta调制器降采样需求,抽取因子设为128
修改纪录：
	231211 修改
*/

//抽取模块
module Decimate(
	rst,clk,Iin,
	dout,rdy
);

input	rst;	//复位信号
input	clk;	//系统时钟512KHz
input	signed[43:0] Iin;	//积分器输出作为抽取的输入
output	signed[43:0] dout;	//抽取模块输出
output	rdy;	//抽取一次完成标志

reg [6:0] c;	//抽取数
reg signed [43:0] dout_tem;	//抽取缓存
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
			if(c==7'd127)	//抽取因子为128时，每隔127个数据抽取一次
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
