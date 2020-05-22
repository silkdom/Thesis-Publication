function [EM] = fsort(SZ,input,nComp,pure,min,delete)

% © 2018 Dominic Silk

% determining highest normalized adjascent pair property ratio
% delete are the infeasible tasks determined in TaskGen refine step
for i=1:SZ 
    input(i,7)=input(i,5)/input(i+1,5); % calculate property ratio
    input(i,4)=input(i+1,3); % pair the adjascent components
    input(i,6)=input(i+1,5); 
    if i<nComp
       input(i,8)=i; % inital ordering
    else
       input(i,8)=input(i-nComp+1,8); % ordering the rest
    end
    if input(i,2)~=input(i+1,2) % if component that is ranked highest rank
        input(i,4)=pure; %pair it with "pure" 
        input(i,7)=0.1; % tag
        input(i,6)=0.1; % tag        
    end     
end
% last datapoint clause
input(SZ+1,4)=pure;
input(SZ+1,8)=nComp-1;
input(SZ+1,7)=0.1;

% if the component has the lowest rank. a "pure" pairing must created
AA=zeros(1,8);
for i=1:SZ
    if input(i,8)==1
       input=[input(1:i,:);AA;input(i+1:end,:)];
       input(i+1,2)=input(i,2);
       input(i+1,3)=pure;
       input(i+1,4)=input(i,3);
       input(i+1,5)=0.1;
       input(i+1,6)=input(i,5);
       input(i+1,7)=0.1;
       SZ=SZ+1;
    end
end

% normalization of the ratios occurs
% infeasible tasks from TaskGen to be implemented
Desz=size(delete,1);
for i=1:SZ
    for j=1:18
     if input(i,2)==min(j,1) && input(i,7)~=0.1 % don't select "pure"
         input(i,7)=input(i,7)/min(j,2); % normalize with min ratios
         break
     end
    end
    
    for k=1:Desz
       if input(i,3)==delete(k,1) && input(i,4)==delete(k,2) && input(i,2)==delete(k,3)
       input(i,7)=.99; % sabotage the ratio. cannot be highest at 0.99
       end
    end    
end

% rank from highest to lowest normalized adjascent property ratio
input=sortrows(input,7,'descend');

% set indices
for i=1:SZ+1
   input(i,1)=i;
   input(i,9)=0;
end
EM=input; % send back to main function
end

