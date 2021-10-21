
function  binary_img = FloydErrorDiffusion(fringes,alpha1,alpha2,alpha3,alpha4,alpha_sum,rows,cols,step)
binary_img = zeros(rows,cols,step);
for i = 1 : step  % �Ĳ�����
    [M,N] = size(fringes(:,:,1));
    binary_img(:,:,i)= fringes(:,:,i);
    threshold = 128;
    % scan����ɨ�裬�����ң����ϵ���
    for row = 1 : +1 : N
        for column = 1: +1 :M
            if binary_img(column,row,i) > threshold
                error = binary_img(column,row,i) - 255; % �������= ԭʼ�Ҷȼ�����ɢ���֮��ĻҶ� - ��ֵ��֮��ĻҶ�ֵ
                binary_img(column,row,i) = 255;
            else
                error = binary_img( column,row,i) - 0;
                binary_img(column ,row,i) = 0;
            end
            
            if column == 1 && row <N % ��߽��ȥ���һ�м���ȥ���½�
                binary_img(column+1 , row,i) =  binary_img(column+1 , row,i) + error *alpha1/alpha_sum;
                binary_img(column , row + 1,i ) =  binary_img(column , row + 1,i) + error *alpha3/alpha_sum;
                binary_img(column+1 , row + 1,i) =  binary_img(column+1 , row + 1,i) + error *alpha4/alpha_sum;
            elseif column == M && row < N     % �ұ߽�
                binary_img(column , row+1,i) =  binary_img(column , row+1,i) + error *alpha3/alpha_sum;
                binary_img(column-1 , row + 1,i) =  binary_img(column-1 , row+1,i) + error *alpha2/alpha_sum;
            elseif column <M && row == N         % �±߽��ȥ���½�
                binary_img(column+1 , row,i) =  binary_img(column+1 , row,i) + error *alpha1/alpha_sum;
            elseif column == M && row == 1            % ���Ͻ�
                binary_img(column , row+1,i) =  binary_img(column , row+1,i) + error *alpha3/alpha_sum;
                binary_img(column-1 , row+1,i) =  binary_img(column-1 , row+1,i) + error *alpha2/alpha_sum;
            elseif column == M && row == N              % ���½�
                
            else
                binary_img(column+1 , row,i) =  binary_img(column+1 , row,i) + error *alpha1/alpha_sum;
                binary_img(column , row +1 ,i) =  binary_img(column , row+1,i) + error *alpha3/alpha_sum;
                binary_img(column-1 , row +1,i) =  binary_img(column-1 , row+1,i) + error *alpha2/alpha_sum;
                binary_img(column+1 , row+1,i) =  binary_img(column+1 , row+1,i) + error *alpha4/alpha_sum;
                
            end       % if
        end
    end
end

% ��ʾ����Floyd�����ɢ֮��õ��Ľ��
% figure;
% imshow(binary_img(:,:,1));
% title("Floyd Error Diffusion");

end






