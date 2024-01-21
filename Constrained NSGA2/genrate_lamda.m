
function lamda = genrate_lamda( lamda_num,f_num )
%生成一组均匀分布的权重向量
    lamda=zeros(lamda_num,f_num); %初始化
    array=(0:lamda_num)/lamda_num;%均匀分布的值
    for i=1:lamda_num+1
            lamda(i,1)=array(i);
            lamda(i,2)=1-array(i);
    end
end

