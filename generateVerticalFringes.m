% function fringes = generateVerticalFringes(freq,phishiftNum,cols,rows,A,B)
% %������ֱ����ͼ��
% %freq������Ƶ�ʣ���һ��pattern���������ڵ���Ŀ��������phishiftNum�����ƴ���
% %���ƻҶȷ�Χ[A,B]
% % 
% [~,freqNum] = size(freq);
% n1 = cols/freq(1);  % n1,n2,n3�ֱ������Ƶ�����
% n2 = cols/freq(2);
% n3 = cols/freq(3);
% 
% %���ɱ�������
% [X,~]=meshgrid(1:cols,1:rows); % ���ɵ�X�� rows * cols �ľ��󣺲��Ҿ����е�ֵ�����Ǿ���Ԫ��
% fringes=zeros(rows,cols,12); %  ��Ƶ�Ĳ���������
% 
% for i=1:phishiftNum
%     H=A+(B-A)*(1+cos(2*pi.*mod(X,n1)/n1+pi+(i-1)*2*pi/phishiftNum))/2;%��Ƶ��ֱ���ƣ���Ӹ߶ȵ���
%     fringes(:,:,i)=H;
%     Hm=A+(B-A)*(1+cos(2*pi.*mod(X,n2)/n2+pi+(i-1)*2*pi/phishiftNum))/2;%��Ƶ��ֱ���ƣ���Ӹ߶ȵ���
%     fringes(:,:,i+phishiftNum)=Hm;   
%     Hh=A+(B-A)*(1+cos(2*pi.*mod(X,n3)/n3+pi+(i-1)*2*pi/phishiftNum))/2;%��Ƶ��ֱ���ƣ���Ӹ߶ȵ���
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

% ����һ��Ƶ�ʵ�N����������
function fringes = generateVerticalFringes(rows, cols, freq,step)
    x = 0:1:cols-1;
    y = 0:1:rows-1;
    fringes  = zeros(rows,cols,step);
    X=meshgrid(x, y);
for i =1:step
    fringes(:,:,i) = 127.5 + 127.5*cos( 2*pi*freq/cols * X + (i-1)*2*pi/step + pi);
end
end



