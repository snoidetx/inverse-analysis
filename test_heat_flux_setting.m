function heat_flux_val = test_heat_flux_setting(dummy, state, h)

dummy;
days = 30;
final_time = days * 24 * 60 * 60;
dt=3 * 60 * 60;
tlist = 0:dt:final_time;

norm_time = state.time; %normalized time
if isnan(norm_time)
    heat_flux_val = NaN
%fprintf("%s %s\n", norm_time, num2str(int32(floor(norm_time / dt) + 1)))
else
    heat_flux_val = h(min([int32(floor(norm_time / dt) + 1) 240]));
end
end
