function flag = deterdomination(pbest_f,pop_size,f_num,x_num)
%��ʼ���Ƿ�Ϊ��֧�����
flag=zeros(1,pop_size);
for i=1:pop_size
    nn=0;
    for j=1:pop_size
        less=0;%��ǰ�����Ŀ�꺯��ֵС�ڶ��ٸ������Ŀ
        equal=0;%��ǰ�����Ŀ�꺯��ֵ���ڶ��ٸ������Ŀ
        for k=1:f_num
            if(pbest_f(i,k)<pbest_f(j,k))
                less=less+1;
            elseif(pbest_f(i,k)==pbest_f(j,k))
                equal=equal+1;
            end
        end
        if(less==0 && equal~=f_num)
            nn=nn+1;%��֧�������Ŀn+1,i��������֧��ĸ���
        end
    end
    if(nn==0)
        flag(i)=1;
    end
end
end

