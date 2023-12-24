%
%    代码功能：将FPGA发送至串口助手的数据复制到txt文本，在Matlab中读取txt文本数据
%             首先对数据进行进制转换，从有符号的十六进制数转换为有符号的十进制数
%    修改日期：2023.12.21     
%    作者：张启元
%    地点：东南大学
%% 
clc;
clear all;
%按照字符串读取txt中的数据，读取的16进制数被存为1个元胞数组
data1 = textread('D:\FPGA_MATLAB_Learning\CIC_Filter\Data_Process\data6_30Hz_256000_512K_1221_red.txt','%s')';
data2 = textread('D:\FPGA_MATLAB_Learning\CIC_Filter\Data_Process\data10_sweep_303015_256000_512K_1.2s_1224_red.txt','%s')';
%将十六进制数转换为无符号二进制数
data1_dec = hex2dec(data1);
data2_dec = hex2dec(data2);

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
figure(1)
plot(real_data);
figure(2)
plot(real_data2);

