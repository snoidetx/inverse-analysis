function plot_h(tlist, h, title_name, subtitle_name)
[dlist, fluxlist] = simulate();
close();

figure;
tlist_adj = tlist - (tlist(2) - tlist(1)) / 2;
dlist = tlist_adj / (24 * 60 * 60);
transformedFluxlist = sign(fluxlist) .* log10(abs(fluxlist) + 1);
plot(dlist, transformedFluxlist, 'LineWidth', 2);
hold on;
transformedH = sign(h) .* log10(abs(h) + 1);
plot(dlist(2:end), transformedH, 'LineWidth', 2);
hold off;

% Define original y-ticks and calculate transformed y-ticks
originalYTicks = 10 .^ [-9 -6 -3 0 3 6 9];
transformedYTicks = sign(originalYTicks) .* log10(abs(originalYTicks));

% Set y-ticks and y-tick labels
set(gca, 'YTick', transformedYTicks);
set(gca, 'YTickLabel', {'10^{-9}', '10^{-6}', '10^{-3}', '10^0', '10^{3}', '10^{6}', '10^{9}'});


legend('Actual input heat flux', 'Recovered input heat flux', 'Location', 'southwest');


% Set axis label and tick font size
set(gca, 'FontSize', 24);

% Set title properties
if nargin == 4
    title(sprintf('%s (%s)', title_name, subtitle_name), 'FontSize', 26);
else
    title(title_name, 'FontSize', 26);
end

% Set x and y axis labels
xlabel('Time (d)', 'FontSize', 24);
ylabel('Heat flux (W/m^2)', 'FontSize', 24);
%ylim([24000 32000]);

% Save the figure using exportgraphics
if nargin == 4
    filename = sprintf('type_1_solution_%s_%s', title_name, subtitle_name);
else
    filename = sprintf('type_1_solution_%s', title_name);
end
% save("approximated_h.mat", "h");
exportgraphics(gcf, [filename '.png'], 'Resolution', 300, 'BackgroundColor', 'none');

end
