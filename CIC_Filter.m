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










