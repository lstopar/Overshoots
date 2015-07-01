    Q = 600000; %gearbox
    L = +6.5e-08;
    a = -1.3;
    
    j = 0;
    start = 5808082;
    temperatures = zeros(length(M)-start,1);
    sum_dT = 0;
    sum_E_l = 0;
    sum_E_in = 0;
    T = M(start,4);

for i = start:length(M) - 1
    j = j + 1;

    dt = M(i+1,1) - M(i,1);
    rpm = (M(i,6) + M(i+1,6)) / (2 * 60000);
    torque = (M(i,8) + M(i+1,8)) * 1000 / 2;
    T_a = (M(i,7) + M(i+1,7)) / 2;

    P_in = 2 * pi * torque * rpm;
    E_l = (T - T_a - a) * (1 - exp(-L*dt));
    
    c = -4.884e-10 * T + 3.445e-08;

    T = T + (c * dt * P_in - E_l);

    temperatures(j,1) = T;
end

figure
plot((u2mTime(M(start:length(M)-1,1))),M(start:length(M)-1,4),(u2mTime(M(start:length(M)-1,1))),temperatures(:,1));
grid on