clear all
clc
global Tj Dj  b  M x etac etam pop_size pm no_runs gen_max lamda_num yuan zhong hui node ac_node x_num x_min x_max v_max v_min

%% Description

% 1. This is the main program of NSGA II. It requires only one input, which is test problem
%    index, 'p'. NSGA II code is tested and verified for 14 test problems.
% 2. This code defines population size in 'pop_size', number of design
%    variables in 'V', number of runs in 'no_runs', maximum number of 
%    generations in 'gen_max', current generation in 'gen_count' and number of objectives
%    in 'M'.
% 3. 'xl' and 'xu' are the lower and upper bounds of the design variables.
% 4. Final optimal Pareto soutions are in the variable 'pareto_rank1', with design
%    variables in the coumns (1:V), objectives in the columns (V+1 to V+M),
%    constraint violation in the column (V+M+1), Rank in (V+M+2), Distance in (V+M+3).
%% code starts
format long

dt = datetime('now');   %��ʱ��ʼ

b=xlsread('net14.xlsx');    %��ȡ��������
yuan = 3;   %����Ľڵ���
zhong = 5;
hui = 6;
node = 14;
ac_node=2+yuan+zhong*2+hui;
M = 2;%Ŀ�꺯���ĸ���
x_num = yuan*zhong+zhong*hui;  %���߱�������
A = [0 0 0 2 2 2 1 2 0 0 0 0 0 0;
     0 0 0 2 1 2 1 2 0 0 0 0 0 0;
     0 0 0 1 2 1 2 2 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 1 2 1 1 1 2;
     0 0 0 0 0 0 0 0 2 1 2 2 1 1;
     0 0 0 0 0 0 0 0 1 2 1 2 2 1;
     0 0 0 0 0 0 0 0 2 1 1 2 1 2;
     0 0 0 0 0 0 0 0 2 2 1 2 1 1;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0]; %14�ڵ��ڽӾ���
x_min = zeros(1,x_num);  %ȷ�����߱���ȡֵ��Χ
x_max = zeros(1,x_num);
k = 0;
for i=1:node
    for j=1:node
        if A(i,j)~=0
            k = k+1;
            x_max(k) = 2^A(i,j)-1;
        end
    end
end 
v_min = ones(1,x_num)*0.2;  %ȷ���ٶ�ȡֵ��Χ
v_max = ones(1,x_num)*0.8;
w = 0.8;  %����Ȩ��
c1=2.05;  %����ѧϰ����
c2=2.05;  %���ѧϰ����
lamda_num =100;
pop_size= 100;%��Ⱥ��
T=10;     %����Χ round(lamda_num/20); 
Tj = [100 100 100 100 100 100];  %�ͻ�Ҫ��ĵ���ʱ�� 70*j��
Dj = [50 30 40 40 30 40];  %�ͻ���������[30 40 50] [30 50 40 40 30 30 40 50 30] [50 30 40 40 30 40]
no_runs = 10;%����ѭ������
gen_max=500;%����������

etac = 20;%��������ķֲ�ָ��
etam = 100;%��������ķֲ�ָ��
pm = 0.7;%������
Q = [];%��ÿ��ѭ���õ���������ǰ�ر���
%------------------------��ʼ��--------------------------
lamda = genrate_lamda( lamda_num,M );%����һ����ȷֲ���Ȩ������
B=look_neighbor(lamda,T);%������������Ȩ���������ŷʽ���룬����ÿ��Ȩ���������T��Ȩ������������
ref_point = [0,-1];%�㷨�еĲο���  
for run = 1:no_runs
    %��ʼ����Ⱥ��
    %�ڿ��пռ�������������ʼ��Ⱥ 
    x=initialize_X(pop_size,x_num,x_max);
    V=initialize_V(pop_size,x_num,v_min,v_max);
        
    %��ʼ����������ֵ
    pbest = zeros(pop_size,x_num);
    pbest = x;
    pbest_f = zeros(pop_size,M);
    x_f = zeros(pop_size,M);
    for i = 1:pop_size
        [x_f(i,1),x_f(i,2)]=minfree_maxflow(b,lamda(i,:),x(i,:),yuan,zhong,hui,ac_node,x_max,Tj,Dj);
    end  %����Ŀ�꺯��ֵ
    pbest_f = x_f;
    flag = deterdomination(pbest_f, pop_size, M, x_num);% ��֧������
    EP = [];% EPΪ��֧��⼯
    for i = 1:pop_size
        if flag(i) == 1
            EP = [EP; x_f(i,:), i, x(i,:)];
        end
    end
    for i =1:pop_size
      [ff(i,:) ,err(i,:)] = fname(x(i, :), x_max);           % Ŀ�꺯������
    end
    error_norm=normalisation(err);
    population_init=[x ff error_norm];
    [population ,front]=NDSCD_cons(population_init);
    %������ʼ
    for gen_count=1:gen_max
        % ѡ��
        parent_selected=binary_tour_selection(population);%���������ѡ��
        % ��ֳ�����ɺ��
        child_offspring  = genetic_operator(parent_selected(:,1:x_num ));
        for i =1:pop_size
          [fff(i,:) err(i,:)] = fname(x(i, :), x_max);           % Objective function evaulation 
        end
        error_norm=normalisation(err);
        child_offspring=[child_offspring fff error_norm];
        %�Ӵ��븸���ϲ�����Ⱥ��Ϊ2N
        population_inter=[population(:,1:x_num +M+1) ; child_offspring(:,1:x_num +M+1)];
        [population_inter_sorted front]=NDS_CD_cons(population_inter);%��֧������򲢼���ۼ�����
        %��Ӣ��������ѡ��N�����壬����µ�һ����Ⱥ
        new_pop=replacement(population_inter_sorted, front);
        population=new_pop;
    end
    paretoset(run).trial=new_pop(:,1:x_num +M+1);
    Q = [Q; paretoset(run).trial]; 
end
%------------------------����ָ�꼰������--------------------------    
dt2 = datetime('now');   %��ʱ����

EP = unique(EP,'rows'); 
EP = sortrows(EP,1);
%��ͼ������
plot(EP(:,1),EP(:,2)*(-1),'-o');
hold on;
% saveas(gcf,'C:\Users\Administrator\Desktop\9net\myfig.jpg');
%��������ָ��Time
Time = dt2 - dt;
%��������ָ��HV
HV_value = HV(EP,r); 
%��������ָ��Spacing
if number ~= 1
    Spacing_value = Spacing(EP);
    evaluation = [HV_value Spacing_value Time];
else
    evaluation = [HV_value 0 Time];
end
%% ���㳬���������Hypervolume��ָ��
pop = sortrows(new_pop,x_num +1);
index = find(pop(:,x_num +M+2)==1);
non_dominated_front = pop(index,x_num +1:x_num +2);
hypervolume(gen_count+1) = Hypervolume(non_dominated_front,ref_point);
plot(non_dominated_front(:,1),non_dominated_front(:,2),'*')
set(gca,'YScale','log')
title('NSGAII: Tradeoff')
xlabel('objective function 1')
ylabel('objective function 2')
axis square
drawnow
pause(1)

% ������������
if run==1
    index = find(new_pop(:,x_num +M+2)==1);
    non_dominated_front = new_pop(index,x_num +1:x_num +2);
    plot(non_dominated_front(:,1),non_dominated_front(:,2),'*')
else                                        
    [pareto_filter front]=NDS_CD_cons(Q);               % Applying non domination sorting on the combined Pareto solution set
    rank1_index=find(pareto_filter(:,x_num +M+2)==1);        % Filtering the best solutions of rank 1 Pareto
    pareto_rank1=pareto_filter(rank1_index,1:x_num +M);
    plot(pareto_rank1(:,V+1),pareto_rank1(:,x_num +2),'*')   % Final Pareto plot
end
xlabel('objective function 1')
ylabel('objective function 2')
