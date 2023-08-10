# InSAR
Some InSAR code and learning experience

goldstein_filtering.m的输入数据可以用jet2gray.m处理pic1.png得到

2023.8.10补充，与goldstein滤波同属于变换域滤波的方法，小波滤波算法，对应的文件名为wavelet_filtering.m
小波滤波的算法参考的是论文《一种基于小波相位分析的 InSAR 干涉图滤波算法》蔡国林

### 下面是滤波效果的展示

下面两幅图为goldstein滤波前后的图像
![原始图像](https://github.com/hjf1998/InSAR/blob/insar-filtering/ori_image.svg "未滤波图像")

![滤波后图像](https://github.com/hjf1998/InSAR/blob/insar-filtering/filtering_image.svg "goldstein滤波图像")

下面两幅图为小波滤波前后的图像
![原始图像](https://github.com/hjf1998/InSAR/blob/insar-filtering/ori_image.svg "未滤波图像")

![滤波后图像](https://github.com/hjf1998/InSAR/blob/insar-filtering/wavelet_filtering_image.svg "小波滤波图像")

相位导数变化图（考察干涉图质量的一种方式）
![滤波后图像](https://github.com/hjf1998/InSAR/blob/insar-filtering/grad_image.svg "相位导数变化图")
