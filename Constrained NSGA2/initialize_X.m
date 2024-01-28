function chromo = initialize_X(pop_size,x_num,x_max)
%≥ı ºªØŒª÷√
    chromo = zeros(x_num,pop_size);
    for i=1:x_num
        for j = 1:pop_size
            chromo(i,j) = randperm(x_max(i),1)-1;
        end
    end
    chromo = chromo';
    for i = pop_size
        right = check_X(chromo(i,:), x_max);
        if right == -1
            for j = 1:x_num
                chromo(i,j) = randperm(x_max(j),1)-1;
            end
        end
    end
end