%% Description

% 1. This function returns the objectix_nume functions f1, and f2 in the x_numector 'fit' and
%    constraints in the x_numector 'c' for the chromosome 'x'. 
% 2. 'x_num' is the number of optimization x_numariables. 
% 3. All the constraints 'c' are conx_numerted to the form h(x)<=0. 
% 4. Nine unconstrained test probems are used (p=1 to p=9)
% 5. Fix_nume constrained test problems are used   (p=10 to p=14)
% 6. Refer abox_nume references for the details of each test problem: number of objectix_numes, number of design x_numariabes, their lower and upper limits, 
%    number of constraints, type of constraints etc,.

%% reference
% 1. BINH, Thanh. "A multiobjectix_nume ex_numolutionary algorithm. The study cases".
%    Technical report. Barleben, Germany. 1999.
% 2. DEB, Kalyanmoy. "Multi-Objectix_nume optimization using ex_numolutionary
%    algorithms". John Wiley & Sons, LTD. Kanpur, India. 2004.

function [fit, err] = object_fun(x)
    global p x_num
    %参数设置
    p=input('Testproblem index  :');
    if p==13,  % OSY
       pop_size=100; 
       no_runs=10;
    end;                   
    if (p==2 | p==5 | p==7), gen_max=1000; end;

    if p<=9     % Unconstrained test functions
       tV=[2;30;3;1;30;4;30;10;10];
       x_num=tV(p);
       txl=[-5*ones(1,x_num);zeros(1,x_num);-5*ones(1,x_num);-1000*ones(1,x_num);zeros(1,x_num);-1/sqrt(x_num)*ones(1,x_num);zeros(1,x_num); 0 -5*ones(1,x_num-1);zeros(1,x_num)]; 
       txu=[10*ones(1,x_num); ones(1,x_num);5*ones(1,x_num);1000*ones(1,x_num);ones(1,x_num);1/sqrt(x_num) *ones(1,x_num);ones(1,x_num);1 5*ones(1,x_num-1);ones(1,x_num)];
       xl=(txl(p,1:x_num));            % lower bound x_numector
       xu=(txu(p,1:x_num));            % upper bound x_numectorfor 
       etac = 20;                  % distribution index for crossox_numer
       etam = 20;                  % distribution index for mutation / mutation constant       
    else         % Constrained test functions
       p1=p-9;
       tV=[2;2;2;6;2];
       x_num=tV(p1);
       txl=[0 0 0 0 0 0;-20 -20 0 0 0 0;0 0 0 0 0 0;0 0 1 0 1 0;0.1 0 0 0 0 0]; 
       txu=[5 3 0 0 0 0;20 20 0 0 0 0;pi pi 0 0 0 0;10 10 5 6 5 10;1 5 0 0 0 0];
       xl=(txl(p1,1:x_num));           % lower bound x_numector
       xu=(txu(p1,1:x_num));           % upper bound x_numectorfor i=1:NN
       etac = 20;                  % distribution index for crossox_numer
       etam = 100;                 % distribution index for mutation / mutation constant
    end
    
    pm=1/x_num;                     % Mutation Probability


    %% Unconstrained Test functions (for p=1 to p=9)
    if p==1     % Test case problem 1
        f1=(4*x(1)^2)+(4*x(2)^2);                       
        f2=((x(1)-5)^2)+((x(2)-5)^2);
        
    elseif p==2     % ZDT1 from Deb paper NSGA2
        cons=[0];
        f1 = x(1);
        g=1+(9*sum(x(2:x_num),2)/(x_num-1));            
        f2 = g*(1-sqrt(x(1)/g));  
        
    elseif p==3     % kUR from Deb
        f1=(-10*exp(-0.2*(sqrt(x(1)^2+x(2)^2))))+(-10*exp(-0.2*(sqrt(x(2)^2+x(3)^2))));
        f2=((abs(x(1))^0.8) + (5*sin(x(1))^3))+((abs(x(2))^0.8) + (5*sin(x(2))^3))+((abs(x(3))^0.8) + (5*sin(x(3))^3));
        
    elseif p==4    % SCH frm Deb paper
        f1=x.*x;
        f2=(x-2).^2;
        
    elseif p==5     % ZDT2
        f1 = (x(1));
        g=1+(9*sum(x(2:x_num),2)/(x_num-1));             
        f2 =((1-(x(1)/g)^2)); 
        
    elseif p==6     % Test case problem 2
        f1=1-exp(-sum((x-1/sqrt(x_num)).^2,2));
        f2=1-exp(-sum((x+1/sqrt(x_num)).^2,2));
        
    elseif p==7     % ZDT3
        f1 = x(1);                                 
        g=1+(9*sum(x(2:x_num),2)/(x_num-1));               
        f2 = (1-(sqrt(x(1)/g)) - ((x(1)/g)*sin(10*pi*x(1)))); 
        
    elseif p==8     % ZDT4       
        f1 = x(1);  temp=0;
        for ii = 2: x_num
            temp=temp+((x(ii))^2)-(10*cos(4*pi*x(ii)));
        end
        g= 1 + (10*(x_num-1)) + temp;           
        f2 = (1-sqrt(x(1)/g));
        
    elseif p==9     % ZDT6       
        f1 = 1-(exp(-4*x(1)))*(sin(6*pi*x(1)))^6; 
        g=1+(9*(sum(x(2:x_num),2)/(x_num-1))^0.25);        
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
        
    elseif p==11     %SRN  
        f1=(x(1)-2)^2+(x(2)-1)^2+2;
        f2=9*x(1)-(x(2)-1)^2;
        c(1,1)=x(1)^2+x(2)^2-225;
        c(1,2)=x(1)-(3*x(2))+10;
        err=(c>0).*c;
        
    elseif p==12     %TNK
        f1=x(1);
        f2=x(2);
        c(1,1)=-x(1)^2-x(2)^2+1+(0.1*cos(16*atan((x(1)/x(2))))); 
        c(1,2)=(x(1)-0.5)^2+(x(2)-0.5)^2-0.5;
        err=(c>0).*c;
        
    elseif p==13     % OSY 
        f1=-((25*(x(1)-2)^2)+((x(2)-2)^2)+((x(3)-1)^2)+((x(4)-4)^2)+((x(5)-1)^2));
        f2=(x(1)^2)+(x(2)^2)+(x(3)^2)+(x(4)^2)+(x(5)^2)+(x(6)^2);
        c(1,1)=-x(1)-x(2)+2;
        c(1,2)=-6+x(1)+x(2);
        c(1,3)=-2+x(2)-x(1);
        c(1,4)=-2+x(1)-3*x(2);
        c(1,5)=-4+((x(3)-3)^2)+x(4);
        c(1,6)=-((x(5)-3)^2)-x(6)+4;
        err=(c>0).*c;
        
    elseif p==14    % CONSTR
        f1=x(1);
        f2=(1+x(2))/(x(1));
        c(1,1)=-x(2)-(9*x(1))+6;
        c(1,2)=+x(2)-9*x(1)+1;
        err=(c>0).*c;
    end
    fit=[f1 f2];
end
