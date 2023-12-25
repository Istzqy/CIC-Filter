module HalfBand(
	
	rst,clk,HBIN,ND,
	HBout,Fo_flag
);

input	rst;	//复位信号
input	clk;	//系统时钟512KHz
input	ND;		//前级抽取完成标志（频率为4KHz的脉冲）
input	signed 	[46:0]	HBIN;	//Isop补偿器输出作为输入
output	reg signed	[63:0]	HBout;	//半带滤波器输出
output	reg	Fo_flag;	//半带滤波器完成标志


/* always@(posedge clk or posedge rst)
	if(rst)
		cnt <= 1'b0;
	else
		if(ND)
			cnt<=cnt + 1'b1; */
//1位计数器
/* wire cnt;
assign cnt = (rst ? 1'b0 : (ND) ? (cnt+1) );
 */

//降采样，采样频率从4KHz降到2KHz
reg cnt;
reg signed [46:0] 	Xin_Reg[18:0];
reg [4:0]	i,j;
reg down_sp;	//降采样完成标志
always@(posedge clk or posedge rst)
	if(rst)
		begin
			for(i=0;i<=18;i=i+1)
				Xin_Reg[i]=47'd0;
			down_sp <= 1'b0;
			cnt <= 1'b0;
		end
	else
		begin
			if((ND==1))
				begin
					if(cnt == 1'b1)
						begin
							for(j=0;j<18;j=j+1)
								Xin_Reg[j+1]<=Xin_Reg[0];
								Xin_Reg[0]<= HBIN;
							down_sp <= 1'b1;
						end
					cnt <= cnt + 1 ;
				end
			else
				down_sp <= 1'b0;
		end

//半带滤波器系数
//localparam signed [15:0] h[5:0] = {16'H0025, 16'Hff17, 16'H035b, 16'Hf606,16'H2765, 16'H4000};
localparam signed h0_18 = 16'H0025;
localparam signed h2_16 = 16'Hff17;
localparam signed h4_14 = 16'H035b;
localparam signed h6_12 = 16'Hf606;
localparam signed h8_10 = 16'H2765;
localparam signed h9 = 16'H4000;

/* wire signed [63:0] out_tem;
assign out_tem = (rst ? 64'd0: ((Xin_Reg[0]+Xin_Reg[18])*h0_18 + (Xin_Reg[2]+Xin_Reg[16])*h2_16 + (Xin_Reg[4]+Xin_Reg[14])*h4_14 + (Xin_Reg[6]+Xin_Reg[12])*h6_12 + (Xin_Reg[8]+Xin_Reg[10])*h8_10 + Xin_Reg[9]*h9) );
 */
always@(posedge clk or posedge rst)
	if(rst)
		HBout <= 64'd0;
	else
		begin
			if(down_sp == 1'b1)
				HBout <= ((Xin_Reg[0]+Xin_Reg[18])*h0_18 + (Xin_Reg[2]+Xin_Reg[16])*h2_16 + (Xin_Reg[4]+Xin_Reg[14])*h4_14 + (Xin_Reg[6]+Xin_Reg[12])*h6_12 + (Xin_Reg[8]+Xin_Reg[10])*h8_10 + Xin_Reg[9]*h9) ;
		end
			
//assign HBout = (rst ? 64'd0 : (down_sp)? out_tem);

//滤波完成标志
always@(posedge clk or posedge rst)
	if(rst)
		Fo_flag <= 1'd0;
	else
		Fo_flag <= down_sp;

endmodule

