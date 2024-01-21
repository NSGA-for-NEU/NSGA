%提取队列中尚未标记的最小的值的序号
function index=extract_min(S,visit,index,m)

    Mi=inf;
    for j=1:m
        if visit(j)~=1
           if S(j)<Mi
                Mi=S(j);
                index=j;
           end
        end
    end    

end