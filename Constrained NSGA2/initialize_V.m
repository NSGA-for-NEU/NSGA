function chromo_v = initialize_V(pop_size,x_num,v_min,v_max)
%��ʼ����Ⱥ�ٶ�
    chromo_v = repmat(v_min,pop_size,1)+rand(pop_size,x_num).*repmat(v_max-v_min,pop_size,1);
end

