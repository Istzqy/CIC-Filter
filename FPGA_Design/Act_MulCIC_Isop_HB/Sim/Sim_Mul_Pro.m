%% 代码功能
%构造正弦波信号并进行有符号数量化，最终输出二进制数据到.txt文件并保存到指定的路径
clear all;
close all;
%% %=============设置系统参数==============%
f1=30;        %设置波形频率
%f2=1e3;
% f3=800e3;
Fs=512e3;        %设置采样频率
L=8192;         %数据长度
N=2;           %数据位宽
%% %=============产生输入信号==============%
t=0:1/Fs:(1/Fs)*(L-1);
y1=sin(2*pi*f1*t);
%y2=sin(2*pi*f2*t);
% y3=sin(2*pi*f3*t);
% y4=y1+y2+y3;
y4 = y1 ;
n=1;    %表示有几个信号
y_n=round(y4*(2^(N-n)-1));      %N比特量化;如果有n个信号相加，则设置（N-n）
                                %针对量化这行代码为什么量化时要做一个(N-n)进一步解释.:
                                %N位量化是要将输出的波形量化用+/-（2^N）的整数表示
                                %将14行输出量化表达式展开=y1*2^(N-3)+y2*2^(N-3)+y3*2^(N-3)
                                %3个N-3位量化的数相加，用N位的数表示才能不溢出，这样就满足了输出y_n的N位量化要求
%% %=================画图==================%
a=8;           %改变系数可以调整显示周期
stem(t,y_n);
axis([0 L/Fs/a -2^(N-1) 2^(N-1)]);      %调整坐标正达到调节波形显示范围的效果
%% %=============写入外部文件==============%
fid=fopen('D:\FPGA_MATLAB_Learning\CIC_Filter\FPGA_Design\MulCIC_N6M128\Sim\signal.txt','w');    %把数据写入sin_data.txt文件中，如果没有就创建该文件  

for k=1:length(y_n)
    B_s=dec2bin(y_n(k)+((y_n(k))<0)*2^N,N); %将十进制数转换成二进制补码，正数补码=原码，负数补码=（2^N+负数）
    for j=1:N
        if B_s(j)=='1'
            tb=1;
        else
            tb=0;
        end
        fprintf(fid,'%d',tb);
    end
    fprintf(fid,'\n');
end

fclose(fid);

%% 将二进制补码的bit的txt文件转换成0或1的高低电平文件
%fid=fopen('D:\FPGA_MATLAB_Learning\CIC_Filter\FPGA_Design\MulCIC_Isop_HB\Sim\Bit_Stream.txt','r');    %把数据写入sin_data.txt文件中，如果没有就创建该文件  
clear all;
data = importdata('D:\FPGA_MATLAB_Learning\CIC_Filter\FPGA_Design\Act_MulCIC_Isop_HB\Sim\Bit_Stream.txt');
% fid = fopen('D:\FPGA_MATLAB_Learning\CIC_Filter\FPGA_Design\MulCIC_Isop_HB\Sim\Bit_Stream.txt', 'r');
% data = fread(fid, Inf, 'char');
% fclose(fid);
for k=1:length(data)
    if(data(k)==1)
        output(k) = 1;
    else
        output(k) = 0;
    end
end
fid = fopen('D:\FPGA_MATLAB_Learning\CIC_Filter\FPGA_Design\Act_MulCIC_Isop_HB\Sim\Bit_Stream_Cov.txt','wt');
fprintf(fid,'%d\n',output);       % \n 换行
fclose(fid);
% % 可以选择将数据保存到另一个文件中
% writematrix(output','D:\FPGA_MATLAB_Learning\CIC_Filter\FPGA_Design\MulCIC_Isop_HB\Sim\Bit_Stream.csv');





