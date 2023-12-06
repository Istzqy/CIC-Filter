clear all
 
t0 = clock ;  %clock 的值为程序运行的时间
%*****************************************
% Variable global 全局变量
%*****************************************
bw=1000 ;        % Base band 基频宽度
R =256 ;         % sampling rate 过采样值，即OSR 
                 %过采样率越高，SNR越高，但是低频的噪声会越大
Fs = 2*bw*R;      %Oversampling frequency 过采样的频率
Ts = 1/Fs ;    
N = 2^21 ;       %Samples number  采样点数
NFFT=  2^16 ;               %采样点数会影响输出信号的低频信号噪声，同样也会影响SNR的大小
Ntransient =10 ;
Fin = 30;       % 输入信号的频率在100Hz时，PSD的低频噪声在-160~-180dB
                % 输入信号的频率在90Hz时，PSD的低频噪声在-180~-190dB
                % 输入信号的频率在30Hz时，PSD的低频噪声在-100~-120dB
finrad = Fin*2*pi;

%***********************%
% 加速度计结构
%***********************%
k = 1222;
n=0.08;
m=5.13e-6;
ws=sqrt(k/m);

%***********************%
% KT/C noise and op-amp non-idealities
%***********************%

b=1;  
b2=1;
nb1=1/1000;
k = 1.38e-23 ;  % 玻尔兹曼常数
Temp = 300 ;    % 常温开氏温度
C= 10e-12;      % 积分电容
% C= 4e-12;
alfa=(1e3-1)/1e3; %非理想运放有限增益 alfa=(A-1)/A -> ideal op-amp alfa=1;
%alfa=1;
GBW=150e6;    % 增益带宽积
sr=20e6;      %压摆率 转换速率
noise1 =10e-5; % 1st int.output noise std.dev.[Vrms]
%delta = 4e-9 ; % random sampling Jitter
delta = 4e-9;
Amax=8;   %运放最大输出电压



%***********************%
% 调制器结构系数
%***********************%

Kcv=4e12;
Kvf = 1.323e-4;
GAIN = 50; %这个参数会影响各个积分器输出的量级

a=0.9;
Amp1 = 10*5.13e-6;          % 输入信号幅值
Vref = 1  ;  %比较器的参考基准

 
g1 = 0.4 ; %增益参数
g2 = 0.2  ;
% % % g1 = 0.3778  ; %增益参数
% % % g2 =   0.3761 ;
g3 = 4    ;
g4 = 0.9 ;
g5=  0.7  ;
% g1 = 0.3778  ; %增益参数
% g2 =   0.3761 ;
% g3 =  8.7987 ;
% g4 =  0.9538 ;
% g5=   0.8149 ;
% g1 = 0.0767   ; %增益参数
% g2 =   0.2205 ;
% g3 =  7.5386  ;
% g4 =  0.5747  ;
% g5=  0.3952   ;
  
   %15.2136    0.8364    0.2908
   %15.2102    0.3778    0.3761
   %15.2135    0.2472    0.3853
   %15.2136    0.1337    0.3071
   %15.0000  -18.5715   13.9652   17.3597    7.1494
   %15.2136    0.0830    0.6616    5.1698    1.7105


%5.1500    0.0089    0.8149    0.1405    8.7987    0.9538
%15.2128    0.0767    0.2205    0.3952    7.5386    0.5747
%15.2135    0.6623    0.5028    0.5848    7.6658    1.7216


% *******************************************************************
% Open Simulink diagram first  打开simulink 的仿真模型 bp6
% *******************************************************************
% 
    options = simset('RelTol',1e-4,'MaxStep',1/Fs);
   % sim('four_CIFF_EM_sim',(N+Ntransient)/Fs,options);  % Starts Simmulink simulation 
   sim('four_CIFF_EM_sim_noise',(N+Ntransient)/Fs,options); 
    % ******************************
    % Calculates SNR and PSD of the bit_stream and of the signal
    % ******************************
    w =hann(N); %定义窗函数
     f = Fin/Fs; % Normalized signal frequency 标准信号频率
    fB = N*(bw/Fs); % Base-band frequency bins 基带频率位数
    fBL=N*(1/4-bw/(2*Fs)); % Lower limit base-band frequency bins 1/4处一边一半
    fBH=N*(1/4+bw/(2*Fs)); % Higher limit base-band frequency bins 1/4处一边一半
    
    yy1 =yout2(2+Ntransient:1+N+Ntransient)';    
    ptot =zeros(1,N);
    
    [snr,ptot]=calcSNR(yy1(1:N),f,fB,w,N,Vref); 
    Rbit=(snr-1.76)/6.02; % Equivalent resolution in bits 根据公式大概估计有效位数 

%    AAmp1 = [0.001 0.01 0.1 1 10 11 12 13 14 15 16 17 18 19 20]*5.13e-6;
% 
%   for i=1:length(AAmp1)
%     Amp1=AAmp1(i) ;
%     options = simset('RelTol',1e-4,'MaxStep',1/Fs);
%     sim('four_CIFF_EM_sim',(N+Ntransient)/Fs,options);  % Starts Simmulink simulation 
%     w =hann(N); %定义窗函数
%     f = Fin/Fs; % Normalized signal frequency 标准信号频率
%     yy1 =yout2(2+Ntransient:1+N+Ntransient)';    
%     ptot =zeros(1,N);
%     
%     [snr(i),ptot]=calcSNR(yy1(1:N),f,fB,w,N,Vref); 
%     Rbit(i)=(snr(i)-1.76)/6.02; % Equivalent resolution in bits 根据公式大概估计有效位数 
% 
%   end
%   
%   plot(AAmp1/(5.13e-6),snr) 
%  
%     
    
    
%     yy2 =yout(1:NFFT)';
%     ptot2 =zeros(1,NFFT);
%     [snr2,ptot2]=calcSNR(yy2(1:N),f,fB,w,NFFT,Vref); 
%     Rbit2=(snr2-1.76)/6.02; % Equivalent resolution in bits 根据公式大概估计有效位数 
% 

    
    
    
    
    
    
    
    
    
    
    
    
% figure(1);
% clf;
% plot(linspace(0,Fs/2,N/2),ptot(1:N/2),'r');
% grid on;
% title('PSD of a 2nd-Order Sigma-Delta modulator')
% xlabel('Frequency [Hz]')
% ylabel('PSD [dB]')
% axis([0 Fs/2 -200 0]);
% 
% figure(2);
% clf;
% semilogx(linspace(0,Fs/2,N/2),ptot(1:N/2),'r');
% grid on;
% title('PSD of a 2nd-Order Sigma-Delta modulator')
% xlabel('Frequency [Hz]')
% ylabel('PSD [dB]')
% axis([0 Fs/2 -200 0]);

figure(3);
clf;
semilogx(linspace(0,Fs/2,N/2),ptot(1:N/2),'r');
grid on;
title('PSD of a Fourth-Order CIFF Sigma-Delta modulator')
xlabel('Frequency [Hz]')
ylabel('PSD [dB]')
axis([(Fin-bw/2) (Fin+bw/2) -200 0]);
grid on;
hold off;
text_handle = text(floor(Fin),-40,sprintf('SNR = %4.1fdB @OSR = %d\n',snr,R));
text_handle = text(floor(Fin),-60,sprintf('Rbit = %2.2fbits @OSR = %d\n',Rbit,R));
s1=sprintf('   SNR = %1.3f',snr);
s2=sprintf('   Simulation time=%1.3f min',etime(clock,t0)/60);
disp(s1)
disp(s2)

% figure(4)
% nbins=200;
% [bin1,xx1]=histo(y1,nbins);
% [bin2,xx2]=histo(y2,nbins);
% clf;
% subplot(1,2,1),plot(xx1,bin1)
% grid on;
% title('First Intergrator Output')
% xlabel('Voltage [V]')
% ylabel('Occurrences')
% subplot(1,2,2),plot(xx2,bin2)
% grid on
% title('Second Intergrator Output')
% xlabel('Voltage [V]')
% ylabel('Occurrences')  