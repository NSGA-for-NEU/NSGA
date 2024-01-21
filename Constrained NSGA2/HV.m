function HV_value = HV( EP,z )
[number,~] = size(EP);
vol_sum = 0;
for i = 1:number
    vol_sum = vol_sum + ((EP(i,1)-z(1))/10000)*(EP(i,2)-z(2));
end
HV_value = vol_sum;
end

