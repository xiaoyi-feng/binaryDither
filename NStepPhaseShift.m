% 4姝ョ浉绉绘硶锛氱┖闂寸浉浣嶅睍寮?绠楁硶瑙ｅ寘瑁?
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
% A = phase(100,:);   % 绘制截断相位图中的某一行数据
% plot(A,'-');                 %画出图像数据
%鍥涙鐩哥Щ娉曡绠楀嚭鐩镐綅
n=zeros(M,N);   %瑙ｅ寘
n(1,1)=0; % 瀛樻斁 鐨勬槸鏉＄汗璺冲彉鐨勭骇娆?
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
% 闄や互16螤鐨勫師鍥犳槸锛歩mshow()鍑芥暟鏄剧ずdouble绫诲瀷鐨勬椂鍊欏彇鍊艰寖鍥存槸銆?0锛?1銆?
% unwrapped_phase=(phase+2*pi.*n + 15 * pi)/(16*pi);  % double value; 缁熶竴鍔犱笂15螤鐨勫師鍥犳槸灏嗗睍寮?鍚庣殑鐩镐綅鍧囦负姝ｅ?硷紝銆?16螤锛?0螤銆?
% imshow(unwrapped_phase); % 灏嗗浘鍍忎腑鏈?灏忓?兼樉绀轰负榛戣壊0锛屾渶澶у?兼樉绀轰负鐧借壊255
% unwrapped_phase = (unwrap(phase,[],2)+17*pi)/(16*pi);   % 参数2表示对每一行进行展开

unwrapped_phase = unwrap(phase,[],2);
phase_max = max(max(unwrapped_phase));
phase_min = min(min(unwrapped_phase));
unwrapped_phase = (unwrapped_phase - phase_min)/(phase_max - phase_min);
% imshow(unwrapped_phase);
% A = unwrapped_phase(100,:);   % 绘制截断相位图中的某一行数据
% plot(A,'-');                 %画出图像数据
end

