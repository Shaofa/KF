function [ A H P Q R M Z Zr] = kf_model(model)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%% 随机常量
if(model == 1)
    A = 1;
    H = 1;
    P = 1;
    Q = 0.0001;
    R = 0.1;
    M = 0;
    
    % 模拟测量值
    n = 200;
    Zr = zeros(1,n);         % 理论值测量值
    Z = zeros(1,n);         % 带噪声的测量值
    for k = 1 : n
        Zr(:,k) = 2;
    end
    nois = normrnd(0,sqrt(R),1,n);
    Z(1,:) = Zr(1,:) + nois;
end

%% CWPA model
if(model == 2)    
    dt = 0.05;
    A = [1  dt  dt*dt/2  0       0       0;             % 系统模型
         0  1   dt       0       0       0;
         0  0   1        0       0       0;
         0  0   0        1       dt      dt*dt/2;
         0  0   0        0       1       dt;
         0  0   0        0       0       1];

    H = [1  0   0   0   0   0;                          % 测量模型
         0  0   0   1   0   0];

    Q = [0.002    0       0       0       0       0;      % 过程噪声协方差矩阵
         0      0.002     0       0       0       0;
         0      0       0.002    0       0       0;
         0      0       0       0.002    0       0;
         0      0       0       0       0.002   0;
         0      0       0       0       0       0.002];

    R = [1  0;                                      % 测量噪声协方差矩阵
         0  1];

    M = [10 10 2 5 0 2]';                                % 初始状态

    P = [1  0   0   0   0   0;                          % 初始误差协方差矩阵
         0  1   0   0   0   0;
         0  0   1   0   0   0;
         0  0   0   1   0   0;
         0  0   0   0   1   0;
         0  0   0   0   0   1];

    % 模拟测量值
    m = size(H,1);                                          % 测量维度
    n = 100;
    Zr = zeros(m,n);         % 理论值
    Z  = zeros(m,n);         % 带噪声的测量值
    for i = 1 : n
        Zr(:,i) = H * M;
        M = A * M;
    end
    noisX0 = normrnd(0,R(1,1),1,n);
    noisX1 = normrnd(0,R(2,2),1,n);
    Z(1,:) = Zr(1,:) + noisX0;
    Z(2,:) = Zr(2,:) + noisX1;

    M = [Z(1,1) 0 0 Z(2,1) 0 0 ]';  % 用测量值初始化状态值
end

%% CA
if(model==3)
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

    % 读测量值
    measure= importdata('data/filter_in.data')';
    n = size(measure,2);
    Z = zeros(M,n);                 % 带噪声的测量值
    for i=1:n
        Z(1,i) = measure(2,i) * sin(measure(3,i) * pi / 180);
        Z(2,i) = measure(4,i) * sin(measure(3,i) * pi / 180);
        Z(3,i) = measure(2,i) * cos(measure(3,i) * pi / 180);
        Z(4,i) = measure(4,i) * cos(measure(3,i) * pi / 180);
    end
    M = [Z(1,1) Z(2,1) 0 Z(3,1) Z(4,1) 0 ]';  % 用测量值初始化状态值
    Zr = zeros(0);
end
end

