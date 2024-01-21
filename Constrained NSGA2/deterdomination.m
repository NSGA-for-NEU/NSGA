function flag = deterdomination(pbest_f,pop_size,f_num,x_num)
%初始化是否为非支配个体
flag=zeros(1,pop_size);
for i=1:pop_size
    nn=0;
    for j=1:pop_size
        less=0;%当前个体的目标函数值小于多少个体的数目
        equal=0;%当前个体的目标函数值等于多少个体的数目
        for k=1:f_num
            if(pbest_f(i,k)<pbest_f(j,k))
                less=less+1;
            elseif(pbest_f(i,k)==pbest_f(j,k))
                equal=equal+1;
            end
        end
        if(less==0 && equal~=f_num)
            nn=nn+1;%被支配个体数目n+1,i被其他解支配的个数
        end
    end
    if(nn==0)
        flag(i)=1;
    end
end
end

