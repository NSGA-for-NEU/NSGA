function A=compresstable2matrix_digraph_value_g(b)
    [n, ~]=size(b);
    m=max(max(b(:,1:2)));
    dm=max(max(b(:,3)));
    A=zeros(m,m,dm);

    for i=1:n
        A(b(i,1),b(i,2),b(i,3))=b(i,7);   %����ͼ��ת��
    end

end
