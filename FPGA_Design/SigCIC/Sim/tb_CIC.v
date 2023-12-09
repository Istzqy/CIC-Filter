`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:  
// Engineer: anxu chan
// 
// Create Date:    16:17:14 08/02/2017 
// Design Name:    FIR filter
// Module Name:    fir 
// Project Name:   FirDesign
// Target Devices: Xilinix V5
// Description: test bench
// Revision: 1.0
// Revision 0.01 - File Created
// Additional Comments: 
//
////////////////////////////////////////////////////////////////////////////////

module tb_CIC;

    // Inputs
    reg clk;
    reg rst;
    reg signed [9:0] filter_in;

    // Outputs
    wire signed [12:0] filter_out;
	wire rdy;
	
	parameter Data_len = 13'd4096;	//数据长度
    reg signed[9:0] mem[Data_len-1:0];    //定义长度为Data_len，位宽深度为10的寄存器mem
    


    // define reset time
    initial 
    begin
        rst = 1;
        #1500;
        rst = 0;
        clk = 0;
    end
    
    initial
        begin
            $readmemb("D:/FPGA_MATLAB_Learning/CIC_Filter/FPGA_Design/SigCIC/Sim/signal.txt",mem);
        end
    
    integer i=0;
    initial begin
        #15;
        for(i = 0 ; i < Data_len ; i = i+1) begin
            filter_in = mem[i];
            #5000;        //这个延时时间与实际采样频率周期需要一致，否则仿真出来的波形频率与MATLAB生成的波形不一致
        end    
    end

    // define clock
/*     initial begin
        clk = 0;
        forever #10 clk = ~clk;    
    end */
always #2500 clk <= ~clk;

    Sig_CIC u1 (
        .clk(clk), 
        .rst(rst), 
        .din(filter_in), 
        .dout(filter_out),
		.rdy(rdy)
    );
 
 endmodule