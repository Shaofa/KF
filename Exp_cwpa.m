clear all;
close all;
clc;

%% 系统和测量建模
dt = 0.05;
A = [1  0   dt  0   dt*dt/2  0;                     % 系统模型
     0  1   0   dt  0        dt*dt/2;
     0  0   1   0   dt       0;
     0  0   0   1   0        dt;
     0  0   0   0   1        0;
     0  0   0   0   0        1];
 
H = [1  0   0   0   0   0;                          % 测量模型
     0  1   0   0   0   0];

Q = [0.002    0       0       0       0       0;      % 过程噪声协方差矩阵
     0      0.002     0       0       0       0;
     0      0       0.002    0       0       0;
     0      0       0       0.002    0       0;
     0      0       0       0       0.002   0;
     0      0       0       0       0       0.002];
 
R = [1  0;                                      % 测量噪声协方差矩阵
     0  1];

X = [10 10 2 5 0 2]';                                % 初始状态

P = [1  0   0   0   0   0;                          % 初始误差协方差矩阵
     0  1   0   0   0   0;
     0  0   1   0   0   0;
     0  0   0   1   0   0;
     0  0   0   0   1   0;
     0  0   0   0   0   1];
 
N = size(A,1);                                          % 状态维度
M = size(H,1);                                          % 测量维度

%% 模拟测量值
n = 100;
z = zeros(M,n);         % 理论值
y = zeros(M,n);         % 带噪声的测量值
for i = 1 : n
    z(:,i) = H * X;
    X = A * X;
end
noisX0 = normrnd(0,R(1,1),1,n);
noisX1 = normrnd(0,R(2,2),1,n);
y(1,:) = z(1,:) + noisX0;
y(2,:) = z(2,:) + noisX1;

X = [y(1,1) y(2,1) 0 0 0 0 ]';  % 用测量值初始化状态值

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
errMeasureMean = [mean(z(1,:)-y(1,:)),mean(z(2,:)-y(2,:))]';
errMeasureRMS = [var(z(1,:)-y(1,:)), var(z(2,:)-y(2,:))]';
errSmoothMean = [mean(z(1,:)-xx(1,:)),mean(z(2,:)-xx(2,:))]';
errSmoothRMS = [var(z(1,:)-xx(1,:)), var(z(2,:)-xx(2,:))]';
fprintf('\n========================================\n');
fprintf('             \tX\t\t\tY\n');
fprintf('Measure Mean:\t%+.4f,\t%+.4f\n',errMeasureMean(1),errMeasureMean(2));
fprintf('Smooth  Mean:\t%+.4f,\t%+.4f\n\n',errSmoothMean(1),errSmoothMean(2));
fprintf('Measure  RMS:\t%+.4f,\t%+.4f\n',errMeasureRMS(1),errMeasureRMS(2));
fprintf('Smooth   RMS:\t%+.4f,\t%+.4f\n',errSmoothRMS(1),errSmoothRMS(2));
fprintf('========================================\n\n');

%% 绘图
% 位置
figure;
plot(z(1,:),z(2,:),'g-','linewidth',2);
hold on;
plot(y(1,:),y(2,:),'b+','linewidth',1);
hold on;
plot(xx(1,:),xx(2,:),'r-','linewidth',1);
legend('理论值','测量值','滤波值');
xlabel('x/m');
ylabel('y/m');
title('轨迹对比');
set(gca,'XGrid','on');
set(gca,'YGrid','on');

% x方向距离
figure;
subplot(2,1,1)
plot(z(1,:),'g-','linewidth',2);
hold on;
plot(y(1,:),'b+');
hold on;
plot(xx(1,:),'r-')
legend('理论值','测量值','滤波值');
xlabel('time/0.05sec');
ylabel('x/m');
title('x方向距离');
set(gca,'XGrid','on');
set(gca,'YGrid','on');
% x方向误差
subplot(2,1,2);
plot(xx(1,:)-z(1,:),'g-','linewidth',2);
hold on;
plot(xx(1,:)-y(1,:),'b-');
hold on;
legend('滤波误差','测量误差');
xlabel('time/0.05sec');
ylabel('x/m');
title('x方向误差');
set(gca,'XGrid','on');
set(gca,'YGrid','on');

% y方向距离
figure;
subplot(2,1,1)
plot(z(2,:),'g-','linewidth',2);
hold on;
plot(y(2,:),'b+');
hold on;
plot(xx(2,:),'r-')
legend('理论值','测量值','滤波值');
xlabel('time/0.05sec');
ylabel('y/m');
title('y方向距离');
set(gca,'XGrid','on');
set(gca,'YGrid','on');
% y方向误差
subplot(2,1,2);
plot(xx(2,:)-z(2,:),'g-','linewidth',2);
hold on;
plot(xx(2,:)-y(2,:),'b-');
hold on;
legend('滤波误差','测量误差');
xlabel('time/0.05sec');
ylabel('y/m');
title('y方向误差');
set(gca,'XGrid','on');
set(gca,'YGrid','on');



