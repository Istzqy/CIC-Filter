%My_E6_10_HalfFilterMatlab.m
%利用Matlab提供的firhalfband函数设计阶数为16、通阻带容限为0.0001的半带滤波器。
%仿真测试滤波前后的信号时域图，绘制滤波器的频率响应特性图。

%设计半带滤波器
n = 18; %阶数为16
dev = 0.001;   %通阻带容限
b = firhalfband(n,dev,"dev");%得到半带滤波器系数

%设计输入信号
f = 500;   %信号频率为1KHZ
Fs = 20*f;  %抽样频率为20KHZ
t = 0:1/Fs:0.05;%采样时长
si = sin(2*pi*f*t);  %正弦信号

%使用半带滤波器滤波,并抽取
D = 2;  %抽取倍数 
s = filter(b,1,si);  %得到滤波信号
s = s/max(s);       %归一化处理
Ds = s(1:D:length(s));  %得到抽样信号

%绘图
x = 0:1:100;  %绘100个点
x = x/Fs; %1/Fs为周期，也就是时间 x*T就是采样时间 x也就是每个点采样的时间
Dx = x(1:D:length(x));  %抽样信号的时间
si = si(1:length(x));
Ds = Ds(1:length(Dx));
figure(1)
subplot(211);stem(x,si);title("MATLAB仿真滤波前信号波形");
subplot(212);stem(Dx,Ds);title("MATLAB仿真滤波后信号波形");
figure(2);freqz(b);

