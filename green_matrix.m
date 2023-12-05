function [G1 G2] = green_matrix()

load("impulse_data.mat");

m = size(tlist);
m = m(2) - 1;
fprintf("%s", int2str(m))
G1 = zeros(m, m);
G2 = zeros(m, m);
dt = 1 / m;

for i = 1:m
    G1(m, i) = ((Tsensor1(m - i + 2) + Tsensor1(m - i + 1)) / 2) * dt; % trapezium rule
    G2(m, i) = ((Tsensor2(m - i + 2) + Tsensor2(m - i + 1)) / 2) * dt;
end

for row = m - 1:-1:1
    G1(row, m) = 0;
    G2(row, m) = 0;
    for col = 1:m - 1
        G1(row, col) = G1(row + 1, col + 1);
        G2(row, col) = G2(row + 1, col + 1);
    end
end



subplot(1, 2, 1);
customColorMap = colormap('hot'); 
customColorMap(1, :) = [0.8, 0.8, 0.8];
minVal = min(G1(:));
maxVal = max(G1(:));
clim([minVal, maxVal]);
colormap(customColorMap);
imagesc(G1)
%hColorbar = colorbar;
%hColorbar.FontSize = 10;
annotation('textbox', [0.30, 0.5, 0.1, 0.1], 'String', 'N/A region', 'EdgeColor', 'none', 'FontSize', 13);
ylabel('Response time, m-th timestamp', 'FontSize', 12);
[t, s] = title('Heatmap of G1', newline, 'FontSize', 13);
set(s, 'FontSize', 1);
ax = gca;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;
axis square

subplot(1, 2, 2);
imagesc(G2)
colormap(customColorMap);
clim([minVal, maxVal]);
hColorbar = colorbar;
hColorbar.FontSize = 10;
annotation('textbox', [0.66, 0.5, 0.1, 0.1], 'String', 'N/A region', 'EdgeColor', 'none', 'FontSize', 13);
[t, s] = title('Heatmap of G2', newline, 'FontSize', 13);
set(s, 'FontSize', 1);
yticks(subplot(1, 2, 2), []);
ax = gca;
ax.XAxis.FontSize = 12;
axis square

pos1 = get(subplot(1, 2, 1), 'Position');
pos2 = get(subplot(1, 2, 2), 'Position');
pos2(1) = pos1(1) + pos1(3) + 0.02; % Adjust the 0.02 offset as needed
set(subplot(1, 2, 2), 'Position', pos2);
annotation('textbox', [0.42, 0.15, 0.1, 0.1], 'String', 'Impulse time, i-th timestamp', 'EdgeColor', 'none', 'HorizontalAlignment', 'center', 'FontSize', 13);
%exportgraphics(gcf, 'heatmap_G1.png', 'Resolution', 300);

close;

end
