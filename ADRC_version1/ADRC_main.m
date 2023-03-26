function nrmse_p=ADRC_main(De,Lr,f_Feedb,FB,resSize,M,TPW,data0)
%% 参数
global sparsity;  %稀疏度
sparsity=0.1;
global spectral_radius;  % 最大谱半径
spectral_radius=0.9;
global Delay; %时间延迟
Delay=De;
global  Leaky_rate
Leaky_rate=Lr;
input_dim=1;
output_dim=1;
n_layers=length(resSize);
discard=max(floor(TPW(1)/10),TPW(3));
T=sum(TPW(1:2));

%% 初始化
Training_data0=data0(FB+1:T+FB+1);
data=(data0-min(data0))./(max(data0)-min(data0)); %归一化
Input_streaming=data(1:T+1); %输入
Training_data=data(FB+1:T+FB+1); %输出


W_in=cell(1,n_layers);
W=cell(1,n_layers);
W_Feedb=cell(1,n_layers);
for i= 1:n_layers
    if i==1
        [W_in{i},W{i},W_Feedb{i}]=W_Generator(f_Feedb,input_dim,output_dim,resSize(i));
    else
        [W_in{i},W{i},W_Feedb{i}]=W_Generator(f_Feedb,resSize(i-1)+input_dim,output_dim,resSize(i));
    end
end

%% 训练阶段
[ State ] = Train_UpStates( Input_streaming,Training_data,TPW,W_in,W,W_Feedb,resSize );

%% 训练得出权重
State(end,:)=0;
XT=State(:,discard+1:end);YT=Training_data(discard+1:TPW(1));
reg = 1e-8;
W_out = ((XT*XT' + reg*eye(sum(resSize)+input_dim)) \ (XT*YT));

%% 预测阶段
State_end=State(:,end);
[ y] = Prediction_UpState(Input_streaming,Training_data,TPW,FB,State_end,W_in,W,W_Feedb,resSize,W_out);
%% 误差评估

trainLen=TPW(1);
testLen=TPW(2);
Y=y*(max(data0)-min(data0))+min(data0);
 Test_t=Y;Refernce_t=Training_data0(trainLen+1:trainLen+testLen);
nrmse_p=sqrt(mean((Test_t(1:M)-Refernce_t(1:M)).^2)/mean((Refernce_t(1:M)-mean(Refernce_t(1:M))).^2));%NRMSE;
% plot(Refernce_t(1:M),'b')
% hold on
% plot(Test_t(1:M),'r')
end