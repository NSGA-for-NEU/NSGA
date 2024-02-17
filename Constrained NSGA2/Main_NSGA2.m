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

dt = datetime('now');   %计时开始

b=xlsread('net14.xlsx');    %读取网络数据
yuan = 3;   %网络的节点数
zhong = 5;
hui = 6;
node = 14;
ac_node=2+yuan+zhong*2+hui;
M = 2;%目标函数的个数
x_num = yuan*zhong+zhong*hui;  %决策变量个数
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
     0 0 0 0 0 0 0 0 0 0 0 0 0 0]; %14节点邻接矩阵
x_min = zeros(1,x_num);  %确定决策变量取值范围
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
v_min = ones(1,x_num)*0.2;  %确定速度取值范围
v_max = ones(1,x_num)*0.8;
w = 0.8;  %惯性权重
c1=2.05;  %个体学习因子
c2=2.05;  %社会学习因子
lamda_num =100;
pop_size= 100;%种群数
T=10;     %邻域范围 round(lamda_num/20); 
Tj = [100 100 100 100 100 100];  %客户要求的到达时间 70*j个
Dj = [50 30 40 40 30 40];  %客户的需求量[30 40 50] [30 50 40 40 30 30 40 50 30] [50 30 40 40 30 40]
no_runs = 10;%过程循环次数
gen_max=500;%最大迭代次数

etac = 20;%交叉操作的分布指标
etam = 100;%编译操作的分布指标
pm = 0.7;%变异率
Q = [];%将每次循环得到的帕累托前沿保存
%------------------------初始化--------------------------
lamda = genrate_lamda( lamda_num,M );%生成一组均匀分布的权重向量
B=look_neighbor(lamda,T);%计算任意两个权重向量间的欧式距离，查找每个权向量最近的T个权重向量的索引
ref_point = [0,-1];%算法中的参考点  
for run = 1:no_runs
    %初始化种群数
    %在可行空间均匀随机产生初始种群 
    x=initialize_X(pop_size,x_num,x_max);
    V=initialize_V(pop_size,x_num,v_min,v_max);
        
    %初始化个体最优值
    pbest = zeros(pop_size,x_num);
    pbest = x;
    pbest_f = zeros(pop_size,M);
    x_f = zeros(pop_size,M);
    for i = 1:pop_size
        [x_f(i,1),x_f(i,2)]=minfree_maxflow(b,lamda(i,:),x(i,:),yuan,zhong,hui,ac_node,x_max,Tj,Dj);
    end  %计算目标函数值
    pbest_f = x_f;
    flag = deterdomination(pbest_f, pop_size, M, x_num);% 非支配排序
    EP = [];% EP为非支配解集
    for i = 1:pop_size
        if flag(i) == 1
            EP = [EP; x_f(i,:), i, x(i,:)];
        end
    end
    for i =1:pop_size
      [ff(i,:) ,err(i,:)] = fname(x(i, :), x_max);           % 目标函数评估
    end
    error_norm=normalisation(err);
    population_init=[x ff error_norm];
    [population ,front]=NDSCD_cons(population_init);
    %迭代开始
    for gen_count=1:gen_max
        % 选择
        parent_selected=binary_tour_selection(population);%二项锦标赛选择
        % 繁殖，生成后代
        child_offspring  = genetic_operator(parent_selected(:,1:x_num ));
        for i =1:pop_size
          [fff(i,:) err(i,:)] = fname(x(i, :), x_max);           % Objective function evaulation 
        end
        error_norm=normalisation(err);
        child_offspring=[child_offspring fff error_norm];
        %子代与父代合并，种群数为2N
        population_inter=[population(:,1:x_num +M+1) ; child_offspring(:,1:x_num +M+1)];
        [population_inter_sorted front]=NDS_CD_cons(population_inter);%非支配解排序并计算聚集距离
        %精英保留策略选出N个个体，组成新的一代种群
        new_pop=replacement(population_inter_sorted, front);
        population=new_pop;
    end
    paretoset(run).trial=new_pop(:,1:x_num +M+1);
    Q = [Q; paretoset(run).trial]; 
end
%------------------------评价指标及结果输出--------------------------    
dt2 = datetime('now');   %计时结束

EP = unique(EP,'rows'); 
EP = sortrows(EP,1);
%绘图并保存
plot(EP(:,1),EP(:,2)*(-1),'-o');
hold on;
% saveas(gcf,'C:\Users\Administrator\Desktop\9net\myfig.jpg');
%计算评价指标Time
Time = dt2 - dt;
%计算评价指标HV
HV_value = HV(EP,r); 
%计算评价指标Spacing
if number ~= 1
    Spacing_value = Spacing(EP);
    evaluation = [HV_value Spacing_value Time];
else
    evaluation = [HV_value 0 Time];
end
%% 计算超立方体积（Hypervolume）指标
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

% 绘制帕累托面
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
