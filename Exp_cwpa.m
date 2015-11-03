clear all;
close all;
clc;

%% ϵͳ�Ͳ�����ģ
dt = 0.05;
A = [1  0   dt  0   dt*dt/2  0;                     % ϵͳģ��
     0  1   0   dt  0        dt*dt/2;
     0  0   1   0   dt       0;
     0  0   0   1   0        dt;
     0  0   0   0   1        0;
     0  0   0   0   0        1];
 
H = [1  0   0   0   0   0;                          % ����ģ��
     0  1   0   0   0   0];

Q = [0.002    0       0       0       0       0;      % ��������Э�������
     0      0.002     0       0       0       0;
     0      0       0.002    0       0       0;
     0      0       0       0.002    0       0;
     0      0       0       0       0.002   0;
     0      0       0       0       0       0.002];
 
R = [1  0;                                      % ��������Э�������
     0  1];

X = [10 10 2 5 0 2]';                                % ��ʼ״̬

P = [1  0   0   0   0   0;                          % ��ʼ���Э�������
     0  1   0   0   0   0;
     0  0   1   0   0   0;
     0  0   0   1   0   0;
     0  0   0   0   1   0;
     0  0   0   0   0   1];
 
N = size(A,1);                                          % ״̬ά��
M = size(H,1);                                          % ����ά��

%% ģ�����ֵ
n = 100;
z = zeros(M,n);         % ����ֵ
y = zeros(M,n);         % �������Ĳ���ֵ
for i = 1 : n
    z(:,i) = H * X;
    X = A * X;
end
noisX0 = normrnd(0,R(1,1),1,n);
noisX1 = normrnd(0,R(2,2),1,n);
y(1,:) = z(1,:) + noisX0;
y(2,:) = z(2,:) + noisX1;

X = [y(1,1) y(2,1) 0 0 0 0 ]';  % �ò���ֵ��ʼ��״ֵ̬

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

%% ��ͼ
% λ��
figure;
plot(z(1,:),z(2,:),'g-','linewidth',2);
hold on;
plot(y(1,:),y(2,:),'b+','linewidth',1);
hold on;
plot(xx(1,:),xx(2,:),'r-','linewidth',1);
legend('����ֵ','����ֵ','�˲�ֵ');
xlabel('x/m');
ylabel('y/m');
title('�켣�Ա�');
set(gca,'XGrid','on');
set(gca,'YGrid','on');

% x�������
figure;
subplot(2,1,1)
plot(z(1,:),'g-','linewidth',2);
hold on;
plot(y(1,:),'b+');
hold on;
plot(xx(1,:),'r-')
legend('����ֵ','����ֵ','�˲�ֵ');
xlabel('time/0.05sec');
ylabel('x/m');
title('x�������');
set(gca,'XGrid','on');
set(gca,'YGrid','on');
% x�������
subplot(2,1,2);
plot(xx(1,:)-z(1,:),'g-','linewidth',2);
hold on;
plot(xx(1,:)-y(1,:),'b-');
hold on;
legend('�˲����','�������');
xlabel('time/0.05sec');
ylabel('x/m');
title('x�������');
set(gca,'XGrid','on');
set(gca,'YGrid','on');

% y�������
figure;
subplot(2,1,1)
plot(z(2,:),'g-','linewidth',2);
hold on;
plot(y(2,:),'b+');
hold on;
plot(xx(2,:),'r-')
legend('����ֵ','����ֵ','�˲�ֵ');
xlabel('time/0.05sec');
ylabel('y/m');
title('y�������');
set(gca,'XGrid','on');
set(gca,'YGrid','on');
% y�������
subplot(2,1,2);
plot(xx(2,:)-z(2,:),'g-','linewidth',2);
hold on;
plot(xx(2,:)-y(2,:),'b-');
hold on;
legend('�˲����','�������');
xlabel('time/0.05sec');
ylabel('y/m');
title('y�������');
set(gca,'XGrid','on');
set(gca,'YGrid','on');



