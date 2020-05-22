function [Task] = Masterfunc() % function name to be called by excel

% © 2018 Dominic Silk

input=xlsread('TaskGen',1,'A2:E151'); % property data input
delete=xlsread('TaskGen',2,'P5:R12'); % infeasible task input
mxComp=max(input,[],1); % number of components
nComp=mxComp(3)+1; % additional "component" to allow min/max values to have a property ratio
pure=12; % identification tag for pure components 

% allows for simple data import
for i=1:150
   if input(i,2)==0
      input(i:150,:)=[]; 
      break
   end
end

% minimum respective property ratio for feasible separation
min=[1,1.05000000000000;2,1.07000000000000;3,2;4,1.10000000000000;5,1.90000000000000;6,1.40000000000000;...
    7,1.08000000000000;8,1.05000000000000;9,1.10000000000000;10,1.50000000000000;11,1.20000000000000;13,30;...
    14,1.10000000000000;15,1.01000000000000;16,1.05000000000000;21,1;22,1.20000000000000;24,1.57000000000000];

% basic data sorting and size detrmination
input=sortrows(input,5,'descend');
input=sortrows(input,2);
SZ=size(input,1)-1;

% complex data sorting. Provides highest normalized adjascent property ratio
[EM]=fsort(SZ,input,nComp,pure,min,delete); % evaluation matrix formation
SZ=size(EM,1)-1;

% initialization
count=1;
Bot=zeros(1,1,6); % task bottom components
Task=zeros(20,14); % task matrix for each iteration
SZ2=SZ+1;
Top=zeros(SZ2,9,20); % compiled matrix of top components for each task
ts=9; % starting coulmn for task matrix addition
rem=10.01; % identification tag for components to be removed due to redundancy
place=1; % number of tasks - number of purified components

for i=1:63 %set to variable later
    EM(any(EM==rem,2),:)=[]; % delete redundancies
    EM(any(EM==100,2),:)=[]; % delete redundancies
    SZ=size(EM,1); 
    
    %New property ratio ranking,incorporating redundancy removal
    if i>1
        un=EM(:,3:4); 
        UN=unique(un); % determine remaining components
        nComp=length(UN); % determine number of remaining components
        input2=input;     
        %identifying remaining components in input matrix
        for k=1:63 
            for j=1:nComp
                if input2(k,3)==UN(j)
                    input2(k,1)=0.1;
                    input2(k,4)=0.1;
                end
            end
        end
        % remove redundant components in input matrix
        input2(any(input2==0,2),:)=[];
        SZ=size(input2,1)-1;
        % sort new input matrix for next task
        [EM]=fsort(SZ,input2,nComp,pure,min,delete);
        SZ=size(EM,1);
    end
     
    rem=EM(1,1)+0.01; % identification tag for removal next iteration
    % reinitialize task matrices for each iteration
    split=zeros(8,8);
    idT=zeros(1,8); % indices identification of binary pairs exiting the top of the task
    idA=zeros(1,8); % identification of A components exiting the top of the task
    idB=zeros(1,8); % identification of B components exiting the top of the task
    splitT=zeros(8,8); % Binary pairs exiting top of task
    prop=EM(1,2); % exploited property for task operation
    k=1; % reinitialize counter
    
    % setting up split matrix for the exploited property
    for j=1:SZ
        if EM(j,2)==prop
            split(k,1:8)=EM(j,1:8);
            k=k+1;
        end
    end
    
    % identifying componenets that go out the top of a task
    for j=1:nComp
        if split(j,8)>EM(1,8) % if the property value is greater than the split
            splitT(j,:)=split(j,:); % split top matrix 
            idT(j)=splitT(j,1); % indices of top bianry pairs
        elseif split(j,3)<pure
            Bot(j,1,count)=split(j,3); % components exiting bottom of task   
        end
    end
    
    %Identifying top components in evaluation matrix
    for j=1:nComp
        for ii=1:SZ
            if EM(ii,1)==idT(j)
                idA(j)=EM(ii,3); 
                idB(j)=EM(ii,4);
            end
        end
    end
    
    % Tagging top components for deletion in next iteration. 100 = tag
    % Identifying puried components
    for ii=1:SZ
        for j=1:nComp
            if EM(ii,3)==idA(j) && idA(j)<pure
                EM(ii,ts)=100;
            end
            if EM(ii,3)==idB(j) && idB(j)<pure
                EM(ii,ts)=100;
            end
            
            if EM(ii,4)==idB(j) && idB(j)<pure
                EM(ii,ts)=100;
            end
            if EM(ii,4)==idA(j) && idA(j)<pure
                EM(ii,ts)=100;
            end
            % saving top component stream for later iterations if not pure
            for J=1:nComp
                if EM(ii,3)==idA(j) || EM(ii,3)==idB(j)
                    if EM(ii,4)==idB(J) || EM(ii,4)==idA(J)
                        EM(ii,ts)=rem;
                        Top(ii,1:8,count)=EM(ii,1:8);
                        Top(ii,9,count)=EM(ii,ts);
                    end
                end
                if EM(ii,3)==idA(J) || EM(ii,3)==idB(J)
                    if EM(ii,4)==idB(j) || EM(ii,4)==idA(j)
                        EM(ii,ts)=rem;
                        Top(ii,1:8,count)=EM(ii,1:8);
                        Top(ii,9,count)=EM(ii,ts);
                    end
                end
            end
            % making sure redundancies are propagated
            if EM(ii,ts-1)==100
                EM(ii,ts)=100;
            end  
        end
    end
    
    % skip next iteration if top stream purified - assume recovered
    if Top(1:SZ,7,count)<0.11 
        Task(count,1)=place;
        place=place+1;
    end
    Task(count,2)=EM(1,2); % providing reference for purified stream
    
    % add purified stream to top and task components streams
    % Move to next task down or saved stream in top matrix
    if EM(1:SZ,7)==0.1 % if bottom stream is purified, move to saved stream
        for ii=1:SZ
            Top(ii,1:8,count)=EM(ii,1:8);
            Top(ii,9,count)=rem;
        end
        
        % setting next iteration equal to a saved top stream
        for jjj=1:20
            if Task(jjj,1)==0
                Task(jjj,1)=0.1;
                if Task(count+1,1)==0.1
                    break
                end
                EM=zeros(SZ2,9);
                EM(:,:)=Top(:,:,jjj); % set evaluation matrix to saved stream
                EM(any(EM(:,1:7)==0,2),:)=[]; % delete redundancies
                EM(:,9)=0;
                break
            end
        end
    end
    
    % if all components are purified, exit loop. 
    if Task(count+1,1)==0.1
        break
    end
    count=count+1; % move to next task
end

% specifying the components particpating in each task
for c=1:count
    unT=Top(:,3:4,c);
    UNT=unique(unT);
    szT=size(UNT,1);
    for cc=2:szT-1
        Task(c,cc+1)=UNT(cc,1); % task top components
    end
    unB=Bot(:,:,c);
    UNB=nonzeros(unB);
    szB=size(UNB,1);
    Task(c,9:9+szB-1)=UNB; % task bottom components
end

% deleting pure tasks from task matrix
for c=1:count
    if Task(c,3)==Task(c,9)
        Task(c,:)=[];
    end
    Task(c,1)=0; % initializing task order
end

% mapping code. each possible number has an associated unique location
% initialization of order parameters
up=1; % count of up tasks
down=1; % count of down tasks
upO=0.1; % up order increment
upOi=1; % initial up order increment
downO=-0.1; % down order increment
downOi=-1; % initial down order increment
for c=2:count
    ID=nonzeros(Task(c,3:8)); % indentify task components
    
    % setting unique order for up branches of tasks
    for cc=up:count
        IDup=Task(cc,9:14);
        rel1=ismember(ID,IDup); % are the tasks related?
        if rel1==1
            if Task(cc,1)<0
                Task(c,1)=Task(cc,1)+upO; % set up order
                upO=upO/10; % increment up order
                up=up+1; % increment up count
                break
            else
                Task(c,1)=Task(cc,1)+upOi; % initial up order
                upOi=upOi/10; % increment up order
                up=up+1; % increment up count
                break
            end
        end
        
    end
    
    % setting unique order for down branches of tasks
    for cc=down:count
        if Task(c,1)~=0 % clause for feed task
            break
        end
        IDdown=Task(cc,3:8);
        rel2=ismember(ID,IDdown); % are the tasks related?
        if rel2==1
            if Task(cc,1)>0
                Task(c,1)=Task(cc,1)+downO; % set down order              
                downO=downO/10; % increment down order
                down=down+1; % increment down count
                break
            else
                Task(c,1)=Task(cc,1)+downOi; % initial down order              
                downOi=downOi/10; % increment down order
                down=down+1; % increment down count
                break
            end
        end     
    end 
end

% set rest of task table to zero
for OO=c:20
    Task(OO,:)=0;
end
end