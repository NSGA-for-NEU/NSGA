function initial_net = get_initial_net( x_edge,b )
%�������ľ��󣬾��Ǹ�������Ϣ
[edge_num,~]=size(b);
flag =0;
for i = 1:edge_num
    if x_edge(i) == 0
        b(i-flag,:)=[];
        flag = flag+1;
    end
end
initial_net= b;
end

