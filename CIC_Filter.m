%% 参考链接：https://zhuanlan.zhihu.com/p/455797158

%% 画出梳状滤波器的频率响应图 
%  求Z域传递函数的零极点与幅频、相频曲线 
% H = 1 - Z^(-R*M)
% R = 1;
% M = 1;

b = [1 0 0 0 0 0 0 0 -1];
a = 1;

figure(1);
zplane(b,a);
[h,w] = freqz(b,a);
figure(2);
subplot(2,1,1);
plot(w/pi,20*log10(abs(h)));
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('20*log10(|H(e^j^\omega)|)');
% axis([0,1,0,2.5])
subplot(2,1,2);
plot(w/pi,angle(h));
xlabel('\omega^pi');
ylabel('|H(e^j^\omega)|');
% axis([0,1,0,2.5])

%% 画出积分器的频率响应图
% H = 1/（1 - Z^(-1)）

b1 = 1;
a1 = [1 -1];

figure(1);
zplane(b1,a1);
[h1,w1] = freqz(b1,a1);
figure(2);
subplot(2,1,1);
plot(w1/pi,20*log10(abs(h1)));
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('20*log10(|H(e^j^\omega)|)');
% axis([0,1,0,2.5])
subplot(2,1,2);
plot(w1/pi,angle(h1));
xlabel('\omega^pi');
ylabel('|H(e^j^\omega)|');
% axis([0,1,0,2.5])


%% CIC幅度谱
% |H(f)|=|sin(pi*R*M*f)/sin(pi*f)|^N
R = 7 ;
N = 3 ;
M = 1 ;
f = 0: 0.001 :0.5 ;
h2 = abs(sin(pi*R*M*f)./sin(pi*f)).^N ;
figure
plot(f,20*log10(h2));
xlabel('Normalized Frequency(cycles/sample)');
ylabel('Magnitude(dB)');

%% CIC滤波器
%Z域传递函数： H(z) =[(1-z^-10) / (1 - z^-1)]^Q 
b = [1 0 0 0 0 0 0 0 0 0 -1];
a = [1 -1];
figure(1);
zplane(b,a);

% 数字滤波器频率响应
[h,w] = freqz(b,a,1024,'whole');
% 没理解这行代码的实际物理意义
h(1,1) = length(b)-1;
% 平移零频分量，然后绘制以零为中心的频谱
h_shift = fftshift(h);
n = length(w);
% zero-centered frequency range
w_shift = (-n/2:n/2-1)*(1/n); 
% plot(w_shift,abs(h_shift))

%观察级联个数对旁瓣衰减的影响
figure(2);
% 多少个级联
Q = 1; 
subplot(2,2,1);
plot(w_shift,20*log10(abs(h_shift).^Q))
peaks = findpeaks(20*log10(abs(h_shift).^Q));
xlabel('Normalized frequency(cycles/sample)');
ylabel('|H(e^j^\omega))|(dB)');
title('Q=1');
grid on;
Q = 2; 
subplot(2,2,2);
plot(w_shift,20*log10(abs(h_shift).^Q))
peaks = findpeaks(20*log10(abs(h_shift).^Q));
xlabel('Normalized frequency(cycles/sample)');
ylabel('|H(e^j^\omega))|(dB)');
title('Q=2');
grid on;
Q = 3; 
subplot(2,2,3);
plot(w_shift,20*log10(abs(h_shift).^Q))
peaks = findpeaks(20*log10(abs(h_shift).^Q));
xlabel('Normalized frequency(cycles/sample)');
ylabel('|H(e^j^\omega))|(dB)');
title('Q=3');
grid on;
Q = 4; 
subplot(2,2,4);
plot(w_shift,20*log10(abs(h_shift).^Q))
peaks = findpeaks(20*log10(abs(h_shift).^Q));
xlabel('Normalized frequency(cycles/sample)');
ylabel('|H(e^j^\omega))|(dB)');
title('Q=4');
grid on;
































