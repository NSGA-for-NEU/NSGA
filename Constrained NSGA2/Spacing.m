function Spacing_value = Spacing( EP )
[number,~] = size(EP);
dis = zeros(number,number);
di = zeros(1,number);
for i = 1:number
    for j = 1:number
        dis(i,j) = (EP(i,1)/10000-EP(j,1)/10000)^2 + (EP(i,2)-EP(j,2))^2;
        dis(i,j) = sqrt(dis(i,j));
    end
end
dis = sort(dis,2);
for i = 1:number
    di(i) = dis(i,2);
end
di_avg = sum(di(i))/number;
mysum = 0;
for i = 1:number
    mysum = mysum + (di_avg - di(i))^2;
end
Spacing_value = sqrt(mysum/(number-1));
end

