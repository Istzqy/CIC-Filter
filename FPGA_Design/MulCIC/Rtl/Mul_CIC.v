module Mul_CIC(
	rst,clk,Xin,
	Yout,rdy
);

input	rst;	//复位信号，高电平有效
input	clk;	//FPGA系统时钟，频率为2kHz
input	[9:0]	Xin;	//数据输入频率为2kHz
output	[16:0]	Yout;	//滤波后的输出数据
output 			rdy;	//数据有效指示信号


wire ND;
wire signed [36:0] Intout;
wire signed [36:0] dout;
//wire signed [36:0] yt;

Integrated u1(
	.rst(rst),
	.clk(clk),
	.Xin(Xin),
	.Intout(Intout)
);

Decimate u2(
	.rst(rst),
	.clk(clk),
	.Iin(Intout),
	.dout(dout),
	.rdy(ND)
);

Comb u3(
	.rst(rst),
	.clk(clk),
	.ND(ND),
	.Xin(dout),
	.Yout(Yout)
);

assign rdy = ND;

endmodule



