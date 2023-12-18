/*
	2023.12.14 东南大学
作者：		张启元
文件名：	In_Convert.v
所属项目:	Bit流抽取滤波器设计
顶层模块：	In_Convert
模块名称及其描述:	
	In_Convert模块：
		将输入高低电平信号转换为Bit流量化数据（01与11）
修改纪录：
	231211 修改
*/

module In_Convert(
	
	rst,clk,Bit_in,
	Bit_out
);
input	rst;			//复位信号，高电平有效
input	clk;			//锁相环分频输出时钟，频率为512KHz
input	Bit_in;			//Bit流高低电平输入
output 	reg signed [1:0]	Bit_out;	//转换后输出数据

always@(posedge	clk or posedge rst)
	if(rst)
		Bit_out <= 2'b00;
	else
		begin
			if(Bit_in == 1'd1)
				Bit_out <= 2'b01;	//对应十进制有符号数为1
			else
				Bit_out <= 2'b11;	//对应十进制有符号数为-1
		end

endmodule
