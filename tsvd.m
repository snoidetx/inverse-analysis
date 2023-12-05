function h = tsvd(rank)

[tlist, TC, G] = linear_system();

fprintf('The last element of the column vector is: %d\n', TC(end));

[u, s, v] = svd(G);

s(rank + 1:end, rank + 1: end) = 0;

h = v * pinv(s) * u' * TC;
plot_h(tlist, h, "TSVD", sprintf('r = %s', num2str(rank)));

TCr = G * h;
fprintf('TC1 is: %d', TCr(230:240));


end