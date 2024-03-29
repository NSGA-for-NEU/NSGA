function [fit, err] = fname(x, x_max)     %x:长度为x_num
    data = xlsread('net14.xlsx');
    time_list = data(:, 5);
    fee_list = data(:, 6);
    
    test = [];
    for i = 1:length(x_max)
        if x_max(k) ~= 1
            if x(i) == 0 
                test = [test;1];
            else
                test = [test;0];
            end
        else
            if x(i) == 0
                test = [test;0;0];  
            elseif x(i) == 1
                test = [test;1;0];
            elseif x(i) == 2
                test = [test;0;1];  
            elseif x(i) == 3
                test = [test;1;1];  
            end
        end
    end
    
    filename = 'param.json';  % JSON文件名
    jsonStr = fileread(filename);  % 读取JSON文件内容
    jsonData = jsondecode(jsonStr);  % 解码JSON数据

    yuan = jsonData.yuan;
    time_cost1 = 0;
    time_cost2 = 0;
    for i = 1:length(test)
        if test(i) == 1 && data(i, 1) <= yuan
            time_cost1 = max(time_cost1, time_list(i));
        elseif test(i) == 1 && data(i, 1) > yuan
            time_cost2 = max(time_cost2, time_list(i));
        end
    end

    fee_cost = 0;
    for i = 1:length(test)
        if test(i) == 1 
            fee_cost = fee_cost + fee_list(i);
        end
    end
    %fit计算公式有待更新
    fit = time + fee_cost;
end
