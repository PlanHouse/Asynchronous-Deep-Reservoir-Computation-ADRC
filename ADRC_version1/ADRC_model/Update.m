function [States_n] = Update(States_n_1,Input_pattern,Output_pattern,W_in,W, W_Feedb)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
%% The state update function of the data at the first layer.
preactivation=Input_pattern.* W_in+W*States_n_1+Output_pattern*W_Feedb;
States_n=tanh(preactivation);
end

