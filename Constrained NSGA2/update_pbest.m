function pbest = update_pbest(pop_size, offspring)
    % �ϲ�����������Ӵ�����
    combined_population = [pop_size; offspring];
    % �Ժϲ��ĸ�����з�֧������
    fronts = non_dominated_sort(combined_population);
    % ��ʼ��pbestΪ��������
    pbest = pop_size;
    for i = 1:length(fronts)
        front = fronts{i};
        % ���㵱ǰ�ȼ������ӵ���Ⱦ���
        crowding_distance = calculate_crowding_distance(combined_population(front, :));
        % ����pbest
        for j = 1:length(front)
            idx = front(j);
            pbest(idx, :) = combined_population(idx, :);
            pbest(idx).crowding_distance = crowding_distance(j);
        end
    end
end
