%��Ե�ɳڣ�ʹ�ø��̵ľ�����Ϊ�ڵ��ֵ
function [S, pa,pa_d]=relax(S,pa,A,visit,index,m,dm,pa_d)
   
   i=index;
   for j=1:m
       for k=1:dm
           if A(i,j,k)~=Inf && visit(j)~=1   %����û�б�ǹ��Ľڵ�
               if S(j)>S(i)+A(i,j,k)         %����С��ֵ����������Ѱ�Ľڵ�
                S(j)=S(i)+A(i,j,k);
                pa(j)=i;
                pa_d(j)=k;
               end
           end
       end

   end