
function lamda = genrate_lamda( lamda_num,f_num )
%����һ����ȷֲ���Ȩ������
    lamda=zeros(lamda_num,f_num); %��ʼ��
    array=(0:lamda_num)/lamda_num;%���ȷֲ���ֵ
    for i=1:lamda_num+1
            lamda(i,1)=array(i);
            lamda(i,2)=1-array(i);
    end
end

