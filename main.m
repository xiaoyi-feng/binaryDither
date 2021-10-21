clc;
clear all;
close all;
% 生成正弦条纹：这里生成的是三频四步相移条纹
freq = [1,8,64];      % 频率由低到高
phishiftNum = 4;
cols = 912;
rows = 1048;
size = 256; % 用尺寸较小的image计算
sigma=3;%标准差大小
window=double(uint8(3*sigma));%窗口大小为3*sigma,即size =5*5
H=fspecial('gaussian', window, sigma);%fspecial('gaussian', hsize, sigma)产生滤波模板


% 生成指定的一种频率的四步正弦条纹
fringes = generateVerticalFringes(rows,cols,freq(2),phishiftNum);

% % 测试解相位算法
% unwrapped_phase = NStepPhaseShift(fringes);
% % 测试误差扩散函数
% binary_img = FloydErrorDiffusion(fringes(1:256, 1:256,:),7,3,5,1,16,256,256,phishiftNum);
%
% % 优化核
% OptimizedFloydKernel(fringes(1:size,1:size,:),size,size,phishiftNum);
% 
% 利用优化得到的扩散核对正弦条纹进行二值化
binary_img1 = FloydErrorDiffusion(fringes(1:size,1:size,:),29,10,17,2,58,size,size,phishiftNum);
binary_gauss1 = zeros(size,size,phishiftNum);
binary_img2 = FloydErrorDiffusion(fringes(1:size,1:size,:),11,12,18,1,42,size,size,phishiftNum);
binary_gauss2 = zeros(size,size,phishiftNum);
binary_img3 = FloydErrorDiffusion(fringes(1:size,1:size,:),7,3,5,1,16,size,size,phishiftNum);
binary_gauss3 = zeros(size,size,phishiftNum);
% 保存最后得到的二值图 以及 经过 高斯滤波后得到的近似正弦条纹
for i = 1 : phishiftNum
%     imwrite(uint8(binary_img1(:,:,i)), ['D:\major\data\BinaryDefocus\binaryCode\optimizedFloyd\binary\',num2str(i),'.bmp']);
    binary_gauss1(:,:,i)=imfilter(binary_img1(:,:,i),H,'replicate');
    binary_gauss2(:,:,i)=imfilter(binary_img2(:,:,i),H,'replicate');
    binary_gauss3(:,:,i)=imfilter(binary_img3(:,:,i),H,'replicate');
%     imwrite(uint8(binary_gauss1(:,:,i)), ['D:\major\data\BinaryDefocus\binaryCode\optimizedFloyd\defocus\',num2str(i),'.bmp']);
end
sin_unwrapped_phase = NStepPhaseShift(fringes(1:size,1:size,:));
bin_unwrapped_phase1 = NStepPhaseShift(binary_gauss1);
Ep1 = sqrt(sum(sum((sin_unwrapped_phase(window:size-window,window:size-window)- bin_unwrapped_phase1(window:size-window,window:size-window)).^2)/((size-2*window+1)*(size-2*window+1))));
bin_unwrapped_phase2 = NStepPhaseShift(binary_gauss2);
Ep2 = sqrt(sum(sum((sin_unwrapped_phase(window:size-window,window:size-window)- bin_unwrapped_phase2(window:size-window,window:size-window)).^2)/((size-2*window+1)*(size-2*window+1))));
bin_unwrapped_phase3 = NStepPhaseShift(binary_gauss3);
Ep3 = sqrt(sum(sum((sin_unwrapped_phase(window:size-window,window:size-window)- bin_unwrapped_phase3(window:size-window,window:size-window)).^2)/((size-2*window+1)*(size-2*window+1))));
disp(['the phase error of own :',num2str(Ep1)]);  
disp(['the phase error of paper :',num2str(Ep2)]); 
disp(['the phase error of original Floyd-Steinberg :',num2str(Ep3)]);
% printf('the phase error of own : %f',Ep1);
% printf('the phase error of paper :  %f',Ep2);
% printf('the phase error of original Floyd-Steinberg : %f',Ep3);

% 强度差异的比较：这里计算的优化参数和原文中的优化参数和Floyd-Steinberg的误差扩散核参数
intensity1 = fringes(128,10:250,1);  % 取图像中的第一行的intensity value,按列求平均值
intensity2 = binary_gauss1(128,10:250,1);     % 自己的优化参数
intensity3 = binary_gauss2(128,10:250,1);     % 原文中的优化参数
intensity4 =binary_gauss3(128,10:250,1);  % Folyd-Steinberg误差扩散核
err1 = intensity2-intensity1; % 这里的强度误差是指直接灰度值相减
err2 = intensity3-intensity1;
err3 = intensity4-intensity1;
x=10:250;
figure
F1 = plot(x,err1,'b','LineWidth', 2);

hold on 
F2 = plot(x,err2,'r','LineWidth', 2);

hold on 
F3 = plot(x,err3,'g','LineWidth', 2);
title('the constract of intensity error')
xlabel('pixel index')
ylabel('intensity error')
h = legend([F3,F2,F1],'原始Floyd','原文','复现');      %加一个图例，句柄h。 指明F2是sin(x)，F1是cos(x)
saveas(gcf,'F:\FXY\codeRunResult\matlab\binaryDefocus\intensityError.jpg');
