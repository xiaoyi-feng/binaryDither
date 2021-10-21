clc;
clear all;
close all;
% �����������ƣ��������ɵ�����Ƶ�Ĳ���������
freq = [1,8,64];      % Ƶ���ɵ͵���
phishiftNum = 4;
cols = 912;
rows = 1048;
size = 256; % �óߴ��С��image����
sigma=3;%��׼���С
window=double(uint8(3*sigma));%���ڴ�СΪ3*sigma,��size =5*5
H=fspecial('gaussian', window, sigma);%fspecial('gaussian', hsize, sigma)�����˲�ģ��


% ����ָ����һ��Ƶ�ʵ��Ĳ���������
fringes = generateVerticalFringes(rows,cols,freq(2),phishiftNum);

% % ���Խ���λ�㷨
% unwrapped_phase = NStepPhaseShift(fringes);
% % ���������ɢ����
% binary_img = FloydErrorDiffusion(fringes(1:256, 1:256,:),7,3,5,1,16,256,256,phishiftNum);
%
% % �Ż���
% OptimizedFloydKernel(fringes(1:size,1:size,:),size,size,phishiftNum);
% 
% �����Ż��õ�����ɢ�˶��������ƽ��ж�ֵ��
binary_img1 = FloydErrorDiffusion(fringes(1:size,1:size,:),29,10,17,2,58,size,size,phishiftNum);
binary_gauss1 = zeros(size,size,phishiftNum);
binary_img2 = FloydErrorDiffusion(fringes(1:size,1:size,:),11,12,18,1,42,size,size,phishiftNum);
binary_gauss2 = zeros(size,size,phishiftNum);
binary_img3 = FloydErrorDiffusion(fringes(1:size,1:size,:),7,3,5,1,16,size,size,phishiftNum);
binary_gauss3 = zeros(size,size,phishiftNum);
% �������õ��Ķ�ֵͼ �Լ� ���� ��˹�˲���õ��Ľ�����������
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

% ǿ�Ȳ���ıȽϣ����������Ż�������ԭ���е��Ż�������Floyd-Steinberg�������ɢ�˲���
intensity1 = fringes(128,10:250,1);  % ȡͼ���еĵ�һ�е�intensity value,������ƽ��ֵ
intensity2 = binary_gauss1(128,10:250,1);     % �Լ����Ż�����
intensity3 = binary_gauss2(128,10:250,1);     % ԭ���е��Ż�����
intensity4 =binary_gauss3(128,10:250,1);  % Folyd-Steinberg�����ɢ��
err1 = intensity2-intensity1; % �����ǿ�������ֱָ�ӻҶ�ֵ���
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
h = legend([F3,F2,F1],'ԭʼFloyd','ԭ��','����');      %��һ��ͼ�������h�� ָ��F2��sin(x)��F1��cos(x)
saveas(gcf,'F:\FXY\codeRunResult\matlab\binaryDefocus\intensityError.jpg');
