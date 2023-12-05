function h = tr(reg)

[tlist, TC, G] = linear_system();

s = size(tlist);
s = s(2) - 1;

h = inv(G' * G + reg^2 * eye(s)) * G' * TC;

plot_h(tlist, h, "TR", sprintf('%c = %s', char(961), num2str(reg)));


end