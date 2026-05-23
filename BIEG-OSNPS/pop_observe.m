function [B]=pop_observe(pop)
%对种群个体进行测量    
A=pop;  
B=(rand(size(pop))<A);