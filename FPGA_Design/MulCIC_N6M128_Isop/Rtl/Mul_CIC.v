/*
	2023.12.11 东南大学
作者：		张启元
文件名：	Mul_CIC.v
所属项目:	Bit流抽取滤波器设计
顶层模块：	Mul_CIC
模块名称及其描述:	
	Mul_CIC模块：
		顶层例化模块，将积分器、抽取器、梳状器、PLL分频IP核、ISOP补偿器例化
修改纪录：
	231211 修改
*/

module Mul_CIC(
	rst,clk,Xin,
	Yout,rdy
);

input	rst;			//复位信号，高电平有效
input	clk;			//FPGA系统时钟，频率为50MHz
input	[1:0]	Xin;	//数据输入频率为512kHz
output	[46:0]	Yout;	//滤波后的输出数据
output 			rdy;	//数据有效指示信号

wire clk_div;				//PLL分频IP核分频输出：512KHz
wire locked;				//PLL分频IP核稳定输出标志
wire ND;					//抽取一次完成标志
wire signed [43:0] Intout;	//积分器输出
wire signed [43:0] Combout;	//梳状器输出
wire signed [43:0] dout;	//抽取输出
//wire signed [36:0] yt;


//积分器例化
Integrated u1(
	.rst(rst),
	.clk(clk_div),
	.Xin(Xin),
	.Intout(Intout)
);
//抽取例化
Decimate u2(
	.rst(rst),
	.clk(clk_div),
	.Iin(Intout),
	.dout(dout),
	.rdy(ND)
);
//梳状器例化
Comb u3(
	.rst(rst),
	.clk(clk_div),
	.ND(ND),
	.Xin(dout),
	.Yout(Combout)
);
//分频器例化:将实际输入50MHz分频为512KHz
Clk_Div u4(
	.areset(rst),
	.inclk0(clk),
	.c0(clk_div),
	.locked(locked)
);
//补偿器例化
Isop u5(
	.rst(rst),
	.clk(clk_div),
	.ND(ND),
	.IsopIn(Combout),
	.IsopOut(Yout)
);

assign rdy = ND;

endmodule



