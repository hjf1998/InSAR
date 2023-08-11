function x = wavelet_phase_filter(x_in,n)
% x_in为输入（矩阵）；n为小波分解级数，这个参数目前没用

%下面进行去噪处理，参考论文《一种基于小波相位分析的 InSAR 干涉图滤波算法》蔡国林
%用小波函数sym4对x进行3层小波分解  
[c,s]=wavedec2(x_in,3,'sym4');  

[h1,v1,d1] = detcoef2('all',c,s,1); %尺度j=1下的水平、垂直、对角线  高频分量
[h2,v2,d2] = detcoef2('all',c,s,2); %尺度j=2下的水平、垂直、对角线  高频分量
[h3,v3,d3] = detcoef2('all',c,s,3); %尺度j=3下的水平、垂直、对角线  高频分量
hvd1 = cat(3,h1,v1,d1);
hvd2 = cat(3,h2,v2,d2);
hvd3 = cat(3,h3,v3,d3);

l1 = appcoef2(c,s,'sym4',1);   %尺度j=1下的低频分量
l2 = appcoef2(c,s,'sym4',2);   %尺度j=2下的低频分量
l3 = appcoef2(c,s,'sym4',3);   %尺度j=3下的低频分量

%计算不同尺度下的小波变换相位
A1 = atan(v1./h1);
A2 = atan(v2./h2);
A3 = atan(v3./h3);

%计算每一层的平滑窗口
w1 = 7;     %w1为第一层窗口的大小，论文中设置的
w2 = w1 * 2^(2-1) - 1;  %w2为第二层窗口的大小
w3 = w1 * 2^(3-1) - 1;  %w3为第三层窗口的大小

r1 = (w1 - 1)/2;
r2 = (w2 - 1)/2;
r3 = (w3 - 1)/2;

hvd1_pad = zeros(size(d1,1) + 2 * r1,size(d1,2) + 2 *r1,3); %第一层为h，第二层为v，第三层为d
hvd2_pad = zeros(size(d2,1) + 2 * r2,size(d2,2) + 2 *r2,3);
hvd3_pad = zeros(size(d3,1) + 2 * r3,size(d3,2) + 2 *r3,3);

hvd1_pad(r1 + 1 : size(d1,1) + r1,r1 + 1 : size(d1,2) + r1,:) = hvd1;
hvd2_pad(r2 + 1 : size(d2,1) + r2,r2 + 1 : size(d2,2) + r2,:) = hvd2;
hvd3_pad(r3 + 1 : size(d3,1) + r3,r3 + 1 : size(d3,2) + r3,:) = hvd3;

hvd1_ave = zeros(size(d1,1),size(d1,2),3);
hvd2_ave = zeros(size(d2,1),size(d2,2),3);
hvd3_ave = zeros(size(d3,1),size(d3,2),3);


for i = 1 : size(d1,1)
    for j = 1 : size(d1,2)
        hvd1_ave(i,j,:) = mean(hvd1_pad(i:i+2*r1,j:j+2*r1,:),[1,2]);
    end
end
for i = 1 : size(d2,1)
    for j = 1 : size(d2,2)
        hvd2_ave(i,j,:) = mean(hvd2_pad(i:i+2*r2,j:j+2*r2,:),[1,2]);
    end
end
for i = 1 : size(d3,1)
    for j = 1 : size(d3,2)
        hvd3_ave(i,j,:) = mean(hvd3_pad(i:i+2*r3,j:j+2*r3,:),[1,2]);
    end
end

A1_ave = atan(hvd1_ave(:,:,2)./hvd1_ave(:,:,1));
A2_ave = atan(hvd2_ave(:,:,2)./hvd2_ave(:,:,1));
A3_ave = atan(hvd3_ave(:,:,2)./hvd3_ave(:,:,1));

sta_dev_A1 = zeros(size(A1,1),size(A1,2));  %标准差
sta_dev_A2 = zeros(size(A2,1),size(A2,2));
sta_dev_A3 = zeros(size(A3,1),size(A3,2));

A1_pad = zeros(size(A1,1) + 2*r1,size(A1,2)+2*r1);
A2_pad = zeros(size(A2,1) + 2*r2,size(A2,2)+2*r2);
A3_pad = zeros(size(A3,1) + 2*r3,size(A3,2)+2*r3);

A1_pad(r1 + 1 : size(A1,1) + r1,r1 + 1 : size(A1,2) + r1,:) = A1;
A2_pad(r2 + 1 : size(A2,1) + r2,r2 + 1 : size(A2,2) + r2,:) = A2;
A3_pad(r3 + 1 : size(A3,1) + r3,r3 + 1 : size(A3,2) + r3,:) = A3;

for i = 1 : size(A1,1)
    for j = 1 : size(A1,2)
        sta_dev_A1(i,j) = std(A1_pad(i:i+2*r1,j:j+2*r1,:),1,'all');
        if abs(A1_ave(i,j)-A1(i,j))>sta_dev_A1(i,j)
            h1(i,j) = 0;
            v1(i,j) = 0;
            d1(i,j) = 0;
        else
            h1(i,j) = hvd1_ave(i,j,1);
            v1(i,j) = hvd1_ave(i,j,2);
            d1(i,j) = hvd1_ave(i,j,3);
        end
    end
end
for i = 1 : size(A2,1)
    for j = 1 : size(A2,2)
        sta_dev_A2(i,j) = std(A2_pad(i:i+2*r2,j:j+2*r2,:),1,'all');
        if abs(A2_ave(i,j)-A2(i,j))>sta_dev_A2(i,j)
            h2(i,j) = 0;
            v2(i,j) = 0;
            d2(i,j) = 0;
        else
            h2(i,j) = hvd2_ave(i,j,1);
            v2(i,j) = hvd2_ave(i,j,2);
            d2(i,j) = hvd2_ave(i,j,3);
        end
    end
end
for i = 1 : size(A3,1)
    for j = 1 : size(A3,2)
        sta_dev_A3(i,j) = std(A3_pad(i:i+2*r3,j:j+2*r3,:),1,'all');
        if abs(A3_ave(i,j)-A3(i,j))>sta_dev_A3(i,j)
            h3(i,j) = 0;
            v3(i,j) = 0;
            d3(i,j) = 0;
        else
            h3(i,j) = hvd3_ave(i,j,1);
            v3(i,j) = hvd3_ave(i,j,2);
            d3(i,j) = hvd3_ave(i,j,3);
        end
    end
end

% 将二维矩阵按列转换为一维向量
l3_trans = reshape(l3,1,[]);
h3_trans = reshape(h3,1,[]);
v3_trans = reshape(v3,1,[]);
d3_trans = reshape(d3,1,[]);
h2_trans = reshape(h2,1,[]);
v2_trans = reshape(v2,1,[]);
d2_trans = reshape(d2,1,[]);
h1_trans = reshape(h1,1,[]);
v1_trans = reshape(v1,1,[]);
d1_trans = reshape(d1,1,[]);

c1 = [l3_trans,h3_trans,v3_trans,d3_trans,h2_trans,v2_trans,d2_trans,h1_trans,v1_trans,d1_trans];
x = waverec2(c1,s,'sym4') ; % 二维小波重构

end