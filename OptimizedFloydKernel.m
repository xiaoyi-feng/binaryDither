
function  OptimizedFloydKernel(fringes,rows,cols,step)
% 高斯核尺寸和标准差参数的设置
sigma=5/3;%标准差大小
window=double(uint8(3*sigma));%窗口大小为3*sigma,即size = 9×9
H=fspecial('gaussian', window, sigma);%fspecial('gaussian', hsize, sigma)产生滤波模板
 % 总误差：包含相位误差和强度误差/
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

                % 对生成的二值条纹进行高斯模糊，仿真离焦 
                %为了不出现黑边，使用参数'replicate'（输入图像的外部边界通过复制内部边界的值来扩展）
                for i = 1:step
                    binary_gauss(:,:,i)=imfilter(binary_img(:,:,i),H,'replicate');
                end
                
                for k = 1 : step
                    Ei = Ei + sqrt(sum(sum((fringes(window:rows-window,window:cols-window,k)-binary_gauss(window:rows-window,window:cols-window,k)).^2)/((rows-2*window+1)*(cols-2*window+1))));        % 强度误差：求矩阵的F范数
                    %                     Ei = Ei + rms(fringes(10:1039,10:904,1)-binary_gauss(10:1039,10:904,1));
                    %                     Ei = Ei /(4*rows*cols);
                end
                % 四步相移条纹--> 四步二值抖动图像-->高斯模糊-->四步二值离焦条纹
                % 计算误差：相位误差
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
% 参数整个遍历过程结束，输出显示最优情况
fprintf('the min error is: E_all_min =%8.4f,Ei_min = %8.4f,Ep_min = %8.4f\n',E_all_min,Ei_min,Ep_min);
fprintf('the optimal result is alpha1 = %d,alpha2 = %d,alpha3 = %d,alpha4 = %d\n',alpha1_opti,alpha2_opti,alpha3_opti,alpha4_opti);
end


            
            


