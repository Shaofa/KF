%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 使用IVQ-905雷达实测数据
% 数据场景为8字形行走
% 数据源格式：[time range angle speed]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
clc;

%% 系统和测量建模
dt = 0.048;
A = [1  dt  dt*dt/2  0       0       0;             % 系统模型
     0  1   dt       0       0       0;
     0  0   1        0       0       0;
     0  0   0        1       dt      dt*dt/2;
     0  0   0        0       1       dt;
     0  0   0        0       0       1];
 
H = [1  0   0   0   0   0;                          % 测量模型
     0  1   0   0   0   0;
     0  0   0   1   0   0;
     0  0   0   0   1   0];

Q = [0.2    0       0       0       0       0;      % 过程噪声协方差矩阵
     0      0.2     0       0       0       0;
     0      0       0.002    0       0       0;
     0      0       0       0.2    0       0;
     0      0       0       0       0.2   0;
     0      0       0       0       0       0.02];
 
R = [10   0    0   0;                       % 测量噪声协方差矩阵
     0   10  0   0;
     0   0    10   0;
     0   0    0   10];

P = [1  0   0   0   0   0;                          % 初始误差协方差矩阵
     0  1   0   0   0   0;
     0  0   1   0   0   0;
     0  0   0   1   0   0;
     0  0   0   0   1   0;
     0  0   0   0   0   1];
 
N = size(A,1);                                          % 状态维度
M = size(H,1);                                          % 测量维度

%% 读测量值
measure= importdata('data/filter_in.data')';
n = size(measure,2);
y = zeros(M,n);                 % 带噪声的测量值
for i=1:n
    y(1,i) = measure(2,i) * sin(measure(3,i) * pi / 180);
    y(2,i) = measure(4,i) * sin(measure(3,i) * pi / 180);
    y(3,i) = measure(2,i) * cos(measure(3,i) * pi / 180);
    y(4,i) = measure(4,i) * cos(measure(3,i) * pi / 180);
end
X = [y(1,1) y(2,1) 0 y(3,1) y(4,1) 0 ]';  % 用测量值初始化状态值

%% 滤波
xx = zeros(N,n);
PP = zeros(N,N,n);

for i = 1 : n
    [X, P] = kf_predict(X, P, A, Q);
    [X, P] = kf_update(X, P, y(:,i),H, R);
    xx(:,i) = X;
    PP(:,:,i) = P;
end

%% 误差统计
% errMeasureMean = [mean(z(1,:)-y(1,:)),mean(z(2,:)-y(2,:))]';
% errMeasureRMS = [var(z(1,:)-y(1,:)), var(z(2,:)-y(2,:))]';
% errSmoothMean = [mean(z(1,:)-xx(1,:)),mean(z(2,:)-xx(2,:))]';
% errSmoothRMS = [var(z(1,:)-xx(1,:)), var(z(2,:)-xx(2,:))]';
% fprintf('\n========================================\n');
% fprintf('             \tX\t\t\tY\n');
% fprintf('Measure Mean:\t%+.4f,\t%+.4f\n',errMeasureMean(1),errMeasureMean(2));
% fprintf('Smooth  Mean:\t%+.4f,\t%+.4f\n\n',errSmoothMean(1),errSmoothMean(2));
% fprintf('Measure  RMS:\t%+.4f,\t%+.4f\n',errMeasureRMS(1),errMeasureRMS(2));
% fprintf('Smooth   RMS:\t%+.4f,\t%+.4f\n',errSmoothRMS(1),errSmoothRMS(2));
% fprintf('========================================\n\n');

%% 绘图
% 位置
figure;
plot(y(1,:),y(3,:),'b+','linewidth',1);
hold on;
plot(xx(1,:),xx(4,:),'r-','linewidth',1);
legend('测量值','滤波值');
xlabel('x/m');
ylabel('y/m');
title('轨迹对比');
set(gca,'XGrid','on');
set(gca,'YGrid','on');

% x方向距离
figure;
subplot(2,1,1)
plot(y(1,:),'b');
hold on;
plot(xx(1,:),'g','linewidth',2);
legend('测量值','滤波值');
xlabel('time/0.05sec');
ylabel('x/m');
title('x方向距离');
set(gca,'XGrid','on');
set(gca,'YGrid','on');
% y方向距离
subplot(2,1,2)
plot(y(3,:),'b');
hold on;
plot(xx(4,:),'g','linewidth',2);
legend('测量值','滤波值');
xlabel('time/0.05sec');
ylabel('y/m');
title('y方向距离');
set(gca,'XGrid','on');
set(gca,'YGrid','on');



