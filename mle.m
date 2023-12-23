function [h, Q] = mle(reg, tlist, TC, G)

if nargin < 2
    [tlist, TC, G] = linear_system();
end

%fprintf('The last element of the column vector is: %d\n', TC(end));
s = size(TC);
s = s(1);

sigma = zeros(s, s);
ssr = 0;
for i = 1:s
    sigma(i, i) = (0.01941 * TC(i))^2;
    ssr = ssr + (0.01941 * TC(i))^2;
end

%disp("ssr");
%disp(ssr);
A = G' * sigma * G;
b = G' * sigma * TC;
%disp(size(A));
h = inv(A' * A + reg^2 * eye(240)) * A' * b;
sm = inv(A' * A + reg^2 * eye(240)) * A' * G' * sigma;
[tlist, TC, G] = linear_system();
Q = G * sm;

%plot_h(tlist, h, "MLE");

%TCr = G * h;
%fprintf('TC1 is: %d', TCr(230:240));


end