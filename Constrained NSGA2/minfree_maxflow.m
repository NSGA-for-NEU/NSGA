function [minfree_value,satisfy]=minfree_maxflow(b,theta,x,yuan,zhong,hui,ac_node,x_max,Tj,Dj)
    x1 = 0.88;x2=0.88;x3=2.25;
%     x1 = 1;x2=1;x3=1;
    Gjr = [0.3 0.2 0.1 0 0 0];
    x_edge = get_x_edge( x,yuan,zhong,hui,x_max );
    net = get_initial_net( x_edge,b );
    m=max(max(net(:,1:2)));                           %ѹ���������ֵ�����ڽӾ���Ŀ����
    dm=max(max(net(:,3)));                            %ѹ������������ֵΪ�ڵ�������·����
    C=compresstable2matrix_digraph_value_c(net);      %�ڽ�ѹ��������ȡ������Ϣ
    C1=compresstable2matrix_digraph_value_c(net);     %����������Ϣ�����ڱȽϹ���ʣ������
    %G_Cost=compresstable2matrix_digraph_value_g(net); %��ȡ�̶�������Ϣ
    Cost=compresstable2matrix_digraph_value_b(net);   %�ڽ�ѹ��������ȡ������Ϣ
    Cost1=compresstable2matrix_digraph_value_b0(net);   %���÷�����Ϣ�����ڼ�����С����
    Cost_n = (Cost-15)/10;                          %�����ٻ�
    for i = 1:zhong
        Cost_n(yuan+2*i,yuan+2*i+1,1) = (Cost(yuan+2*i,yuan+2*i+1,1)-15)/15;
    end
    Cost_n1 = (Cost1-15)/10;
    for i = 1:zhong
        Cost_n1(yuan+2*i,yuan+2*i+1,1) = (Cost1(yuan+2*i,yuan+2*i+1,1)-15)/15;
    end
    Cost_n(Cost_n<0)=0;
    Cost_n1(Cost_n1<0)=0;
    T=compresstable2matrix_digraph_value_time(net);      %�ڽ�ѹ��������ȡʱ����Ϣ
    T1=compresstable2matrix_digraph_value_time0(net);    %�ڽ�ѹ��������ȡʱ����Ϣ
    T_n = (T-15)/10;                                   %�����ٻ�
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

        %�����������·�㷨���õ����·��S��ǰ���ڵ�pa
        S=inf(1,m);           %�ӿ�ʼ��Դ�㵽ÿһ���ڵ�ľ���
        S(1)=0;               %Դ�㵽�Լ��ľ���Ϊ0
        pa=zeros(1,m);        %�洢ÿ���ڵ��ǰ�������ɳڹ����и�ֵ
        pa_d=zeros(1,m);      %�洢ÿ���ڵ��ǰ��·�������ɳڹ����и�ֵ
        pa(1)=1;              %Դ���ǰ�����Լ�
        pa_d(1)=1;            %ԭ��ǰ��·��Ĭ��Ϊ1

        visit=zeros(1,m);     %���ĳ���ڵ��Ƿ���ʹ���
        index=1;              %��index�ڵ㿪ʼ����
        index0=0;

        while sum(visit)~=m    %���нڵ�δ���ʵ�������ѭ�����������жϱ�ʶ��index0
            visit(index)=1;                                  %��ǵ�index�ڵ�Ϊ�����еĽڵ�
            [S, pa, pa_d]=relax(S,pa,B,visit,index,m,dm,pa_d);     %�ɳڣ���������ڵ���и��̵ľ��룬���ø��̵ľ���
            index=extract_min(S,visit,index,m);              %ʹ���ѷ��ʵ���С�Ľڵ���Ϊ��һ�������Ŀ�ʼ�ڵ�
            if index0==index                                 %�жϱ�ʶ������������ѭ��
                break;
            end
            index0=index;
        end


        %������ж�
        if pa(m)==0     %�ж��Ƿ�Ϊ�������ʣ��������û��x-y����·���˳��㷨
            break;
        end

        %��������Ѱ��x-y��С����·
        path=[];
        i=m;                  %�ӻ�ڵ㿪ʼ
        k=0;                  %·�������ıߵĸ���
        while i~=1            %ʹ��ǰ�������Դ�ڵ㵽��ڵ��·��
            path=[path;pa(i) i pa_d(i) C(pa(i),i,pa_d(i))];     %����·��
            i=pa(i);           %ʹ��ǰ��������Ѱ�����Dijsktra�е��ɳڷ���
            k=k+1;
        end

        %���������������ƽ��
        Mi=min(path(:,4));        %Ѱ������·������С�ı���������ֵ
        for i=1:k
            C(path(i,1),path(i,2),path(i,3))=C(path(i,1),path(i,2),path(i,3))-Mi;     %����·����ÿ��·����ȥ��С�ı�
            maxflow(path(i,1),path(i,2),path(i,3))=maxflow(path(i,1),path(i,2),path(i,3))+Mi;
        end

        %����ʣ������
        for i=1:m
            for j=1:m
                for k=1:dm
                    if C(i,j,k)~=Inf
                        if C(i,j,k)==0                        %2�ͻ������췴����ͨ
                            B(j,i,k)=-B(i,j,k);
                            B(i,j,k)=Inf;
                        end
                        if 0<C(i,j,k) && C(i,j,k)<C1(i,j,k)    %3�ͻ�����������˫����ͨ
                            B(j,i,k)=-B(i,j,k);
                        end
                    end
                end
            end
        end
    end
    
    %maxflow;
    
    minfree1=maxflow.*Cost1;  %���䴦�����
    minfree2=sum(net(:,7));  %�̶�����
    minfree_value = sum(minfree1(:)) + minfree2;  %�ܷ���
    minfree_value = minfree_value/10000;
    %����ͻ��������
    
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
    %������ѭ���󣬵õ���time_g���ǵ�ǰ�Ŀͻ�������ʱ��
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