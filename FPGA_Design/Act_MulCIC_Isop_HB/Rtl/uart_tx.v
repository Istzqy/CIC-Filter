module uart_tx
#(
	parameter UART_BPS = 'd115200,		//串口波特率
	parameter CLK_FREQ = 'd50_000_000	//时钟频率
)
(
	input 	wire					sys_clk 	,	//系统时钟50MHz
	input 	wire					sys_rst_n	,	//全局复位
	input	wire	signed [63:0]	pi_data		,	//模块输入的64bit数据
	input	wire					pi_flag		,	//并行数据有效标志信号
	
	output	reg						tx				//串转并后的1bit数据
);

//波特率计数
localparam	BAUD_CNT_MAX	=	CLK_FREQ/UART_BPS	;


//reg define
reg	[12:0]	baud_cnt;
reg			bit_flag;
reg	[6:0]	bit_cnt;
reg	[3:0]	send_cnt;
reg			work_en;
reg	[3:0]	times;

wire	signed	[71:0]	send_data;

//真正发送数据:高64位为有效数据，低8位为自定义的分隔符
assign send_data	 = {pi_data, 8'H17};

//******
//***Main Code*****//

//work_en
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0 )
		work_en <= 1'b0;
	else if(pi_flag == 1'b1)
		work_en <= 1'b1;
	else if ((bit_flag == 1'b1) && (bit_cnt >= 7'd89) && (send_cnt == 4'd9))
		work_en <= 1'b0;
		
//baud_cnt:波特率计数，从0计数到BAUD_CNT_MAX - 1
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0 )
		baud_cnt <= 13'b0;
	else if((baud_cnt == BAUD_CNT_MAX -1 ) || (work_en == 1'b0))
		baud_cnt <= 13'b0;
	else if (work_en == 1'b1)
		baud_cnt <= baud_cnt + 1'b1;
		
//bit_flag:当baud_cnt计数器计数到1时，让bit_flag拉高一个时钟
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0 )
		bit_flag <= 1'b0;
	else if(baud_cnt == 13'd1)
		bit_flag <= 1'b1;
	else
		bit_flag <= 1'b0;
		
//bit_cnt：总发送数据位数个数计数，90个有效数据（含起始位和停止位）到来后计数器清零
//			bitcnt的数值需要根据实际发送数据的总位数进行更改N*10-1，其中N为发送的字节总数
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0 )
		bit_cnt <= 7'b0;
	else if((bit_flag == 1'b1) && (bit_cnt == 7'd89))
		bit_cnt <= 7'd0;
	else if ((bit_flag == 1'b1) && (work_en == 1'b1))
		bit_cnt <= bit_cnt + 1'b1;
		
//send_cnt：单次发送数据位数个数计数
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0 )
		send_cnt <= 4'd0;
	else if((bit_flag == 1'b1) && (send_cnt == 4'd9))
		send_cnt <= 4'd0;
	else if ((bit_flag == 1'b1) && (work_en == 1'b1))
		send_cnt <= send_cnt + 1'b1;
	
//times:发送次数计数
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n  == 1'b0)
		times <= 4'b0;
	else if(bit_cnt == 7'd89)
		times <= 4'b0;
	else if ((send_cnt == 4'd9) && (baud_cnt == 13'd3))
		times <= times + 1'b1;
		
//tx: 输出数据在满足rs232协议（起始位0，停止位1）的情况下一位一位输出
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n  == 1'b0)
		tx <= 1'b1;		//空闲状态为高电平
	else if(bit_flag  == 1'b1)
		case(send_cnt)
			0		:	tx <= 1'b0;
			1		:	tx <= send_data[0+times * 8];
			2		:	tx <= send_data[1+times * 8]; 
			3		:	tx <= send_data[2+times * 8];
			4		:	tx <= send_data[3+times * 8];
			5		:	tx <= send_data[4+times * 8];
			6		:	tx <= send_data[5+times * 8];
			7		:	tx <= send_data[6+times * 8];
			8		:	tx <= send_data[7+times * 8];
			9		:	tx <= 1'b1;
			default	:	tx <= 1'b1;
		endcase
		
endmodule
