/*
	2023.12.11 东南大学
作者：		张启元
文件名：	Isop.v
所属项目:	Bit流抽取滤波器设计
顶层模块：	Mul_CIC
模块名称及其描述:	
	Isop模块：
	基于ISOP补偿滤波器，用于对CIC滤波器输出进行通带补偿；
	补偿器的参数已经过Matlab仿真，仿真条件是fs=512KHz, 通带500Hz。针对6级128阶CIC滤波器，抽取因子128	
修改纪录：
	231211 创建
*/


module Isop(

	rst,clk,IsopIn,ND,
	IsopOut
);

input	rst;	//复位信号
input	clk;	//系统时钟512KHz
input	ND;		//抽取完成标志
input	signed 	[43:0] 	IsopIn;		//CIC滤波输出
output	signed	[46:0]	IsopOut;	//Isop补偿器输出

reg signed [46:0]	delay1,delay2;	//延迟环节
wire signed [46:0] 	tem1,out_tem;	//ISOP补偿器中间变量,输出暂存
wire signed [47:0] 	test1;			//缓存补偿器的中间参量
wire signed [46:0] 	test2;			//缓存补偿器的中间参量

//Isop补偿器参数，Matlab仿真为-5.494，为整数化选择-6
//注意参量的定义方式
parameter c = -4'd6;	

always@(posedge rst or posedge clk)	
	if(rst)
		begin
			delay1 <= 47'd0;
			delay2 <= 47'd0;
		end
	else
		begin
			if(ND)
				begin
					delay1<= IsopIn;
					delay2<= delay1;
				end
		end

assign test1 = c*delay1;
assign tem1 = (rst ? 47'd0 : ({{3{IsopIn[43]}},IsopIn} + c*delay1));
// >>>2 近似除以4，算数右移4位. 循环右移针对有符号数，会整体右移（包含符号位）
// 右移后，最高位：若是正数则补0；若是负数则补1
assign test2 =  (delay2 + tem1)>>>2; 
assign out_tem = (rst ? 47'd0 : test2 ); 
assign IsopOut = out_tem;

endmodule
