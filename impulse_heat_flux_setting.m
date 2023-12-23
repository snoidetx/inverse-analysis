function heat_flux_val = impulse_heat_flux_setting(dummy, state, itime)

dummy;
days = 30;
final_time = days * 24 * 60 * 60;
dt=3 * 60 * 60;
tlist = 0:dt:final_time;

norm_time = (state.time) / final_time; %normalized time
impulse_time = tlist(itime) / final_time;
heat_flux_val = normpdf(norm_time, impulse_time, dt/final_time);

end
