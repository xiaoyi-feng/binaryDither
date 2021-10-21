
function  OptimizedFloydKernel(fringes,rows,cols,step)
% ��˹�˳ߴ�ͱ�׼�����������
sigma=5/3;%��׼���С
window=double(uint8(3*sigma));%���ڴ�СΪ3*sigma,��size = 9��9
H=fspecial('gaussian', window, sigma);%fspecial('gaussian', hsize, sigma)�����˲�ģ��
 % ����������λ����ǿ�����/
E_all_min =1;
Ei_min = 1;
Ep_min = 1;

alpha1_opti =0;
alpha2_opti =0;
alpha3_opti =0;
alpha4_opti =0;
gama = 0.7;


binary_gauss = zeros(rows,cols,step);

for alpha4 = 1 :32
    for alpha3 = 1: 32
        for alpha2 = 1 : 32
            for alpha1 = 1 : 32
                alpha_sum = alpha1+alpha2+alpha3+alpha4;
                Ei = 0.0;
                binary_img = FloydErrorDiffusion(fringes,alpha1,alpha2,alpha3,alpha4,alpha_sum,rows,cols,step);

                % �����ɵĶ�ֵ���ƽ��и�˹ģ���������뽹 
                %Ϊ�˲����ֺڱߣ�ʹ�ò���'replicate'������ͼ����ⲿ�߽�ͨ�������ڲ��߽��ֵ����չ��
                for i = 1:step
                    binary_gauss(:,:,i)=imfilter(binary_img(:,:,i),H,'replicate');
                end
                
                for k = 1 : step
                    Ei = Ei + sqrt(sum(sum((fringes(window:rows-window,window:cols-window,k)-binary_gauss(window:rows-window,window:cols-window,k)).^2)/((rows-2*window+1)*(cols-2*window+1))));        % ǿ����������F����
                    %                     Ei = Ei + rms(fringes(10:1039,10:904,1)-binary_gauss(10:1039,10:904,1));
                    %                     Ei = Ei /(4*rows*cols);
                end
                % �Ĳ���������--> �Ĳ���ֵ����ͼ��-->��˹ģ��-->�Ĳ���ֵ�뽹����
                % ��������λ���
                Ei = Ei/4;
                sin_unwrapped_phase = NStepPhaseShift(fringes);
                bin_unwrapped_phase = NStepPhaseShift(binary_gauss);
                Ep = sqrt(sum(sum((sin_unwrapped_phase(window:rows-window,window:cols-window)- bin_unwrapped_phase(window:rows-window,window:cols-window)).^2)/((rows-2*window+1)*(cols-2*window+1))));
                E_all = gama*Ep/(2 * pi) + (1-gama)* Ei/(2* max(max(fringes(:,:,1)))) ;
                if E_all < E_all_min
                    alpha1_opti = alpha1;
                    alpha2_opti = alpha2;
                    alpha3_opti = alpha3;
                    alpha4_opti = alpha4;
                    E_all_min = E_all;
                    Ei_min = Ei;
                    Ep_min = Ep;
                end    
            end
        end
    end
end
% ���������������̽����������ʾ�������
fprintf('the min error is: E_all_min =%8.4f,Ei_min = %8.4f,Ep_min = %8.4f\n',E_all_min,Ei_min,Ep_min);
fprintf('the optimal result is alpha1 = %d,alpha2 = %d,alpha3 = %d,alpha4 = %d\n',alpha1_opti,alpha2_opti,alpha3_opti,alpha4_opti);
end


            
            


