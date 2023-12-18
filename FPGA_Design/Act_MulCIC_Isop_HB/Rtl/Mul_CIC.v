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
	rst,clk,Bit_in,
	Filter_out,rdy
);

input	rst;			//复位信号，高电平有效
input	clk;			//FPGA系统时钟，频率为50MHz
input	Bit_in;			//高低电平bit流数据输入频率为512kHz
output	signed [63:0]	Filter_out;	//滤波后的输出数据
output 			rdy;	//数据有效指示信号

wire clk_div;				//PLL分频IP核分频输出：512KHz
wire locked;				//PLL分频IP核稳定输出标志
wire ND;					//抽取一次完成标志
wire signed [1:0]  Bit_out; //Bit流转换输出
wire signed [43:0] Intout;	//积分器输出
wire signed [43:0] Combout;	//梳状器输出
wire signed [43:0] dout;	//抽取输出
wire signed [46:0] Isopout;	//补偿器输出
//wire signed [36:0] yt;
assign rdy = ND;

//积分器例化
Integrated u1(
	.rst(rst),
	.clk(clk_div),
	.Xin(Bit_out),
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
	.IsopOut(Isopout)
);
//2抽取半带滤波器例化
HalfBand u6(
	.rst(rst),
	.clk(clk_div),
	.ND(ND),
	.HBIN(Isopout),
	.HBout(Filter_out)
	
);
//高低电平Bit流输入量化转换
In_Convert u7(
	.rst(rst),
	.clk(clk_div),
	.Bit_in(Bit_in),
	.Bit_out(Bit_out)
);


endmodule



