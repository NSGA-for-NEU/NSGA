function A=compresstable2matrix_digraph_value_c(b)
    [n, ~]=size(b);
    m=max(max(b(:,1:2)));
    dm=max(max(b(:,3)));
    A=Inf(m,m,dm);

    for i=1:n
        A(b(i,1),b(i,2),b(i,3))=b(i,4);   %有向图的转化
    end

end