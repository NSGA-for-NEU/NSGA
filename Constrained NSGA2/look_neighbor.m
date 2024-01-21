function B = look_neighbor( lamda,T )
%计算任意两个权重向量间的欧式距离
pop_size =size(lamda,1);
B=zeros(pop_size,T);
distance=zeros(pop_size,pop_size);
for i=1:pop_size
    for j=1:pop_size
        l=lamda(i,:)-lamda(j,:);
        distance(i,j)=sqrt(l*l');
    end
end
%查找每个权向量最近的T个权重向量的索引
for i=1:pop_size
    [~,index]=sort(distance(i,:));
    B(i,:)=index(1:T);
end


