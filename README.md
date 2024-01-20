# NSGA
b  %读取网络数据
yuan zhong hui node   %网络的节点数
M  %目标函数的个数
x_num = yuan*zhong+zhong*hui;  %决策变量个数
x_min  x_max  %确定决策变量取值范围
v_min v_max  %确定速度取值范围
pop_size  %种群数
T  %邻域范围 round(lamda_num/20); 
w = 0.8;  %惯性权重
c1=2.05;  %个体学习因子
c2=2.05;  %社会学习因子
Tj = [100 100 100 100 100 100];  %客户要求的到达时间 70*j个
Dj = [50 30 40 40 30 40];  %客户的需求量[30 40 50] [30 50 40 40 30 30 40 50 30][50 30 40 40 30 40]
no_runs  %过程循环次数
gen_max  %最大迭代次数
pm   %变异率
