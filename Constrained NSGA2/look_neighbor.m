function B = look_neighbor( lamda,T )
%������������Ȩ���������ŷʽ����
pop_size =size(lamda,1);
B=zeros(pop_size,T);
distance=zeros(pop_size,pop_size);
for i=1:pop_size
    for j=1:pop_size
        l=lamda(i,:)-lamda(j,:);
        distance(i,j)=sqrt(l*l');
    end
end
%����ÿ��Ȩ���������T��Ȩ������������
for i=1:pop_size
    [~,index]=sort(distance(i,:));
    B(i,:)=index(1:T);
end


