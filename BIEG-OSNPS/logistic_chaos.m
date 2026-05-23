function[chaos_seq] = logistic_chaos(length, CHAOS_PARAM)
x = zeros(1,length+1);
x(1) = rand();
for j =2: length+1
    x(1,j)= CHAOS_PARAM * x(1,j-1) * (1 - x(1,j-1));
    if x(1,j) <= 0 || x(1,j) >= 1
       x(1,j) = min(max(x(1,j), 1e-10), 0.99); % 强制限制在(0,1)区间内
    end
end
x = x(2:end);
chaos_seq = x;