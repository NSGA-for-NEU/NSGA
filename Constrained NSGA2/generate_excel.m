function [node_number] = generate_excel(node_number)
    %%待更新
    %设置相关参数
    A14 = [0 0 0 2 2 2 1 2 0 0 0 0 0 0;
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
    A9 = [];%九节点邻接矩阵
    if node_number == 14
        A = A14;
    elseif node_number == 9
        A = A9;
    end
    
    %本人设定excel内部顺序：
    %起点码-终点码-路径序号-运输量-等效时间消耗-等效费用消耗-？（学姐excel还有个啥参数来着）
    node_excel = [];
    for i = 1:node_number
        start = i;
        for j = 1:node_number
            finish = j;
            if A(i, j) ~= 0
                for k = 1:A(i, j)
                    way_listnumber = k;
                    capacity = randi([300 600]);%容量
                    time_cost = randi([20 50]);%时间
                    fee_cost = randi([1 100]);%费用
                    node_excel = [node_excel; start finish way_listnumber capacity time_cost fee_cost];
                end
            end
        end
    end
    
    filename = 'node.xlsx';  % Excel文件名
    sheet = 1;  % 工作表编号
    data = node_excel;
    xlswrite(filename, data, sheet);
end