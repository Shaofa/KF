%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ʹ��IVQ-905�״�ʵ������
% ���ݳ���Ϊ8��������
% ����Դ��ʽ��[time range angle speed]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
clc;

%% ϵͳ�Ͳ�����ģ
dt = 0.048;
A = [1  dt  dt*dt/2  0       0       0;             % ϵͳģ��
     0  1   dt       0       0       0;
     0  0   1        0       0       0;
     0  0   0        1       dt      dt*dt/2;
     0  0   0        0       1       dt;
     0  0   0        0       0       1];
 
H = [1  0   0   0   0   0;                          % ����ģ��
     0  1   0   0   0   0;
     0  0   0   1   0   0;
     0  0   0   0   1   0];

Q = [0.2    0       0       0       0       0;      % ��������Э�������
     0      0.2     0       0       0       0;
     0      0       0.002    0       0       0;
     0      0       0       0.2    0       0;
     0      0       0       0       0.2   0;
     0      0       0       0       0       0.02];
 
R = [10   0    0   0;                       % ��������Э�������
     0   10  0   0;
     0   0    10   0;
     0   0    0   10];

P = [1  0   0   0   0   0;                          % ��ʼ���Э�������
     0  1   0   0   0   0;
     0  0   1   0   0   0;
     0  0   0   1   0   0;
     0  0   0   0   1   0;
     0  0   0   0   0   1];
 
N = size(A,1);                                          % ״̬ά��
M = size(H,1);                                          % ����ά��

%% ������ֵ
measure= importdata('data/filter_in.data')';
n = size(measure,2);
y = zeros(M,n);                 % �������Ĳ���ֵ
for i=1:n
    y(1,i) = measure(2,i) * sin(measure(3,i) * pi / 180);
    y(2,i) = measure(4,i) * sin(measure(3,i) * pi / 180);
    y(3,i) = measure(2,i) * cos(measure(3,i) * pi / 180);
    y(4,i) = measure(4,i) * cos(measure(3,i) * pi / 180);
end
X = [y(1,1) y(2,1) 0 y(3,1) y(4,1) 0 ]';  % �ò���ֵ��ʼ��״ֵ̬

%% �˲�
xx = zeros(N,n);
PP = zeros(N,N,n);

for i = 1 : n
    [X, P] = kf_predict(X, P, A, Q);
    [X, P] = kf_update(X, P, y(:,i),H, R);
    xx(:,i) = X;
    PP(:,:,i) = P;
end

%% ���ͳ��
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

%% ��ͼ
% λ��
figure;
plot(y(1,:),y(3,:),'b+','linewidth',1);
hold on;
plot(xx(1,:),xx(4,:),'r-','linewidth',1);
legend('����ֵ','�˲�ֵ');
xlabel('x/m');
ylabel('y/m');
title('�켣�Ա�');
set(gca,'XGrid','on');
set(gca,'YGrid','on');

% x�������
figure;
subplot(2,1,1)
plot(y(1,:),'b');
hold on;
plot(xx(1,:),'g','linewidth',2);
legend('����ֵ','�˲�ֵ');
xlabel('time/0.05sec');
ylabel('x/m');
title('x�������');
set(gca,'XGrid','on');
set(gca,'YGrid','on');
% y�������
subplot(2,1,2)
plot(y(3,:),'b');
hold on;
plot(xx(4,:),'g','linewidth',2);
legend('����ֵ','�˲�ֵ');
xlabel('time/0.05sec');
ylabel('y/m');
title('y�������');
set(gca,'XGrid','on');
set(gca,'YGrid','on');



