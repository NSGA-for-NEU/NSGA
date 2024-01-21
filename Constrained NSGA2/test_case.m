%% Description

% 1. This function returns the objective functions f1, and f2 in the vector 'fit' and
%    constraints in the vector 'c' for the chromosome 'x'. 
% 2. 'V' is the number of optimization variables. 
% 3. All the constraints 'c' are converted to the form h(x)<=0. 
% 4. Nine unconstrained test probems are used (p=1 to p=9)
% 5. Five constrained test problems are used   (p=10 to p=14)
% 6. Refer above references for the details of each test problem: number of objectives, number of design variabes, their lower and upper limits, 
%    number of constraints, type of constraints etc,.

%% reference
% 1. BINH, Thanh. "A multiobjective evolutionary algorithm. The study cases".
%    Technical report. Barleben, Germany. 1999.
% 2. DEB, Kalyanmoy. "Multi-Objective optimization using evolutionary
%    algorithms". John Wiley & Sons, LTD. Kanpur, India. 2004.

function [fit err]=test_case(x)
global p V
%% Unconstrained Test functions (for p=1 to p=9)
if p==1     % Test case problem 1
    f1=(4*x(1)^2)+(4*x(2)^2);                       
    f2=((x(1)-5)^2)+((x(2)-5)^2);               
end

if p==2     % ZDT1 from Deb paper NSGA2
    cons=[0];
    f1 = x(1);
       g=1+(9*sum(x(2:V),2)/(V-1));            
       f2 = g*(1-sqrt(x(1)/g));                  
end

if p==3     % kUR from Deb
    f1=(-10*exp(-0.2*(sqrt(x(1)^2+x(2)^2))))+(-10*exp(-0.2*(sqrt(x(2)^2+x(3)^2))));
    f2=((abs(x(1))^0.8) + (5*sin(x(1))^3))+((abs(x(2))^0.8) + (5*sin(x(2))^3))+((abs(x(3))^0.8) + (5*sin(x(3))^3));
end


if p==4    % SCH frm Deb paper
    f1=x.*x;
    f2=(x-2).^2;
end

if p==5     % ZDT2
    f1 = (x(1));
    g=1+(9*sum(x(2:V),2)/(V-1));             
    f2 =((1-(x(1)/g)^2));                
end   

if p==6     % Test case problem 2
    f1=1-exp(-sum((x-1/sqrt(V)).^2,2));
    f2=1-exp(-sum((x+1/sqrt(V)).^2,2));
end

if p==7     % ZDT3
    f1 = x(1);                                 
    g=1+(9*sum(x(2:V),2)/(V-1));               
    f2 = (1-(sqrt(x(1)/g)) - ((x(1)/g)*sin(10*pi*x(1))));               
end  

if p==8     % ZDT4       
    f1 = x(1);  temp=0;
    for ii = 2: V
        temp=temp+((x(ii))^2)-(10*cos(4*pi*x(ii)));
    end
    g= 1 + (10*(V-1)) + temp;           
    f2 = (1-sqrt(x(1)/g));                 
end  

if p==9     % ZDT6       
    f1 = 1-(exp(-4*x(1)))*(sin(6*pi*x(1)))^6; 
    g=1+(9*(sum(x(2:V),2)/(V-1))^0.25);        
    f2 = (1-(f1/g)^2);                     
end  
err= zeros(1,1);

%% Constrained Test functions (for p=10 to p=14)

if p==10     %BNH 
    f1=4*(x(1)^2)+4*(x(2)^2);
    f2=(x(1)-5)^2+(x(2)-5)^2;
    c(1,1)=(x(1)-5)^2 + x(2)^2 -25;
    c(1,2)=-(x(1)-8)^2-(x(2)+3)^2+7.7;
    err=(c>0).*c;
end
if p==11     %SRN  
    f1=(x(1)-2)^2+(x(2)-1)^2+2;
    f2=9*x(1)-(x(2)-1)^2;
    c(1,1)=x(1)^2+x(2)^2-225;
    c(1,2)=x(1)-(3*x(2))+10;
    err=(c>0).*c;
end
if p==12     %TNK
    f1=x(1);
    f2=x(2);
    c(1,1)=-x(1)^2-x(2)^2+1+(0.1*cos(16*atan((x(1)/x(2))))); 
    c(1,2)=(x(1)-0.5)^2+(x(2)-0.5)^2-0.5;
    err=(c>0).*c;
end

if p==13     % OSY 
    f1=-((25*(x(1)-2)^2)+((x(2)-2)^2)+((x(3)-1)^2)+((x(4)-4)^2)+((x(5)-1)^2));
    f2=(x(1)^2)+(x(2)^2)+(x(3)^2)+(x(4)^2)+(x(5)^2)+(x(6)^2);
    c(1,1)=-x(1)-x(2)+2;
    c(1,2)=-6+x(1)+x(2);
    c(1,3)=-2+x(2)-x(1);
    c(1,4)=-2+x(1)-3*x(2);
    c(1,5)=-4+((x(3)-3)^2)+x(4);
    c(1,6)=-((x(5)-3)^2)-x(6)+4;
    err=(c>0).*c;
end

if p==14    % CONSTR
    f1=x(1);
    f2=(1+x(2))/(x(1));
    c(1,1)=-x(2)-(9*x(1))+6;
    c(1,2)=+x(2)-9*x(1)+1;
    err=(c>0).*c;
end
fit=[f1 f2];

