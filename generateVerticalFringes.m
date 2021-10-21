% function fringes = generateVerticalFringes(freq,phishiftNum,cols,rows,A,B)
% %生成竖直条纹图案
% %freq：条纹频率，即一张pattern中条纹周期的数目，三个，phishiftNum：相移次数
% %条纹灰度范围[A,B]
% % 
% [~,freqNum] = size(freq);
% n1 = cols/freq(1);  % n1,n2,n3分别是条纹的周期
% n2 = cols/freq(2);
% n3 = cols/freq(3);
% 
% %生成变形条纹
% [X,~]=meshgrid(1:cols,1:rows); % 生成的X是 rows * cols 的矩阵：并且矩阵中的值正好是矩阵元素
% fringes=zeros(rows,cols,12); %  三频四步相移条纹
% 
% for i=1:phishiftNum
%     H=A+(B-A)*(1+cos(2*pi.*mod(X,n1)/n1+pi+(i-1)*2*pi/phishiftNum))/2;%低频竖直条纹，添加高度调制
%     fringes(:,:,i)=H;
%     Hm=A+(B-A)*(1+cos(2*pi.*mod(X,n2)/n2+pi+(i-1)*2*pi/phishiftNum))/2;%中频竖直条纹，添加高度调制
%     fringes(:,:,i+phishiftNum)=Hm;   
%     Hh=A+(B-A)*(1+cos(2*pi.*mod(X,n3)/n3+pi+(i-1)*2*pi/phishiftNum))/2;%高频竖直条纹，添加高度调制
%     fringes(:,:,i+2*phishiftNum)=Hh;
% end
% 
% 
% imshow(fringes(:,:,5),[]);
% 
% n = 0;
% for j = 1 :freqNum
%     for i = 1 : phishiftNum
%         n = n + 1;
%         imwrite(uint8(fringes(:,:,n)), ['D:\major\data\BinaryDefocus\4stepSinFringe/fringe_v_',num2str(freq(j)),'_',num2str(i),'.bmp']);
%     end 
% end

% 生成一种频率的N步相移条纹
function fringes = generateVerticalFringes(rows, cols, freq,step)
    x = 0:1:cols-1;
    y = 0:1:rows-1;
    fringes  = zeros(rows,cols,step);
    X=meshgrid(x, y);
for i =1:step
    fringes(:,:,i) = 127.5 + 127.5*cos( 2*pi*freq/cols * X + (i-1)*2*pi/step + pi);
end
end



