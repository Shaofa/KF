clear all;
close all;
clc;

%% ϵͳ�Ͳ�����ģ
Q = 0.0001;  	% ��������Э�������
 
R = 0.11;    	% ��������Э�������

X = 2;           % ��ʼ״̬



%% ģ�����ֵ
n = 200;
z = zeros(1,n);         % ����ֵ����ֵ
y = zeros(1,n);         % �������Ĳ���ֵ
for k = 1 : n
    z(:,k) = X;
end
nois = normrnd(0,sqrt(R),1,n);
y(1,:) = z(1,:) + nois;

%% �˲�
X = -5;         % ��ʼ״̬
P = 0.5;       	% ��ʼ���Э�������
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

%% ���ͳ��
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


%% ��ͼ
%
figure;
subplot(2,1,1)
plot(z(1,:),'g-','linewidth',2);
hold on;
plot(y(1,:),'b+');
hold on;
plot(xx(1,:),'r-')
legend('����ֵ','����ֵ','�˲�ֵ');
xlabel('time');
title('�������');
set(gca,'XGrid','on');
set(gca,'YGrid','on');

% ���
subplot(2,1,2);
plot(xx(1,:)-z(1,:),'g-','linewidth',2);
hold on;
plot(xx(1,:)-y(1,:),'b-');
hold on;
legend('�˲����','�������');
xlabel('time');
title('����������');
set(gca,'XGrid','on');
set(gca,'YGrid','on');

figure;
plot(PP);
title('Pk');
xlabel('time');

%% �˲�
X = -5;         % ��ʼ״̬
P = 1;       	% ��ʼ���Э�������
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

%% ���ͳ��
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


%% ��ͼ
%
figure;
subplot(2,1,1)
plot(z(1,:),'g-','linewidth',2);
hold on;
plot(y(1,:),'b+');
hold on;
plot(xx(1,:),'r-')
legend('����ֵ','����ֵ','�˲�ֵ');
xlabel('x/m');
ylabel('y/m');
title('x�������');
set(gca,'XGrid','on');
set(gca,'YGrid','on');

% ���
subplot(2,1,2);
plot(xx(1,:)-z(1,:),'g-','linewidth',2);
hold on;
plot(xx(1,:)-y(1,:),'b-');
hold on;
legend('�˲����','�������');
xlabel('time/0.05sec');
ylabel('x/m');
title('x��������');
set(gca,'XGrid','on');
set(gca,'YGrid','on');

figure;
plot(PP);


