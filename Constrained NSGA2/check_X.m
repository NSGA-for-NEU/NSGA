function right = check_X(wrong, x_max) %yuan*zhong+zhong*hui
% wrong运算规则: startpoint*zhong + 
    data = xlsread('net14.xlsx');
    startpoint = data(1, :);
    endpoint = data(2, :);
    way = data(3, :);
    capacity = data(4, :);

    %拉抻wrong序列， 达到和way长度一致
    test = [];
    for i = 1:length(x_max)
        if x_max(k) ~= 1
            if wrong(i) == 0 
                test = [test;1];
            else
                test = [test;0];
            end
        else
            if wrong(i) == 0
                test = [test;0;0];  
            elseif wrong(i) == 1
                test = [test;1;0];
            elseif wrong(i) == 2
                test = [test;0;1];  
            elseif wrong(i) == 3
                test = [test;1;1];  
            end
        end
    end

    for i = 2:20 % 编号从2到20是14节点网络
        indices_start = find(startpoint == i);
        indices_end = find(endpoint == i);

        result_start = 0;
        for j = 1:length(indices_start)
            if test(indices_start(j)) == 1
                result_start = result_start + capacity(indices_start(j));
            end
        end
        result_end = 0;
        for j = 1:length(indices_end)
            if test(indices_end(j)) == 1
                result_end = result_end + capacity(indices_start(j));
            end
        end
        if result_start > result_end
            right = -1;
        end
    end
end