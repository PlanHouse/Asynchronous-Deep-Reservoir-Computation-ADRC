function [ State ] = Train_UpStates( Input_streaming,Training_data,TPW,W_in,W,W_Feedb,resSize )
%UNTITLED8 此处显示有关此函数的摘要
%   此处显示详细说明
%% this is the train stage function.
global D_state;
global Delay;
global Leaky_rate;
trainLen=TPW(1);
n_layers=length(resSize);
State1_n_1=cell(n_layers,1);
State1=cell(n_layers,1);
for i=1:n_layers
    State1{i}=zeros(resSize(i),trainLen);
    State1_n_1{i}=State1{i}(:,1);
    D_state{i}=zeros(resSize(i)+1,sum(Delay(1:i)));  %% D_state is used to temporarily store the state of the reservoir between adjacent layers.
end
Output_pattern=0;
State=zeros(sum(resSize)+1,trainLen);
Temp=zeros(sum(resSize),1);

for i=1:trainLen
    Temp=0*Temp;
    for n=1:n_layers
        if n==1
            Input_pattern1=Input_streaming(i);
            [State1_n] = Update(State1_n_1{n},Input_pattern1,Output_pattern,W_in{n},W{n},W_Feedb{n});  
            State1_n_1{n}=(1-Leaky_rate).*State1_n_1{n}+Leaky_rate.*State1_n;
            Temp(1:resSize(n),1)=State1_n_1{n};
            State2_next=Input_pattern_Generator(n,State1_n_1{n},Input_pattern1);
        else
            Input_pattern2=State2_next;
            [State2_n]= Deep_Update(State1_n_1{n},Input_pattern2,Output_pattern,W_in{n},W{n},W_Feedb{n});
            State1_n_1{n}=(1-Leaky_rate).*State1_n_1{n}+Leaky_rate.*State2_n;
            State2_next=Input_pattern_Generator(n,State1_n_1{n},Input_pattern1);
            Temp(sum(resSize(1:n-1))+1:sum(resSize(1:n)),1)=State1_n_1{n};
        end
    end
    Output_pattern=Training_data(i);
    State(:,i)=[Temp;0];
end


end

