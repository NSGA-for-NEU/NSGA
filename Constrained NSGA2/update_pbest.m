function pbest = update_pbest(pop_size, offspring)
    % 合并父代个体和子代个体
    combined_population = [pop_size; offspring];
    % 对合并的个体进行非支配排序
    fronts = non_dominated_sort(combined_population);
    % 初始化pbest为父代个体
    pbest = pop_size;
    for i = 1:length(fronts)
        front = fronts{i};
        % 计算当前等级个体的拥挤度距离
        crowding_distance = calculate_crowding_distance(combined_population(front, :));
        % 更新pbest
        for j = 1:length(front)
            idx = front(j);
            pbest(idx, :) = combined_population(idx, :);
            pbest(idx).crowding_distance = crowding_distance(j);
        end
    end
end
