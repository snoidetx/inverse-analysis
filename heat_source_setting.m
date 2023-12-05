function heat_flux_val = heat_source_setting(~, state)
    num_of_days = 30;
    final_time = num_of_days * 24 * 60 * 60; % final time in seconds
    norm_time = (state.time) / final_time; % normalized time
    %heat_flux_val = (2 - 2 * (0.5 - norm_time).^2 + 0.2*sin(2*pi*4*norm_time)) * 1.0e4;
    heat_flux_val = 200000 + 200000 * norm_time;
end