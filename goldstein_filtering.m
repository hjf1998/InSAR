%2023.08.07 第一版goldstein滤波
clear;clc;close all;
load gray_result1.mat;
figure;
imagesc(gray_result1),colormap('gray'),colorbar,
axis square, axis off, title('original phase');
E = exp(1i*gray_result1);

[m,n] = size(E);

win_row = 9;    %窗行数
win_col = 9;    %窗列数
step = 2;        %每次移动的像素数
num = floor((n-win_col)/step) * floor((m-win_row)/step);
%E_ii_jj_num = zeros(win_row,win_col,num);
%E_ii_jj_num = zeros(m,n,num);
E_ii_jj_num = zeros(m,n);
k = 1;

for ii = 1 : floor((n-win_col)/step)              %一次移动step个pixel
    for jj = 1 : floor((m-win_row)/step)          %一次移动step个pixel
        E_temp = E((jj-1)*step+1 : (jj-1)*step+1 + win_row ,(ii-1)*step+1 : (ii-1)*step+1 + win_col );
        E_temp_fft2 = fft2(E_temp);
        E_temp_fft2_abs = abs(E_temp_fft2);
        E_Kernel = imgaussfilt(E_temp_fft2_abs,2);  %第二个输入是标准差，这里选择用高斯核函数进行平滑
        E_Kernel_norm = E_Kernel/max(max(E_Kernel));%归一化
        alpha = 0.8;    %原作中的alpha在[0,1]区间，且没有明确说明取什么值，要根据实际情况
        E_temp_fft2_modify = E_temp_fft2.*(E_Kernel_norm.^alpha);
        E_modify_ifft2 = ifft2(E_temp_fft2_modify); 
        E_ii_jj_num((jj-1)*step+1 : (jj-1)*step+1 + win_row ,(ii-1)*step+1 : (ii-1)*step+1 + win_col) = ...
        E_ii_jj_num((jj-1)*step+1 : (jj-1)*step+1 + win_row ,(ii-1)*step+1 : (ii-1)*step+1 + win_col) + E_modify_ifft2;
        %E_ii_jj_num(:,:,k) = E_modify_ifft2;
        k = k+1;
    end
end
%怎么合并，直接把计算结果在对应位置（坐标）上相加
%result = sum(E_ii_jj_num,3);
%result = abs(E_ii_jj_num);
result = angle(E_ii_jj_num);
%result = mod(result+pi,2*pi) - pi;
figure;
imagesc(result),colormap('gray'),colorbar,
axis square, axis off, title('filtering phase');


