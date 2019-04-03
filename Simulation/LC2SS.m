%===============================================================================
% Calculate State Space matices from Lc element values
%
function [A,B,C,D] = lc2ss(lc_values);

order = length(lc_values);

A = zeros(order);

A(1,1) = -1/lc_values(1);

for i = 1:order-1
    A(i,i+1) = -1/lc_values(i);
end

for i = 2:order
    A(i,i-1) = 1/lc_values(i);
end

A(order,order) = -1/lc_values(order);

B = zeros(order,1);

B(1) = 1/lc_values(1);

C = zeros(1,order);

C(order) = 1;

D = 0;