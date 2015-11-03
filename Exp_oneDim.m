clear all;
close all;
clc;

%% 系统和测量建模
Q = 0.0001;  	% 过程噪声协方差矩阵
 
R = 0.11;    	% 测量噪声协方差矩阵

X = 2;           % 初始状态



%% 模拟测量值
n = 200;
z = zeros(1,n);         % 理论值测量值
y = zeros(1,n);         % 带噪声的测量值
for k = 1 : n
    z(:,k) = X;
end
nois = normrnd(0,sqrt(R),1,n);
y(1,:) = z(1,:) + nois;

%% 滤波
X = -5;         % 初始状态
P = 0.5;       	% 初始误差协方差矩阵
xx = zeros(1,n);
PP = zeros(1,n);

for k = 1 : n
    P = P + Q;
    S = P + R;
    K = P / S;
    X = X + K*(y(k) -X);
    P = P - K*S*K;
    xx(k) = X;
    PP(k) = P;
end

%% 误差统计
errMeasureMean = mean(z(1,:)-y(1,:));
errMeasureRMS = var(z(1,:)-y(1,:));
errSmoothMean = mean(z(1,:)-xx(1,:))';
errSmoothRMS = var(z(1,:)-xx(1,:))';
fprintf('\n========================================\n');
fprintf('Measure Mean:\t%+.4f\n',errMeasureMean(1));
fprintf('Smooth  Mean:\t%+.4f\n\n',errSmoothMean(1));
fprintf('Measure  RMS:\t%+.4f\n',errMeasureRMS(1));
fprintf('Smooth   RMS:\t%+.4f\n',errSmoothRMS(1));
fprintf('========================================\n\n');


%% 绘图
%
figure;
subplot(2,1,1)
plot(z(1,:),'g-','linewidth',2);
hold on;
plot(y(1,:),'b+');
hold on;
plot(xx(1,:),'r-')
legend('理论值','测量值','滤波值');
xlabel('time');
title('随机常量');
set(gca,'XGrid','on');
set(gca,'YGrid','on');

% 误差
subplot(2,1,2);
plot(xx(1,:)-z(1,:),'g-','linewidth',2);
hold on;
plot(xx(1,:)-y(1,:),'b-');
hold on;
legend('滤波误差','测量误差');
xlabel('time');
title('随机常量误差');
set(gca,'XGrid','on');
set(gca,'YGrid','on');

figure;
plot(PP);
title('Pk');
xlabel('time');

%% 滤波
X = -5;         % 初始状态
P = 1;       	% 初始误差协方差矩阵
xx = zeros(1,n);
PP = zeros(1,n);

for k = 1 : n
    P = P + Q;
    S = P + R;
    K = P / S;
    X = X + K*(y(k) -X);
    %P = P - K*P*K;
    P = P - K*S*K;
    xx(k) = X;
    PP(k) = P;
end

%% 误差统计
errMeasureMean = mean(z(1,:)-y(1,:));
errMeasureRMS = var(z(1,:)-y(1,:));
errSmoothMean = mean(z(1,:)-xx(1,:))';
errSmoothRMS = var(z(1,:)-xx(1,:))';
fprintf('\n========================================\n');
fprintf('Measure Mean:\t%+.4f\n',errMeasureMean(1));
fprintf('Smooth  Mean:\t%+.4f\n\n',errSmoothMean(1));
fprintf('Measure  RMS:\t%+.4f\n',errMeasureRMS(1));
fprintf('Smooth   RMS:\t%+.4f\n',errSmoothRMS(1));
fprintf('========================================\n\n');


%% 绘图
%
figure;
subplot(2,1,1)
plot(z(1,:),'g-','linewidth',2);
hold on;
plot(y(1,:),'b+');
hold on;
plot(xx(1,:),'r-')
legend('理论值','测量值','滤波值');
xlabel('x/m');
ylabel('y/m');
title('x方向距离');
set(gca,'XGrid','on');
set(gca,'YGrid','on');

% 误差
subplot(2,1,2);
plot(xx(1,:)-z(1,:),'g-','linewidth',2);
hold on;
plot(xx(1,:)-y(1,:),'b-');
hold on;
legend('滤波误差','测量误差');
xlabel('time/0.05sec');
ylabel('x/m');
title('x方向距误差');
set(gca,'XGrid','on');
set(gca,'YGrid','on');

figure;
plot(PP);


