function createfigure(X1, YMatrix1)
%CREATEFIGURE(X1, YMatrix1)
%  X1:  plot x 数据的向量
%  YMATRIX1:  plot y 数据的矩阵

%  由 MATLAB 于 03-Dec-2023 19:56:54 自动生成

% 创建 figure
figure1 = figure('Color',[1 1 1]);

% 创建 axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% 使用 plot 的矩阵输入创建多个 line 对象
plot1 = plot(X1,YMatrix1,'LineWidth',2,'Parent',axes1);
set(plot1(1),'DisplayName','Q=1',...
    'Color',[0 0.447058823529412 0.741176470588235]);
set(plot1(2),'DisplayName','Q=3',...
    'Color',[0.466666666666667 0.674509803921569 0.188235294117647]);
set(plot1(3),'DisplayName','Q=5',...
    'Color',[0.717647058823529 0.274509803921569 1]);

% 创建 ylabel
ylabel('|H(e^j^\omega))|(dB)','FontWeight','bold','FontName','Arial');

% 创建 xlabel
xlabel('Normalized Frequency (\times\pi rad/sample)','FontWeight','bold',...
    'FontName','Arial');

box(axes1,'on');
grid(axes1,'on');
hold(axes1,'off');
% 设置其余坐标区属性
set(axes1,'FontName','Arial','FontSize',14,'FontWeight','bold','XColor',...
    [0 0 0],'YColor',[0 0 0],'ZColor',[0 0 0]);
% 创建 legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.797873345138792 0.726049319059492 0.095404304776377 0.153020017244839],...
    'FontSize',14);

