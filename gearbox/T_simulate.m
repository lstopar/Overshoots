%     L = +6.5e-08;
%     a = -1.3;
    L = 1.5e-07;
    a = -2.1;
    
    j = 0;
    start = 2372211;
    stop = length(M);
    temperatures = zeros(stop-start,1);
    sum_dT = 0;
    sum_E_l = 0;
    sum_E_in = 0;
    T = M(start,6);

for i = start:(stop - 1)
    j = j + 1;

    dt = M(i+1,1) - M(i,1);
    rpm = (M(i,9) + M(i+1,9)) / (2 * 60000);
    torque = (M(i,11) + M(i+1,11)) * 1000 / 2;
    T_a = (M(i,10) + M(i+1,10)) / 2;

    P_in = 2 * pi * torque * rpm;
    E_l = (T - T_a - a) * (1 - exp(-L*dt));
    
%     c = -4.884e-10 * T + 3.445e-08;
    c = 2.0528e-13 * T + 2.1243e-08;

    T = T + (c * dt * P_in - E_l);

    temperatures(j,1) = T;
end

figure
plot(u2mTime(M(start:(stop-1),1)),M(start:(stop-1),6));
hold on
plot(u2mTime(M(start:(stop-1),1)),temperatures(:,1),'r');
grid on