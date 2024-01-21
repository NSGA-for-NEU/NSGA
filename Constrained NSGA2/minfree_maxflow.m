function [minfree_value,satisfy]=minfree_maxflow(b,theta,x,yuan,zhong,hui,ac_node,x_max,Tj,Dj)
    x1 = 0.88;x2=0.88;x3=2.25;
%     x1 = 1;x2=1;x3=1;
    Gjr = [0.3 0.2 0.1 0 0 0];
    x_edge = get_x_edge( x,yuan,zhong,hui,x_max );
    net = get_initial_net( x_edge,b );
    m=max(max(net(:,1:2)));                           %压缩表中最大值就是邻接矩阵的宽与高
    dm=max(max(net(:,3)));                            %压缩表第三列最大值为节点对中最多路径数
    C=compresstable2matrix_digraph_value_c(net);      %邻接压缩表中提取容量信息
    C1=compresstable2matrix_digraph_value_c(net);     %备用流量信息，用于比较构造剩余网络
    %G_Cost=compresstable2matrix_digraph_value_g(net); %提取固定费用信息
    Cost=compresstable2matrix_digraph_value_b(net);   %邻接压缩表中提取费用信息
    Cost1=compresstable2matrix_digraph_value_b0(net);   %备用费用信息，用于计算最小费用
    Cost_n = (Cost-15)/10;                          %无量纲化
    for i = 1:zhong
        Cost_n(yuan+2*i,yuan+2*i+1,1) = (Cost(yuan+2*i,yuan+2*i+1,1)-15)/15;
    end
    Cost_n1 = (Cost1-15)/10;
    for i = 1:zhong
        Cost_n1(yuan+2*i,yuan+2*i+1,1) = (Cost1(yuan+2*i,yuan+2*i+1,1)-15)/15;
    end
    Cost_n(Cost_n<0)=0;
    Cost_n1(Cost_n1<0)=0;
    T=compresstable2matrix_digraph_value_time(net);      %邻接压缩表中提取时间信息
    T1=compresstable2matrix_digraph_value_time0(net);    %邻接压缩表中提取时间信息
    T_n = (T-15)/10;                                   %无量纲化
    for i = 1:zhong
        T_n(yuan+2*i,yuan+2*i+1,1) = (T(yuan+2*i,yuan+2*i+1,1)-5)/10;
    end
    T_n1 = (T1-15)/10;
    for i = 1:zhong
        T_n1(yuan+2*i,yuan+2*i+1,1) = (T1(yuan+2*i,yuan+2*i+1,1)-5)/10;
    end
    T_n(T_n<0)=0;
    T_n1(T_n1<0)=0;
    B = Cost_n * theta(1) + T_n * theta(2);
    B1 = Cost_n1 * theta(1) + T_n1 * theta(2);

maxflow=zeros(m,m,dm);


    while 1

        %费用网络最短路算法，得到最短路径S和前趋节点pa
        S=inf(1,m);           %从开始的源点到每一个节点的距离
        S(1)=0;               %源点到自己的距离为0
        pa=zeros(1,m);        %存储每个节点的前驱，在松弛过程中赋值
        pa_d=zeros(1,m);      %存储每个节点的前趋路径，在松弛过程中赋值
        pa(1)=1;              %源点的前趋是自己
        pa_d(1)=1;            %原点前趋路径默认为1

        visit=zeros(1,m);     %标记某个节点是否访问过了
        index=1;              %从index节点开始搜索
        index0=0;

        while sum(visit)~=m    %若有节点未访问到会陷入循环，故设置判断标识符index0
            visit(index)=1;                                  %标记第index节点为已入列的节点
            [S, pa, pa_d]=relax(S,pa,B,visit,index,m,dm,pa_d);     %松弛，如果两个节点间有更短的距离，则用更短的距离
            index=extract_min(S,visit,index,m);              %使用已访问的最小的节点作为下一次搜索的开始节点
            if index0==index                                 %判断标识符，用来跳出循环
                break;
            end
            index0=index;
        end


        %最大流判断
        if pa(m)==0     %判断是否为最大流，剩余网络中没有x-y增广路，退出算法
            break;
        end

        %费用网络寻找x-y最小费用路
        path=[];
        i=m;                  %从汇节点开始
        k=0;                  %路径包含的边的个数
        while i~=1            %使用前趋构造从源节点到汇节点的路径
            path=[path;pa(i) i pa_d(i) C(pa(i),i,pa_d(i))];     %存入路径
            i=pa(i);           %使用前趋表反向搜寻，借鉴Dijsktra中的松弛方法
            k=k+1;
        end

        %流量网络进行流量平移
        Mi=min(path(:,4));        %寻找增广路径中最小的边流量容量值
        for i=1:k
            C(path(i,1),path(i,2),path(i,3))=C(path(i,1),path(i,2),path(i,3))-Mi;     %增广路径中每条路径减去最小的边
            maxflow(path(i,1),path(i,2),path(i,3))=maxflow(path(i,1),path(i,2),path(i,3))+Mi;
        end

        %构造剩余网络
        for i=1:m
            for j=1:m
                for k=1:dm
                    if C(i,j,k)~=Inf
                        if C(i,j,k)==0                        %2型弧，构造反向联通
                            B(j,i,k)=-B(i,j,k);
                            B(i,j,k)=Inf;
                        end
                        if 0<C(i,j,k) && C(i,j,k)<C1(i,j,k)    %3型弧，构造正反双向联通
                            B(j,i,k)=-B(i,j,k);
                        end
                    end
                end
            end
        end
    end
    
    %maxflow;
    
    minfree1=maxflow.*Cost1;  %运输处理费用
    minfree2=sum(net(:,7));  %固定费用
    minfree_value = sum(minfree1(:)) + minfree2;  %总费用
    minfree_value = minfree_value/10000;
    %计算客户的满意度
    
    [myrow1,mycol1] = find(maxflow(:,:,1)~=0);
    if length(size(maxflow))==2
        myrow2=[];
        mycol2=[];
    else
        [myrow2,mycol2] = find(maxflow(:,:,2)~=0);
    end
    
    v_Gj = zeros(1,hui);
    Gj = zeros(1,hui);
    satisfy = 0;
    for i = 1:hui
    time_g = 0;
    for k = 1:zhong
        %time2
        time2=0;
        index2 = ac_node-hui+i-1;
        index1 = yuan+2*k+1;
        index_all1 = find(mycol1 == index2);
        index_value1 = myrow1(index_all1);
        index_all2 = find(mycol2 == index2);
        index_value2 = myrow2(index_all2);
        if ismember(index1,index_value1)~=1 && ismember(index1,index_value2)~=1
            continue
        end
        if length(size(T1))==2
            time = T1(index1,index2);
            if time > time2
                time2 = time;
            end
        else
            for j = 1:2
                time = T1(index1,index2,j);
                if time > time2
                    time2 = time;
                end
            end
        end
        %time1+tg
        time1 = 0;
        index2 = yuan+2*k;
        index = find(mycol1==index2);
        index1 = myrow1(index);
        for j = 1:length(index1(:))
            time = T1(index1(j),index2,1);
            if time > time1
                time1 = time;
            end
        end
        index = find(mycol2==index2);
        index1 = myrow2(index);
        for j = 1:length(index1(:))
            time = T1(index1(j),index2,2);
            if time > time1
                time1 = time;
            end
        end
        tg = T1(yuan+2*k,yuan+2*k+1,1);
        time_all = time1+time2+tg;
        if time_all > time_g
            time_g = time_all;
        end
    end
    %经上述循环后，得到的time_g就是当前的客户点的最大时间
    Gj(i) = (Tj(i) - time_g)/Tj(i);
    if Gj(i) >= Gjr(i)
        v_Gj(i) = (Gj(i)-Gjr(i))^x1;
    else
        v_Gj(i) = -x3 * (Gjr(i) - Gj(i))^x2;
    end
    satisfy = satisfy + Dj(i)*v_Gj(i)/sum(Dj(:));
    end
    satisfy = (-1)*satisfy;
end