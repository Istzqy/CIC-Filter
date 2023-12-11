module Integrated(
	rst,clk,Xin,
	Intout
);

input rst;	// 复位信号，高电平有效
input clk;	//系统时钟，频率2KHz
input signed [1:0]		Xin;	//数据输入频率2KHz
output signed [43:0]	Intout;	//滤波器输出数据

//每集积分器需一个寄存器+一级加法
wire signed [43:0] 	I1,I2,I3,I4,I5,I6,temp;
reg	signed	[43:0]	d1,d2,d3,d4,d5,d6;


//第1级积分器
always@(posedge clk or posedge rst)
	if(rst)
		d1 <= 44'd0;
	else
		d1 <= I1;
		
//第一级积分器输出
assign I1 = (rst ? 44'd0 :(d1+{{42{Xin[1]}},Xin}));		//为了输入Xin与d1相加，对Xin进行高位补充，整数填0，负数填1，这样都是按照补码格式。
//测试观察
assign temp = {{42{Xin[1]}},Xin};	

//第2级积分器
always@(posedge clk or posedge rst)
	if(rst)
		d2 <= 44'd0;
	else
		d2 <= I2;
//第二级积分器输出		
assign I2 = (rst ? 44'd0 : (d2+I1));

//第3级积分器
always@(posedge clk or posedge rst)
	if(rst)
		d3 <= 44'd0;
	else
		d3 <= I3;
//第三级积分器输出		
assign I3 = (rst ? 44'd0 : (d3+I2));

//第4级积分器
always@(posedge clk or posedge rst)
	if(rst)
		d4 <= 44'd0;
	else
		d4 <= I4;
//第4级积分器输出		
assign I4 = (rst ? 44'd0 : (d4+I3));

//第5级积分器
always@(posedge clk or posedge rst)
	if(rst)
		d5 <= 44'd0;
	else
		d5 <= I5;
//第5级积分器输出		
assign I5 = (rst ? 44'd0 : (d5+I4));

//第5级积分器
always@(posedge clk or posedge rst)
	if(rst)
		d6 <= 44'd0;
	else
		d6 <= I6;
//第6级积分器输出		
assign I6 = (rst ? 44'd0 : (d6+I5));

//积分器部分最后输出
assign Intout = I6;	


endmodule