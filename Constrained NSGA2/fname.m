function [fit, err] = fname(x)     %x:长度为x_num
    data = xlsread('net14.xlsx');
    time_list = data(5, : )
    
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
    
    for i = 1:length(test)
        
    end
end
