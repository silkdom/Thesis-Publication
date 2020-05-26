function [Rxn] = Reaction()

% © 2018 Dominic Silk

%MM=table2array(Single3);
OG=xlsread('TaskGen',1,'CH3:CL152');
De=xlsread('TaskGen',2,'P5:R12');
mx=max(OG,[],1);
n=mx(3)+1;
for or=1:150
   if OG(or,2)==0
      OG(or:150,:)=[]; 
      break
   end
end
%OG=zeros(63,5);
%OG=table2array(NoOrder2); % proof  % CHANGE NUMBER OF VAR
%OG=table2array(NoOrder2); % case
%min=xlsread('Flowsheet_master',5,'A2:B19');
%min=table2array(min1);
min=[1,1.05000000000000;2,1.07000000000000;3,2;4,1.10000000000000;5,1.90000000000000;6,1.40000000000000;7,1.08000000000000;8,1.05000000000000;9,1.10000000000000;10,1.50000000000000;11,1.20000000000000;13,30;14,1.10000000000000;15,1.01000000000000;16,1.05000000000000;21,1;22,1.20000000000000;24,1.57000000000000];
OG=sortrows(OG,5,'descend');
OG=sortrows(OG,2);
SZ=size(OG,1)-1;

 %NUMBER OF COMPONENTS +1 % havent been changing n!
m=12; %
[NO]=fsort(SZ,OG,n,m,min,De);
SZ=size(NO,1)-1;

%SZ=63;
C=1;

TT=zeros(1,1,6);

%Sep=zeros(54,2);
Rxn=zeros(20,14);
SZZZ=SZ+1;
Top=zeros(SZZZ,9,20); %20 is arbritray
%Bot=zeros(54,8);
%need to store MM
KK=9;
P=1;
IN=10.01;

for i=1:63 %set to variable later
    NO(any(NO==IN,2),:)=[];
    NO(any(NO==100,2),:)=[];
    SZ=size(NO,1);
    
    %Re-ratio here
    if i>1
        un=NO(:,3:4);
        UN=unique(un);
        n=length(UN);
        OG2=OG;
        for u=1:10
            for v=1:n
                if OG2(u,3)==UN(v)
                    OG2(u,1)=0.1;
                    OG2(u,4)=0.1;
                end
            end
        end
        
        OG2(any(OG2==0,2),:)=[];
        SZ=size(OG2,1)-1;
        
        [NO]=fsort(SZ,OG2,n,m,min,De);
        SZ=size(NO,1); % Not adding KK's
    end
    
    
    
    IN=NO(1,1)+0.01;
    UU=zeros(8,8);
    dummy2=zeros(1,8);
    dummy3=zeros(1,8);
    dummy4=zeros(1,8);
    
    SS=zeros(8,8);
    %dummy3=zeros(1,54);
    
    dummy=NO(1,2);
    
    k=1;
    
    %if NO(i,KK)==100
    %  continue
    %end
    %KK=KK+1;
    %Sep(i,1)=i;
    
    %if NO(i,8)==6
    %dummy3(1,7)=NO(i,4);
    %dummy4(1,7)=NO(i,4);
    %Sep(i,2)=MM(i,4);
    %end
    %if i==5
    %   NO(6,2)=6;
    %  NO(15,2)=6;
    %end
    
    for j=1:SZ
        if NO(j,2)==dummy
            UU(k,1:8)=NO(j,1:8);
            k=k+1;
        end
    end
    % ADDING ten miight not be the best
    
    
    for l=1:n
        if UU(l,8)>NO(1,8) %|| UU(l,6)==MM(i,6)  % ONLY NEED GREATER I THINK %%NEED a case for split=6
            SS(l,:)=UU(l,:);
            %SS(l-1,:)=UU(l-1,:); % wrong
            
            dummy2(l)=SS(l,1); % gives indices of compA's going out top
        elseif UU(l,3)<m
            TT(l,1,C)=UU(l,3);
            
        end
    end
    
    for r=1:n
        for ii=1:SZ
            if NO(ii,1)==dummy2(r)
                % NOT PROPERTY, COMPOUND!
                dummy3(r)=NO(ii,3); % and 4
                dummy4(r)=NO(ii,4);
            end
        end
    end
    % have to do compound not property
    %%USE U
    
    for iii=1:SZ
        for I=1:n
            
            %if MM(iii,3)~=dummy3(I) || MM(iii,4)~=dummy4(I) %might need to do reverse orde
            if NO(iii,3)==dummy3(I) && dummy3(I)<m
                NO(iii,KK)=100;
            end
            if NO(iii,3)==dummy4(I) && dummy4(I)<m
                NO(iii,KK)=100;
            end
            
            if NO(iii,4)==dummy4(I) && dummy4(I)<m
                NO(iii,KK)=100;
                %Bot(iii,:)=MM(iii,:);
            end
            if NO(iii,4)==dummy3(I) && dummy3(I)<m
                NO(iii,KK)=100;
                %Bot(iii,:)=MM(iii,:);
            end
            
            %end
            
            for J=1:n
                if NO(iii,3)==dummy3(I) || NO(iii,3)==dummy4(I)%This is okay now
                    if NO(iii,4)==dummy4(J) || NO(iii,4)==dummy3(J)
                        NO(iii,KK)=IN;
                        %Out(i,iii,:)=NO(iii,:);
                        Top(iii,1:8,C)=NO(iii,1:8);
                        Top(iii,9,C)=NO(iii,KK);
                    end
                end
                if NO(iii,3)==dummy3(J) || NO(iii,3)==dummy4(J) %This is okay now
                    if NO(iii,4)==dummy4(I) || NO(iii,4)==dummy3(I)
                        NO(iii,KK)=IN;
                        %Out(i,iii,:)=NO(iii,:);
                        Top(iii,1:8,C)=NO(iii,1:8);
                        Top(iii,9,C)=NO(iii,KK);
                    end
                end
            end
            
            if NO(iii,KK-1)==100
                NO(iii,KK)=100;
            end
            
            
            
            
            
            
            
            
        end
        
        
        
    end
    
    if Top(1:SZ,7,C)<0.11 % figure how to skip 8 up and down
        Rxn(C,1)=P;
        P=P+1;
    end
    Rxn(C,2)=NO(1,2);
    %Z=1;
    %for iiii=2:sz
    %    Z=Z*NO(iiii,KK)*NO(iiii-1,KK);
    %end
    if NO(1:SZ,7)==0.1
        for iii=1:SZ
            Top(iii,1:8,C)=NO(iii,1:8);
            Top(iii,9,C)=IN;
        end
        
        
        for jjj=1:20
            if Rxn(jjj,1)==0
                Rxn(jjj,1)=0.1;
                if Rxn(C+1,1)==0.1
                    break
                end
                NO=zeros(SZZZ,9);
                NO(:,:)=Top(:,:,jjj);
                NO(any(NO(:,1:7)==0,2),:)=[]; %% CHANGE bcus I made my ratio for top
                NO(:,9)=0;
                %KK=8;
                break
            end
        end
    end
    %Now have rank 1 issue again! cheat by setting 8 - 4 BP and see what
    %happens. 8-4 dissapears?
    if Rxn(C+1,1)==0.1
        break
    end
    C=C+1;
end

ix=0;
IX=[0.34,0.34,0.34,0.34,0.34,0.34,0.34];
IXX=1;
dummy5=0;
ZS=2;
NNN=0.01;
%Sep(2,4)=4;
% to find going out, do same as Top matrix
for LL=1:C
    te=Top(:,3:4,LL);
    teUN=unique(te);
    ll=size(teUN,1);
    for ii=2:ll-1
        Rxn(LL,ii+1)=teUN(ii,1);
    end
    
    
    Te=TT(:,:,LL);
    TTUN=nonzeros(Te);
    Zs=size(TTUN,1);
    Rxn(LL,9:9+Zs-1)=TTUN;
    
    
end


for LL=1:C
    if Rxn(LL,3)==Rxn(LL,9)
        Rxn(LL,:)=[];
    end
    Rxn(LL,1)=0;
end

NN=1;
MM=1;
DD=0.1;
DD2=1;
EE=-0.1;
EE2=-1;
for LL=2:C
    IX=nonzeros(Rxn(LL,3:8));
    
    for LLL=NN:C
        BBC=Rxn(LLL,9:14);
        PPO=ismember(IX,BBC);
        if PPO==1
            if Rxn(LLL,1)<0
                Rxn(LL,1)=Rxn(LLL,1)+DD;
                DD=DD/10;
                NN=NN+1;
                break
            else
                Rxn(LL,1)=Rxn(LLL,1)+DD2;
                DD2=DD2/10;
                NN=NN+1;
                break
            end
        end
        
    end
    
    for III=MM:C
        if Rxn(LL,1)~=0 % for first one
            break
        end
        CBB=Rxn(III,3:8);
        PPO2=ismember(IX,CBB);
        if PPO2==1
            if Rxn(III,1)>0
                Rxn(LL,1)=Rxn(III,1)+EE; %was III              
                EE=EE/10;
                MM=MM+1;
                break
            else
                Rxn(LL,1)=Rxn(III,1)+EE2;               
                EE2=EE2/10;
                MM=MM+1;
                break
            end
        end
        
    end
    
    
end

for OO=LL:20
    Rxn(OO,:)=0;
end
%SepT=Sep
%SepT=array2table(Sep);
%[NO]=fsort(SZ,OG,n,min);
%xlswrite('Flowsheet_master',Sep,8,'A2:N21')
%writetable(SepT,'Flowsheet_master.xlsm','Sheet',8,'Range','A2:N21')
%{
    for ijk=3:5
        for kji=1:3
        if Sep(LL,ijk)==IX(1,kji)
        
         Sep(LL,1)=IXX+NNN+0.1;
         NNN=NNN+0.01;
        end
        end
    end
    
    if Sep(LL,4)>0
        %ix=Sep(LL-1,1)+1;
        Sep(LL,1)=Sep(LL,1)+ix;
        IX=Sep(LL,3:end); %chaneg to 7
        IXX=LL-1;
        ix=ix+1;
        % ZS=size(IX,1); need to fix
    end
    %\
 % See that I need to normalize ratios

%for ooo=1:6
%   TED(ooo,:)=unique(TT(:,2,ooo));
%end

%}









end

