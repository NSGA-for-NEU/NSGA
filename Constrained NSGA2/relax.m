%边缘松弛，使用更短的距离作为节点的值
function [S, pa,pa_d]=relax(S,pa,A,visit,index,m,dm,pa_d)
   
   i=index;
   for j=1:m
       for k=1:dm
           if A(i,j,k)~=Inf && visit(j)~=1   %搜索没有标记过的节点
               if S(j)>S(i)+A(i,j,k)         %将较小的值赋给正在搜寻的节点
                S(j)=S(i)+A(i,j,k);
                pa(j)=i;
                pa_d(j)=k;
               end
           end
       end

   end