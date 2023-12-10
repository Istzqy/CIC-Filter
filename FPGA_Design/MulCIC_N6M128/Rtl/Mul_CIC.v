module Mul_CIC(
	rst,clk,Xin,
	Yout,rdy
);

input	rst;	//复位信号，高电平有效
input	clk;	//FPGA系统时钟，频率为2kHz
input	[1:0]	Xin;	//数据输入频率为2kHz
output	[43:0]	Yout;	//滤波后的输出数据
output 			rdy;	//数据有效指示信号

wire clk_div;
wire locked;
wire ND;	//完成标志
wire signed [43:0] Intout;
wire signed [43:0] dout;
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
	.Yout(Yout)
);
//分频器例化:将实际输入50MHz分频为512KHz
Clk_Div u4(
	.areset(rst),
	.inclk0(clk),
	.c0(clk_div),
	.locked(locked)
);
assign rdy = ND;

endmodule



