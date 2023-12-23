function [h, Q] = tsvd(rank, tlist, TC, G)

if nargin < 2
    [tlist, TC, G] = linear_system();
end

%fprintf('The last element of the column vector is: %d\n', TC(end));

[u, s, v] = svd(G);

s(rank + 1:end, rank + 1: end) = 0;

Q = v * pinv(s) * u'; 
h = Q * TC;
plot_h(tlist, h, "TSVD", sprintf('r = %s', num2str(rank)));

[tlist, TC, G] = linear_system();
Q = G * Q;
%sse = norm(TCr - TC)^2;
%fprintf('TC1 is: %d', TCr(230:240));
%disp("sse");
%disp(sse);


end