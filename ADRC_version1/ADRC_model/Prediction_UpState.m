function [ y] = Prediction_UpState(Input_streaming,Training_data,TPW,FB,State_end,W_in,W,W_Feedb,resSize,W_out)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
%% this is the prediction stage function.
%% This prediction phase has the expectation value to correct the model's, so the error of the model will not be accumulated.
global Leaky_rate;
trainLen=TPW(1);
predictLen=TPW(2);
n_layers=length(resSize);

y=zeros(predictLen,1);
Int_State=cell(1,n_layers);
for j=1:n_layers
    if j==1
        Int_State{j}=State_end(1:resSize(j));
    else
        Int_State{j}=State_end(sum(resSize(1:j-1))+1:sum(resSize(1:j)));
    end
end

P_Output_pattern=Training_data(trainLen);
P1_Input_pattern=Input_streaming(trainLen+1);

for i=1:predictLen
    for n=1:n_layers
        if n==1
           [State1_n] = Update(Int_State{n},P1_Input_pattern,P_Output_pattern,W_in{n},W{n},W_Feedb{n});
           Int_State{n}=(1-Leaky_rate)*Int_State{n}+Leaky_rate*State1_n;
           State1_next=Input_pattern_Generator(n,Int_State{n},P1_Input_pattern);
           P2_Input_pattern=State1_next;
        else
           [State2_n] = Deep_Update(Int_State{n},P2_Input_pattern,P_Output_pattern,W_in{n},W{n},W_Feedb{n});  
           Int_State{n}=(1-Leaky_rate)*Int_State{n}+Leaky_rate*State2_n;
           State2_next=Input_pattern_Generator(n,Int_State{n},P1_Input_pattern);
           P2_Input_pattern=State2_next;
        end
    end
    y(i)=[cell2mat(Int_State');0]'*W_out;
    P_Output_pattern=Training_data(trainLen+i);
    P1_Input_pattern=Input_streaming(trainLen+1+i);
end     

end

