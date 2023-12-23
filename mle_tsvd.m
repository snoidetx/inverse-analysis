function [h, Q] = mle_tsvd(reg, tlist, TC, G)

if nargin < 2
    [tlist, TC, G] = linear_system();
end

%fprintf('The last element of the column vector is: %d\n', TC(end));
s = size(TC);
s = s(1);

sigma = zeros(s, s);
for i = 1:s
    sigma(i, i) = (0.01941 * TC(i))^2;
end

A = G' * sigma * G;
b = G' * sigma * TC;
%disp(size(A));
h = tsvd(reg, tlist, b, A);
[u, s, v] = svd(A);
s(reg + 1:end, reg + 1: end) = 0;
sm = v * pinv(s) * u' * G' * sigma;
[tlist, TC, G] = linear_system();
Q = G * sm;



%plot_h(tlist, h, "MLE");

%TCr = G * h;
%fprintf('TC1 is: %d', TCr(230:240));


end