% 小波滤波算法
% ddencm()  wdencmp()
%waverec2 二维小波重构
%提取小波分解中第一层的低频图像，即实现了低通滤波去噪  
% a1=wrcoef2('a',c,s,'sym4');  % a1为 double 型数据；
% dwt()
% https://zhuanlan.zhihu.com/p/139426207 小波变换相关知识
% https://www.jianshu.com/p/fbbc8573f7ed 小波变换相关知识

clear;close all;clc;                   

load gray_result1.mat;
X = gray_result1;
X_complex = exp(1i * X);
X_real = real(X_complex);
X_imag = imag(X_complex);
%画出原始图像  
figure;
imagesc(X);colormap("gray");
title('原始图像');  
%产生含噪图像  
%x=imnoise(X ,'gaussian',0,0.003);
%画出含噪图像  
 
x_real = wavelet_phase_filter(X_real,3);
x_imag = wavelet_phase_filter(X_imag,3);

X_filter = angle(x_real + 1i*x_imag);

%画出去噪后的图像  
figure;
imagesc(X_filter);colormap("gray");
title('小波相位滤波图像');   

% 计算相位导数标准偏差（即相位导数变化图）
x_grad = X_filter(:,2:end) - X_filter(:,1:end-1); %x方向的梯度
y_grad = X_filter(2:end,:) - X_filter(1:end-1,:); %y方向的梯度

k = 5;  %自己设置的，论文中并没有说怎么设置
r = (k-1)/2;
% H = 1/k^2*ones(k);
% x_grad_ave = filter2(H,x_grad,'same');
% y_grad_ave = filter2(H,y_grad,'same');

x_grad_pad = zeros(size(x_grad,1) + 2*r,size(x_grad,2)+2*r+1);
y_grad_pad = zeros(size(y_grad,1) + 2*r+1,size(y_grad,2)+2*r);
x_grad_pad(r + 1+1 : size(x_grad,1) + r+1,r + 1 : size(x_grad,2) + r,:) = x_grad;
y_grad_pad(r + 1 : size(y_grad,1) + r,r + 1+1 : size(y_grad,2) + r+1,:) = y_grad;

Z = zeros(size(X_filter,1),size(X_filter,2));
for i = 1 : size(X_filter,1)
    for j = 1 : size(X_filter,2)
        Z(i,j) = std(x_grad_pad(i:i+2*r,j:j+2*r,:),1,'all') + ...
                 std(y_grad_pad(i:i+2*r,j:j+2*r,:),1,'all');
    end
end
%画出相位导数变化图
figure;
imagesc(Z);colormap("gray");
title('相位导数变化图');   

%V2img = wcodemat(V2,255,'mat',1);
%相当于把第一层的低频图像经过再一次的低频滤波处理  
%a2=wrcoef2('a',c,s,'sym4',2);  



