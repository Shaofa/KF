%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Kalman Filter 测量更新阶段
%
% 语法:
%   [x, P] =kf_update(x,P,y,H,R)
%   
% 输入参数：
%       x:  Nx1，当前时刻先验估计状态值
%       P:  NxN，当前时刻误差协方差矩阵估计值
%       y:  Mx1，当前时刻测量值
%       H:  MxN，测量矩阵
%       R:  MxM，测量噪声协方差矩阵
%输出参数：
%       x:  Nx1，当前时刻后验估计状态值
%       P:  NxN，当前时刻误差协方差矩阵值
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x, P] = kf_update(x, P, y, H, R)
    S = H * P * H' + R;
    K = P * H' / S;
    x = x + K * (y - H*x);
    P = P - K * S * K';
end