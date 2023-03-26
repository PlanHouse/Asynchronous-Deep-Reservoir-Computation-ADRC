function [ State2_n ] = Input_pattern_Generator(n,State1_n,Input_pattern1)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
%% Control delay
global D_state;
global Delay;
if sum(find(Delay==0)==n)
    State2_n=[State1_n;Input_pattern1];
else
    State2_n=D_state{n}(:,end);
    D_state{n}(:,2:end)=D_state{n}(:,1:end-1);
    D_state{n}(:,1)=[State1_n;Input_pattern1];
end
end

