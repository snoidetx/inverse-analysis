function [h, Q] = tr(reg, tlist, TC, G)

if nargin < 2
    [tlist, TC, G] = linear_system();
end

s = size(tlist);
s = s(2) - 1;

h = inv(G' * G + reg^2 * eye(s)) * G' * TC;

TCr = G * h;
sse = norm(TCr - TC)^2;
[tlist, TC, G] = linear_system();
Q = G * inv(G' * G + reg^2 * eye(s)) * G';

%plot_h(tlist, h, "TR", sprintf('%c = %s', char(961), num2str(reg)));


end