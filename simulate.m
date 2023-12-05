function simulate()

% Transient solution
% Reference: https://jp.mathworks.com/help/pde/ug/heat-distribution-in-a-circular-cylindrical-rod.html

% Create a transient thermal model for solving a rectangle domain problem.
% Geometory setting
clear;
thermalModelT = createpde('thermal', 'transient');
recty=[0.0 1.0 1.0 0.0]; % x coordinates of 4 corners of rect
rectx=[0.0 0.0 4.0 4.0]; % y coordinates of 4 corners of rect
rect=[3, 4, rectx, recty]';
circle=[1, 2.5, 0.5, 0.1, 0 0 0 0 0 0]';

g = decsg([rect,circle], 'R-C',['R','C']); 
geometryFromEdges(thermalModelT, g);
msh = generateMesh(thermalModelT, "Hmax", 0.1);

f1 = figure(1)
subplot(2,2,1);
pdeplot(thermalModelT)
%axis equal
[t, s] = title('Geometry of Refractory and TC1', newline, 'FontSize', 13)
set(s, 'FontSize', 1);
ylabel("Vertical (m)")
xlabel("Horizontal (m)")
ax = gca;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;

thermalModelT.Mesh = msh;

% Specify the thermal conductivity, mass density, and specific heat of the material.
% The rod is composed of a material with these thermal properties.
k = 21.2; % thermal conductivity, W/(m*K)
rho = 2300; % density, kg/m^3
cp = 712; % specific heat, W*s/(kg*K)
% q = 0; % heat source, W/m^3

thermalProperties(thermalModelT, 'ThermalConductivity', k, ...
                                 'MassDensity', rho,...
                                 'SpecificHeat', cp);



% Specify that the initial temperature in the rectangular is 0.
thermalIC(thermalModelT,0);

% Specify the internal heat source and boundary conditions.
figure(2)
pdegplot(thermalModelT, "EdgeLabel", "on", "VertexLabel", "on");
thermalBC(thermalModelT, 'Edge', 2, 'Temperature', 0);
close;

% Compute the transient solution for solution times from t = 0 to t = 30 * 24 * 60 * 60 seconds.
num_of_days = 30;
final_time = num_of_days * 24 * 60 * 60;
dt = 3 * 60 * 60;
tlist = 0:dt:final_time;
dlist = tlist / (24 * 60 * 60);

% Calculate temperature at TC1 and TC2.
i_time = 80;
noise_level = 0.0;

% The_impulse_heatflux_setting = @(dummy, state)impulse_heat_flux_setting(dummy, state, i_time);
The_impulse_heatflux_setting = @(dummy, state)heat_source_setting(dummy, state);
[Tsensor1, Tsensor2, T] = heat_simulation(thermalModelT, The_impulse_heatflux_setting, tlist);
state.time = tlist;
fluxlist = The_impulse_heatflux_setting([], state);
 
% Plot the temperature distribution at t = t_end seconds.
subplot(2,2,3)
pdeplot(thermalModelT, 'XYData', T(:,end), 'Contour', 'on', 'ColorMap', 'hot')
ylim([-1 2]);
% axis equal
[t, s] = title('Final Transient Temperature', newline, 'FontSize', 13);
set(s, 'FontSize', 1);
ylabel("Vertical (m)")
xlabel("Horizontal (m)")
ax = gca;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;
set(gca, 'Layer', 'top')

% Plot the temperature at the left end of the rod as a function of time. The outer surface of the rod is exposed to the environment with a constant temperature of 100 °C. When the surface temperature of the rod is less than 100 °C, the environment heats the rod. The outer surface is slightly warmer than the inner axis. When the surface temperature is greater than 100 °C, the environment cools the rod. The outer surface becomes cooler than the interior of the rod.
subplot(2,2,2)

plot(dlist, fluxlist / 100000);
[t, s] = title('Input Heat Flux', newline, 'FontSize', 13)
set(s, 'FontSize', 1);
ylabel("Heat flux (W/m^2)")
xlabel("Time (d)")
ax = gca;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;
annotation('textbox', [0.58, 0.72, 0.2, 0.2], 'String', '\times10^5', 'FitBoxToText', 'on', 'FontSize', 12, 'EdgeColor', 'none');

subplot(2,2,4)

% Add artificial noise.
%std_rate = 0.01941;
std_rate = 0;
std1 = Tsensor1 * std_rate;
std2 = Tsensor2 * std_rate;
rng(42, 'twister');
Tsensor1 = Tsensor1 + randn(size(Tsensor1)) .* std1;
Tsensor2 = Tsensor2 + randn(size(Tsensor2)) .* std2;

plot(dlist, Tsensor1, 'Color', 'blue');
hold on;
plot(dlist, Tsensor2, 'Color', 'red');
%[t, s] = title('Output Measured Temperature', newline, 'FontSize', 13)
%set(s, 'FontSize', 1);
xlabel 'Time (d)'
ylabel 'Temperature (^\circC)'
ax = gca;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;

legend('TC1', 'TC2', 'Location', 'SouthEast', 'FontSize', 12)

hold off;

save("measurement_data.mat", "tlist", "Tsensor1", "Tsensor2");


exportgraphics(f1,'type_1.png','Resolution',600)

end

function [Tsensor1, Tsensor2, T]=heat_simulation(thermalModelT, heatflux_setting_func, tlist)
thermalBC(thermalModelT, 'Edge', 3, 'HeatFlux', heatflux_setting_func);
result = solve(thermalModelT, tlist);

% Find the temperature at the bottom surface of the rod: first, at the center axis and then on the outer surface.
Tsensor1 = interpolateTemperature(result, [4-1.332;0.5], 1:numel(tlist));
Tsensor2 = interpolateTemperature(result, [4-0.676;0.5], 1:numel(tlist));
T = result.Temperature;
end
