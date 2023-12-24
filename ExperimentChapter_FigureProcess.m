%
%    代码功能：处理实验部分关于降采样抽取滤波器功能验证部分的代码
%    修改日期：2023.12.24 
%    作者：张启元
%    地点：东南大学
%% 实验部分第一个图，单频信号经Sigma-Delta调制器输出Bit流，然后经过FPGA的CIC滤波后的数据
% 读取串口助手中FPGA发送来的十六进制滤波后的数据，转换为十进制数据
clc;
clear all;

%相关采样参数
Fs = 512e3;
Dosam_coe= 256;
Fs_real = Fs/Dosam_coe;

%按照字符串读取txt中的数据，读取的16进制数被存为1个元胞数组
%单频信号
data1 = textread('D:\FPGA_MATLAB_Learning\CIC_Filter\Data_Process\data6_30Hz_256000_512K_1221_red.txt','%s')';

%将十六进制数转换为无符号二进制数
data1_dec = hex2dec(data1);


j=1 ;
%进制转换原理： FPGA定义每次发送一个72位的数据，数据末尾的低8位为17H数据用于区分间隔，高64位数据为有效的有符号数据
%              串口助手是按字节进行划分的，因此一帧数据是9个字节，其中第一个字节是17H，后8个字节为有效数据，对有效数据进行拼接组合
for i = 1:length(data1_dec)
    if((i>=10) && (i<(length(data1_dec)-9)) )
        if( (data1_dec(i) == 23) && ( (data1_dec(i-9) == 23) ) && ( (data1_dec(i+9) == 23) ) )
            if(data1_dec(i+8) < 128)    %若为正数
                %转换为有符号十进制正数
                real_data(j) = data1_dec(i+8)*16^14 + data1_dec(i+7)*16^12 + data1_dec(i+6)*16^10 + data1_dec(i+5)*16^8 +data1_dec(i+4)*16^6 + data1_dec(i+3)*16^4 + data1_dec(i+2)*16^2 + data1_dec(i+1)*16^0; 
                j=j+1 ;
            else %若为负数
                %转换为有符号十进制负数
                real_data(j) = ( data1_dec(i+8)*16^14 + data1_dec(i+7)*16^12 + data1_dec(i+6)*16^10 + data1_dec(i+5)*16^8 +data1_dec(i+4)*16^6 + data1_dec(i+3)*16^4 + data1_dec(i+2)*16^2 + data1_dec(i+1)*16^0 ) - 2^64; 
                j=j+1 ;
            end
        end
    elseif(i<10)
        if((data1_dec(i)==23) && ( (data1_dec(i+9) == 23) ) )
            if(data1_dec(i+8) < 128)
                real_data(j) = data1_dec(i+8)*16^14 + data1_dec(i+7)*16^12 + data1_dec(i+6)*16^10 + data1_dec(i+5)*16^8 +data1_dec(i+4)*16^6 + data1_dec(i+3)*16^4 + data1_dec(i+2)*16^2 + data1_dec(i+1)*16^0; 
                j=j+1 ;
            else
                real_data(j) = ( data1_dec(i+8)*16^14 + data1_dec(i+7)*16^12 + data1_dec(i+6)*16^10 + data1_dec(i+5)*16^8 +data1_dec(i+4)*16^6 + data1_dec(i+3)*16^4 + data1_dec(i+2)*16^2 + data1_dec(i+1)*16^0 ) - 2^64; 
                j=j+1 ;
            end
        end
    else
        if((data1_dec(i)==23) && ( (data1_dec(i-9) == 23) ) &&  ((i+8) < length(data1_dec)) )
            if(data1_dec(i+8) < 128)
                real_data(j) = data1_dec(i+8)*16^14 + data1_dec(i+7)*16^12 + data1_dec(i+6)*16^10 + data1_dec(i+5)*16^8 +data1_dec(i+4)*16^6 + data1_dec(i+3)*16^4 + data1_dec(i+2)*16^2 + data1_dec(i+1)*16^0; 
                j=j+1 ;
            else
                real_data(j) = ( data1_dec(i+8)*16^14 + data1_dec(i+7)*16^12 + data1_dec(i+6)*16^10 + data1_dec(i+5)*16^8 +data1_dec(i+4)*16^6 + data1_dec(i+3)*16^4 + data1_dec(i+2)*16^2 + data1_dec(i+1)*16^0 ) - 2^64; 
                j=j+1 ;
            end
        end
    end

end
real_data = real_data/2^32;
t1 = 0:1/Fs_real:(length(real_data)-1)/Fs_real;
figure(1)
subplot(2,1,2);
n5 = 1;
n6 = abs(Fs_real / 30 )*6;
plot(t1(n5:n6),real_data(n5:n6));
title('数字滤波后信号');
ylabel('滤波输出幅值');
xlabel('时间(s)');

% bit流信号
bit_data_30 = textread('D:\FPGA_MATLAB_Learning\CIC_Filter\波形生成\Bit_Stream_30_Cov.txt','%s')';
bit_data_30_dec = hex2dec(bit_data_30);
subplot(2,1,1)
n7 = 1 ;
n8 = abs(Fs / 30 )*6;  %包含6个周期
t4 = 0 : 1/Fs : abs((n8-n7)/Fs) ;
plot(t4,bit_data_30_dec(n7:n8));
title('Bit流');
ylabel('逻辑电平');
xlabel('时间(s)');




%% 实验部分第二个图，扫频信号经Sigma-Delta调制器输出Bit流，然后经过FPGA的CIC滤波后的数据

%按照字符串读取txt中的数据，读取的16进制数被存为1个元胞数组
%扫频信号，0.66s一个周期：0.2s~30Hz(1.2AMP)、0.02s~0Hz(0AMP)、0.2s~15Hz(1AMP)、0.02s~0Hz(0AMP)、0.2s~30Hz(0.6AMP)、0.02s~0Hz(0AMP)
data2 = textread('D:\FPGA_MATLAB_Learning\CIC_Filter\Data_Process\data11_sweep_303015_256000_512K_0.66s_1224_red.txt','%s')';
%将十六进制数转换为无符号二进制数
data2_dec = hex2dec(data2);

%进制转换原理： FPGA定义每次发送一个72位的数据，数据末尾的低8位为17H数据用于区分间隔，高64位数据为有效的有符号数据
%              串口助手是按字节进行划分的，因此一帧数据是9个字节，其中第一个字节是17H，后8个字节为有效数据，对有效数据进行拼接组合
j=1;
for i = 1:length(data2_dec)
    if((i>=10) && (i<(length(data2_dec)-9)))
        if( (data2_dec(i) == 23) && ( (data2_dec(i-9) == 23) ) && ( (data2_dec(i+9) == 23) ) )
            if(data2_dec(i+8) < 128)
                real_data2(j) = data2_dec(i+8)*16^14 + data2_dec(i+7)*16^12 + data2_dec(i+6)*16^10 + data2_dec(i+5)*16^8 +data2_dec(i+4)*16^6 + data2_dec(i+3)*16^4 + data2_dec(i+2)*16^2 + data2_dec(i+1)*16^0; 
                j=j+1 ;
            else
                real_data2(j) = ( data2_dec(i+8)*16^14 + data2_dec(i+7)*16^12 + data2_dec(i+6)*16^10 + data2_dec(i+5)*16^8 +data2_dec(i+4)*16^6 + data2_dec(i+3)*16^4 + data2_dec(i+2)*16^2 + data2_dec(i+1)*16^0) - 2^64; 
                j=j+1 ;
            end
        end
    elseif(i<10)
        if((data2_dec(i)==23) && ( (data2_dec(i+9) == 23) ) )
            if(data2_dec(i+8) < 128)
                real_data2(j) = data2_dec(i+8)*16^14 + data2_dec(i+7)*16^12 + data2_dec(i+6)*16^10 + data2_dec(i+5)*16^8 +data2_dec(i+4)*16^6 + data2_dec(i+3)*16^4 + data2_dec(i+2)*16^2 + data2_dec(i+1)*16^0;  
                j=j+1 ;
            else
                real_data2(j) = ( data2_dec(i+8)*16^14 + data2_dec(i+7)*16^12 + data2_dec(i+6)*16^10 + data2_dec(i+5)*16^8 +data2_dec(i+4)*16^6 + data2_dec(i+3)*16^4 + data2_dec(i+2)*16^2 + data2_dec(i+1)*16^0) - 2^64;  
                j=j+1 ;
            end
        end
    else
        if((data2_dec(i)==23) && ( (data2_dec(i-9) == 23) ) &&  ((i+8) < length(data2_dec)) )
            if(data2_dec(i+8) < 128)
                real_data2(j) = data2_dec(i+8)*16^14 + data2_dec(i+7)*16^12 + data2_dec(i+6)*16^10 + data2_dec(i+5)*16^8 +data2_dec(i+4)*16^6 + data2_dec(i+3)*16^4 + data2_dec(i+2)*16^2 + data2_dec(i+1)*16^0;  
                j=j+1 ;
            else
                real_data2(j) = ( data2_dec(i+8)*16^14 + data2_dec(i+7)*16^12 + data2_dec(i+6)*16^10 + data2_dec(i+5)*16^8 +data2_dec(i+4)*16^6 + data2_dec(i+3)*16^4 + data2_dec(i+2)*16^2 + data2_dec(i+1)*16^0) - 2^64;  
                j=j+1 ;
            end
        end
    end

end

real_data2 = real_data2 / 2^32 ;
%t2 = 0:1/Fs_real:(length(real_data2)-1)/Fs_real;
%截取5.0765~8.6765（3段滤波后信号）
n1 = 0.2065/(1/Fs_real) ;
n2 = 1.5265/(1/Fs_real) ;
t2 = 0 : 1/Fs_real : (n2-n1)/Fs_real ;
figure(2)
subplot(3,1,3)
plot(t2,real_data2(n1:n2));
title('数字滤波后信号');
ylabel('滤波输出幅值');
xlabel('时间(s)')
%开关周期信号
for i = 1:length(real_data2(n1:n2))
    if ( (1<=i && i<(0.2/(1/Fs_real))) || ((0.66/(1/Fs_real))<=i && i<(0.86/(1/Fs_real))) )  
        pulse1(i) = 1 ;
        pulse2(i) = 0;
        pulse3(i) = 0;
    elseif( (0.22/(1/Fs_real))<=i && i<(0.42/(1/Fs_real)) || ((0.88/(1/Fs_real))<=i && i<(1.08/(1/Fs_real))) )
       pulse1(i) = 0 ;
       pulse2(i) = 1;
       pulse3(i) = 0;
    elseif((0.44/(1/Fs_real))<=i && i<(0.64/(1/Fs_real)) || ((1.1/(1/Fs_real))<=i && i<(1.3/(1/Fs_real))))
        pulse1(i) = 0;
        pulse2(i) = 0;
        pulse3(i) = 1;
    else
        pulse1(i) = 0;
        pulse2(i) = 0;
        pulse3(i) = 0;
    end
end
subplot(3,1,2)
plot(t2,pulse1);
hold on
plot(t2,pulse2);
hold on 
plot(t2,pulse3);
legend('X axis','Y axis','Z axis');
title('开关切换信号');
ylabel('逻辑电平');
xlabel('时间(s)')

%bit流信号
bit_data = textread('D:\FPGA_MATLAB_Learning\CIC_Filter\波形生成\Bit_Stream_Sweep_3015__T0.66Cov.txt','%s')';
bit_data_dec = hex2dec(bit_data);
subplot(3,1,1)
n3 = 1 ;
n4 = 1.32/(1/Fs) ;
t3 = 0 : 1/Fs : (n4-n3)/Fs ;
plot(t3,bit_data_dec(n3:n4));
title('Bit流');
ylabel('逻辑电平');
xlabel('时间(s)');













