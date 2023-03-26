clear
f_Feedb=0; % f_Feedb factor of Feedback to contral the feedback operation.
FB=50; %FB denotes ahead prediction step
TPW=[3200,500,200]; % training sets, testing set, set of washout 
M=500; % sample of NRMSE
resSize=1000; % number of reservoir node
data0=csvread('C:\Users\17519\Desktop\FD储备池\2022秋季学期实验\arfima\DATA\MackyG17.csv',1,0); % datasets
tic
for i=1:5
%% ESN
Lr=1;
De=0;
nrmse_ESN(i)=ADRC_main(De,Lr,f_Feedb,FB,resSize,M,TPW,data0);

%% Li_ESN
Lr=0.7;
De=0;
nrmse_LiESN(i)=ADRC_main(De,Lr,f_Feedb,FB,resSize,M,TPW,data0);

%% DEEP_ESN
La=10;
res=ones(1,La)*round(resSize/La);
Lr=1;
De=ones(1,La)*0;
nrmse_DESN(i)=ADRC_main(De,Lr,f_Feedb,FB,res,M,TPW,data0);

%% ADRC
La=10;
res=ones(1,La)*round(resSize/La);
Lr=1;
De=ones(1,La)*1;
De2=De*5;
De3=De*10;
nrmse_ADRC1(i)=ADRC_main(De,Lr,f_Feedb,FB,res,M,TPW,data0);
nrmse_ADRC2(i)=ADRC_main(De2,Lr,f_Feedb,FB,res,M,TPW,data0);
nrmse_ADRC3(i)=ADRC_main(De3,Lr,f_Feedb,FB,res,M,TPW,data0);
end
[mean(nrmse_ESN),mean(nrmse_LiESN),mean(nrmse_DESN),mean(nrmse_ADRC1),mean(nrmse_ADRC2),mean(nrmse_ADRC3)]
[min(nrmse_ESN),min(nrmse_LiESN),min(nrmse_DESN),min(nrmse_ADRC1),min(nrmse_ADRC2),min(nrmse_ADRC3)]
toc



