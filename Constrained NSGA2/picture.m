function picture(sjr, tj, a, b, c)
%time 实际送达时间
%tj 客户要求送达时间
%fee 费用
%a，b，c期望函数里的常数
numIterations = 10; % 设置迭代次数（根据每张图绘制曲线个数不同调整）
for iteration = 1:numIterations
[~, ~, time, fee] = fname(); 
% 根据tj和time计算sj
sj = (tj - time) ./ tj;
% 计算v
v = zeros(size(sj)); % 预分配v的数组，大小与sj相同
for i = 1:length(sj)
if sj(i) >= sjr(i)
v(i) = (sj(i) - sjr(i))^a;
else
v(i) = -(sjr(i) - sj(i))^b * c;
end
% 计算v的平均值并赋给变量s
s = mean(v);
% 绘制fee和s图
figure;
plot(fee, s, 'ro-');
xlabel('网络总费用/万元');
ylabel('客户满意度的负值');
title('');%根据每个不同的图加上即可
xticks(0:0.05:1);
yticks(0:0.02:1);
% 添加图例（根据不同的图的要求换）
legend(['sjr = ', num2str(sjr(1))], ['sjr = ', num2str(sjr(2))], ['sjr = ', num2str(sjr(3))], ['sjr = ', num2str(sjr(4))], ['sjr = ', num2str(sjr(5))]);
end
end
