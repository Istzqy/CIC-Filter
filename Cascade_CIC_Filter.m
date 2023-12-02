 % 设计方法2： 设计未做单位增益CIC滤波器
 % hcic = design(fdesign.decimator(R,'cic',D, Fp, Astp, Fs),'SystemObject',true);
 % cic_comp = design(fdesign.ciccomp(hcic.DifferentialDelay, ...
 %             hcic.NumSections,Fp,Fstp,Ap,Astp,Fs/R), 'SystemObject',true);
 % 参数设置
 %%
%  clc;
%  clear;
%  Fs = 2e6;      % sample rate
%  R = 128;          % decimator factor
%  D = 1;          % differential delay
%  Fp = 2e3;       % pass band
%  Fstp = 13.625e3;     % stop band
%  Ap = 0.1;       % attenuation in pass band
%  Astp = 40;      % attenuation in stop band
% 
%  % 设计方法1： 设计单位增益CIC滤波器
%  d1 = fdesign.decimator(R,'cic',D, Fp, Astp, Fs);
%  hcic = design(d1);
%  H1 = cascade(1/gain(hcic),hcic);
%  d2 = fdesign.ciccomp(hcic.DifferentialDelay, ...
%              hcic.NumberOfSections,Fp,Fstp,Ap,Astp,Fs/R);
%  cic_comp = design(d2);
%  fvtool(H1,cic_comp,cascade(H1,cic_comp),'ShowReference','off','Fs',[Fs Fs/R Fs]) % 未做归一化处理
%  legend('CIC Decimator','CIC Compensator','Resulting Cascade Filter');


%%
%  Fs = 2e6;      % sample rate
%  R = 128;          % decimator factor
%  D = 1;          % differential delay
%  N = 5;          % number of stage
%  Fp = 0.002;      % pass band
%  Fstp = 0.058;   % stop band
%  Ap = 0.1;       % attenuation in pass band
%  Astp = 60;      % attenuation in stop band​
%  CICDecim = dsp.CICDecimator(R, D, N);
%  CICCompDecim = dsp.CICCompensationDecimator(CICDecim,...
%      'DecimationFactor',2,'PassbandFrequency',Fp,...
%      'StopbandFrequency',Fstp,'SampleRate',Fs/R);
%  fvtool(CICDecim,CICCompDecim,...
%  cascade(CICDecim,CICCompDecim),'ShowReference','off','Fs',[Fs Fs/R Fs])
%  legend('CIC Decimator','CIC Compensator','Resulting Cascade Filter');

%%
% fs = 2e6;		%采样率
% f1 = 10;		%信号频率1
% f2 = 20;		%信号频率2
% n = 4096;		%采样点数
% t = 0:1/fs:(n-1)/fs;
% x_in = cos(2*pi*f1*t) + 2*cos(2*pi*f2*t) + 1i*sin(2*pi*f1*t) + 1i*2*sin(2*pi*f2*t);    %复数信号,提供两个不同的频率10Hz与20Hz
% 
% a = [1,-1];     %梳状滤波器系数
% b = [1,-1];		%积分器系数
% 
% %五级级联积分器
% c1 =  filter(1,b,x_in);	%x_in为输入信号
% c2 =  filter(1,b,c1);
% c3 =  filter(1,b,c2);
% c4 =  filter(1,b,c3);
% c5 =  filter(1,b,c4);
% 
% d = downsample(c5,4);	%对信号进行四倍抽取
% 
% %五级级联梳状滤波器
% e1 = filter(a,1,d);
% e2 = filter(a,1,e1);
% e3 = filter(a,1,e2);
% e4 = filter(a,1,e3);
% y_out = filter(a,1,e4);	%y_out为CIC输出
% 
% figure
% subplot(211)
% f = 0:200/4096:(4096-1)*200/4096;   %归一化处理
% plot(f,20*log10(abs(fft(x_in))),'b');
% title('抽取前fft变换');xlabel('f/Hz');
% f_d = 0:12.5/1024:(1024-1)*12.5/1024;   %归一化处理
% subplot(212)
% plot(f_d,20*log10(abs(fft(y_out))),'r');
% title('抽取后fft变换');xlabel('f/Hz');


%% CIC滤波器设计（级联数Q = 5，抽取因子M = 128 ）
clc;
clear;
M = 128;
b = [1 repelem(0,M-1) -1];
a = [1 -1];

figure(1);
%零极点图
zplane(b,a);

%数字滤波器频率响应
[h,w] = freqz(b,a,4096);
%为了单位表示方便
w = w/pi;
%观察级联个数对旁瓣衰减的影响

figure(2);
% 绘制4张子图方式多少个级联
% Q = 1; 
% subplot(2,2,1);
% plot(w_shift_plus,20*log10(abs(h_shift).^Q))
% peaks = findpeaks(20*log10(abs(h_shift).^Q));
% xlabel('Normalized frequency(cycles/sample)');
% ylabel('|H(e^j^\omega))|(dB)');
% title('Q=1');
% grid on;
% Q = 2; 
% subplot(2,2,2);
% plot(w_shift,20*log10(abs(h_shift).^Q))
% peaks = findpeaks(20*log10(abs(h_shift).^Q));
% xlabel('Normalized frequency(cycles/sample)');
% ylabel('|H(e^j^\omega))|(dB)');
% title('Q=2');
% grid on;
% Q = 3; 
% subplot(2,2,3);
% plot(w_shift,20*log10(abs(h_shift).^Q))
% peaks = findpeaks(20*log10(abs(h_shift).^Q));
% xlabel('Normalized frequency(cycles/sample)');
% ylabel('|H(e^j^\omega))|(dB)');
% title('Q=3');
% grid on;
% Q = 4; 
% subplot(2,2,4);
% plot(w_shift,20*log10(abs(h_shift).^Q))
% peaks = findpeaks(20*log10(abs(h_shift).^Q));
% xlabel('Normalized frequency(cycles/sample)');
% ylabel('|H(e^j^\omega))|(dB)');
% title('Q=4');
% grid on;
Q = 1; 
plot(w,20*log10(abs(h).^Q));
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('|H(e^j^\omega))|(dB)');
hold on;
Q = 2; 
plot(w,20*log10(abs(h).^Q));
hold on;
Q = 3; 
plot(w,20*log10(abs(h).^Q));
hold on;
Q = 4; 
plot(w,20*log10(abs(h).^Q));
hold on;
Q = 5; 
plot(w,20*log10(abs(h).^Q));
legend('Q=1','Q=2','Q=3','Q=4','Q=5');
grid on;



%% ISOP二阶补偿器设计
clear;
clc;

figure(1);
 for c=-2.1:-2:-11
    b = [1 c 1];
    a = [abs(c+2)];
    %zplane(b,a);
    % % 数字滤波器频率响应
    [h,w] = freqz(b,a,4096);
    n = length(w);
    w=w/pi;
    plot(w,20*log10(abs(h)));
    hold on;
 end
legend('C=-3','C=-5','C=-7','C=-9','C=-11');
grid on;
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('|H(e^j^\omega))|(dB)');


%% CIC滤波器（级联数Q = 5，抽取因子M = 128 ） + ISOP二阶补偿器

clc;
clear;
% CIC设计
M = 128;
b = [1 repelem(0,M-1) -1];
a = [1 -1];
%数字滤波器频率响应
[Hcic,w] = freqz(b,a,4096);
%为了单位表示方便
w = w/pi;
%级联数为5的CIC幅频特性
Q = 5;
figure(1);
plot(w,20*log10(abs(Hcic).^Q));
hold on ;


%ISOP设计
c = -2.0001;
b1 = [1 c 1];
a1 = [abs(c+2)];
% % 数字滤波器频率响应
[Hisop,wisop] = freqz(b1,a1,4096);

wisop = wisop /pi;
plot(w,20*log10(abs(Hisop)));
hold on ;

plot(w,20*log10(abs(Hisop).*(abs(Hcic).^Q)));

legend('CIC','ISOP','CIC+ISOP');
grid on;
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('|H(e^j^\omega))|(dB)');



















    







