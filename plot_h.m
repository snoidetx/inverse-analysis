function plot_h(tlist, h, title_name, subtitle_name)

close();

figure;
dlist = tlist / (24 * 60 * 60);
plot(dlist(1:end - 1), h, 'LineWidth', 2);

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

% Save the figure using exportgraphics
if nargin == 4
    filename = sprintf('type_1_solution_%s_%s', title_name, subtitle_name);
else
    filename = sprintf('type_1_solution_%s', title_name);
end
save("approximated_h.mat", "h");
%exportgraphics(gcf, [filename '.png'], 'Resolution', 300, 'BackgroundColor', 'none');

end
