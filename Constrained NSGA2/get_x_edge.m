function x_edge = get_x_edge( x,yuan,zhong,hui,x_max )
    %ªÒ»°x_edge
    x_edge = [];
    for i=1:yuan
        x_edge = [x_edge 1];
    end
    for i=1:yuan*zhong
        if x_max(i)==3
            x_edge = [x_edge mod(x(i),2) floor(x(i)/2)];
        else
            x_edge = [x_edge x(i)];
        end
    end
    for i=1:zhong
        x_edge = [x_edge 1];
    end
    for i=1:zhong*hui
        if x_max(i+yuan*zhong)==3
            x_edge = [x_edge mod(x(i+yuan*zhong),2) floor(x(i+yuan*zhong)/2)];
        else
            x_edge = [x_edge x(i+yuan*zhong)];
        end
    end
    for i=1:hui
        x_edge=[x_edge 1];
    end
end

