% Power Spectral Density Estimates Using FFT
% pr8_2_1 
%% �����źŹ������ܶȣ��ֱ������ַ���
clear all; clc; close all;

randn('state',0);                    % �������ʼ��
Fs = 1000;                           % ����Ƶ��
t = 0:1/Fs:1-1/Fs;                   % ʱ��̶�
f1=50; f2=120;                       % �������ҷ���Ƶ��
x=cos(2*pi*f1*t)+3*cos(2*pi*f2*t)+randn(size(t)); % �ź�
% ʹ��FFT
N = length(x);                       % x����
xdft = fft(x);                       % FFT
xdft = xdft(1:N/2+1);                % ȡ��Ƶ��
psdx = (1/(Fs*N)) * abs(xdft).^2;    % ���㹦�����ܶ�
psdx(2:end-1) = 2*psdx(2:end-1);     % ��2(2:end-1)
freq = 0:Fs/length(x):Fs/2;          % Ƶ�ʿ̶�
subplot 211
plot(freq,10*log10(psdx),'k')        % ȡ������ͼ
grid on; xlim([0 Fs/2]);
title('��FFT������ͼ')
xlabel('Ƶ��/Hz')
ylabel('�������ܶ�/(dB/Hz)')
% ����periodogram����
[Pxx,f]=periodogram(x,rectwin(length(x)),N,Fs);
subplot 212
plot(freq,10*log10(Pxx),'k');        % ȡ������ͼ
grid on; xlim([0 Fs/2]);
title('����periodogram����������ͼ')
xlabel('Ƶ��/Hz')
ylabel('�������ܶ�/(dB/Hz)')
mxerr = max(psdx'-Pxx)               % �����ַ���������ֵ
set(gcf,'color','w'); 

%% ����ȷ���
clear all;
clc ;
close all;

rng default
Fi = 2500;
Fs = 48e3;
N = 1024;
x = sin(2*pi*Fi/Fs*(1:N)) + 0.00001*randn(1,N);

w = kaiser(numel(x),38);
w1 = hann(numel(x));
[Pxx, F] = periodogram(x,w,numel(x),Fs);
kai='������';
disp(kai);
SNR = snr(Pxx,F,'psd')
[Pxx1, F1] = periodogram(x,w1,numel(x),Fs);
han='������';
disp(han)
SNR = snr(Pxx1,F1,'psd')





