function h = lsm()

[tlist, TC, G] = linear_system();

disp(['Condition Number of matrix: ' num2str(cond(G' * G))]);

h = inv(G' * G) * G' * TC;

plot_h(tlist, h, "LSM");


end

