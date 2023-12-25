`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:  
// Engineer: 张启元
// 
// Create Date:    16:17:14 12/11/2023
// Design Name:    FIR filter
// Module Name:    tb_Mul_CIC 
// Project Name:   Mul_CIC
// Target Devices: EP4CE115F23I7
// Description: test bench
// Revision: 1.0
// Revision 0.01 - File Created
// Additional Comments: 
//
////////////////////////////////////////////////////////////////////////////////

module tb_Mul_CIC;

    // Inputs
    reg clk;
    reg rst;
    reg filter_in;		//高低电平bit流输入

    // Outputs
    //wire signed [63:0] filter_out;	//抽取滤波输出
	wire tx;
	wire rdy;
	
	parameter Data_len = 22'd2097152;	//数据长度2^21（根据Sigma-Delta调制器输出bit流数据量）
    //parameter Data_len = 22'd460801;	//选取0.9s的数据测试
	reg   mem[Data_len-1:0];  //定义长度为Data_len，位宽深度为1的寄存器mem

	

    // define reset time
    initial 
    begin
        rst = 0;
        #1500;
        rst = 1;
        clk = 0;
	
    end
    
    initial
        begin
			//读取bit流文件
            $readmemb("D:/FPGA_MATLAB_Learning/CIC_Filter/FPGA_Design/Act_MulCIC_Isop_HB/Sim/Bit_Stream_Sweep_Cov.txt",mem);
        end
    integer i=0;
    initial begin
        #15;
        for(i = 0 ; i < Data_len ; i = i+1) begin
            filter_in = mem[i];
            #1954;    //约为512KHz的采样频率    //这个延时时间与实际采样频率周期需要一致，否则仿真出来的波形频率与MATLAB生成的波形不一致
        end    
    end

    // define clock
/*     initial begin
        clk = 0;
        forever #10 clk = ~clk;    
    end */
always #10 clk <= ~clk;	//实际输入时钟频率50MHz

    Mul_CIC u1 (
        .clk(clk), 
        .rst(rst), 
        .Bit_in(filter_in), 
        .tx(tx),
		.rdy(rdy)
    );
 
 endmodule