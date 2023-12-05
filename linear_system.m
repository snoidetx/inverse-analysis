function [tlist, TC, G] = linear_system()

[G1 G2] = green_matrix();
[tlist, TC1, TC2] = load_measurement(); 

TC = vertcat(TC1(2:end)', TC2(2:end)');
G = vertcat(G1, G2);
end

function [tlist, TC1, TC2] = load_measurement()

load("measurement_data.mat");
tlist = tlist;
TC1 = Tsensor1;
TC2 = Tsensor2;

end

