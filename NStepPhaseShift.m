% 4步相移法：空间相位展�?算法解包�?
% function  unwrapped_phase = NStepPhaseShift(I,rows,cols,step)
function  unwrapped_phase = NStepPhaseShift(I)
% I = zeros(rows,cols,step);
% for k = 1 :step
%     %     I(:,:,k)=double(images(:,:,k))/255;
%     I(:,:,k)=double(images(:,:,k));
% end
[M,N] = size(I(:,:,1));
phase = zeros(M,N); 
% unwrapped_phase = zeros(M,N);
for j=1:N
    for i=1:M
        phase(i,j)=atan2(I(i,j,2)-I(i,j,4),I(i,j,1)-I(i,j,3));
    end
end
% figure;
% imshow(phase,[-pi,pi]);
% A = phase(100,:);   % ���ƽض���λͼ�е�ĳһ������
% plot(A,'-');                 %����ͼ������
%四步相移法计算出相位
n=zeros(M,N);   %解包
n(1,1)=0; % 存放 的是条纹跳变的级�?
% for i=2:N
%     if abs(phase(1,i)-phase(1,i-1))<pi
%         n(1,i)=n(1,i-1);
%     elseif phase(1,i)-phase(1,i-1)<=-pi
%         n(1,i)=n(1,i-1)+1;
%     elseif phase(1,i)-phase(1,i-1)>=pi
%         n(1,i)=n(1,i-1)-1;
%     end
% end
% for i=2:M
%     for j=1:N
%         if abs(phase(i,j)-phase(i-1,j))<pi
%             n(i,j)=n(i-1,j);
%         elseif phase(i,j)-phase(i-1,j)<=-pi
%             n(i,j)=n(i-1,j)+1;
%         elseif phase(i,j)-phase(i-1,j)>=pi
%             n(i,j)=n(i-1,j)-1;
%         end
%     end
% end   
% 除以16Π的原因是：imshow()函数显示double类型的时候取值范围是�?0�?1�?
% unwrapped_phase=(phase+2*pi.*n + 15 * pi)/(16*pi);  % double value; 统一加上15Π的原因是将展�?后的相位均为正�?�，�?16Π�?0Π�?
% imshow(unwrapped_phase); % 将图像中�?小�?�显示为黑色0，最大�?�显示为白色255
% unwrapped_phase = (unwrap(phase,[],2)+17*pi)/(16*pi);   % ����2��ʾ��ÿһ�н���չ��

unwrapped_phase = unwrap(phase,[],2);
phase_max = max(max(unwrapped_phase));
phase_min = min(min(unwrapped_phase));
unwrapped_phase = (unwrapped_phase - phase_min)/(phase_max - phase_min);
% imshow(unwrapped_phase);
% A = unwrapped_phase(100,:);   % ���ƽض���λͼ�е�ĳһ������
% plot(A,'-');                 %����ͼ������
end

