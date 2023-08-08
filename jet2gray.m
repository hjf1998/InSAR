IM3 = imread("pic3.png");

IM3 = double(IM3);
IM3_r = IM3(:,:,1);
IM3_g = IM3(:,:,2);
IM3_b = IM3(:,:,3);

gray_result1 = zeros(size(IM3_r));
[ml,nl] = size(IM3_g);

%% 以下的转换算法应该没错，可能是图像本身不是jet的格式
for m = 1:ml
    for n = 1:nl
        if IM3_g(m,n) == 0 && IM3_r(m,n) == 0
            if IM3_b(m,n) == 255
                gray_result1(m,n) = 32;
            else
                gray_result1(m,n) = (IM3_b(m,n) - 128)/4 ;

            end
        elseif IM3_r(m,n) == 0 && IM3_b(m,n) == 255 && IM3_g(m,n) > 0
            gray_result1(m,n) = (IM3_g(m,n) - 4)/4 + 33;
        elseif IM3_g(m,n) == 255
            if IM3_r(m,n) == 2 && IM3_b(m,n) == 254
                gray_result1(m,n) = 96;
            elseif IM3_r(m,n) == 254 && IM3_b(m,n) == 1
                gray_result1(m,n) = 159;
            else 
                gray_result1(m,n) = (IM3_r(m,n) - 6)/4 + 97;
            end
        elseif IM3_r(m,n) == 255 && IM3_b(m,n) == 0
            gray_result1(m,n) = (IM3_g(m,n) - 252)/(-4) + 160;
        elseif IM3_g(m,n) == 0 && IM3_b(m,n) == 0
            gray_result1(m,n) = (IM3_r(m,n) - 252)/(-4) + 224;
        end
    end
end
[x1,I1] = max(gray_result1);
[x2,I2] = max(x1);
disp(x2);

%% 输出主值区间内的数据
figure;
imagesc(gray_result1);colormap('gray');colorbar;
gray_result1 = (gray_result1/x*2 - 1)*pi;
figure;
imagesc(gray_result1);colormap('gray');colorbar;
save gray_result1.mat