function [g_coefficients] = calcGCoeff(M)
    L = 1.5e-07;
    a = -2.1;
    
    start = 0;
    stop = 0;
    start_T = 0;
    stop_T = 0;
    isDrilling = false;
    j = 0;
    g_coefficients = [];
    sum_dT = 0;
    sum_E_l = 0;
    sum_E_in = 0;

    for i = 2:length(M)
        t = M(i,1);
        dt = M(i,1) - M(i-1,1);
        T = M(i,6);
        dT = M(i,6) - M(i-1,6);
        rpm = M(i,9) / 60000;
        torque = M(i,11) * 1000;
        T_a = M(i,10);

            if rpm*torque >= 7 %RPM*torque>1000 (units from measurments)
                %avg or not?
                %vmesno racunanje?
                P_in = 2 * pi * torque * rpm;
                E_l = (T - T_a - a) * (1 - exp(-L*dt));
                
                sum_dT = sum_dT + dT;
                sum_E_l = sum_E_l + E_l;
                sum_E_in = sum_E_in + P_in * dt;
                

                if isDrilling == false 
                    start = t;
                    start_T = T;
                    isDrilling = true;
                end
                
            else
                stop = t;
                stop_T = T;
                if start > 0 && stop - start >= 2000000
                    j = j + 1;
                    c = (sum_dT + sum_E_l) / sum_E_in;
                    avg_T = (start_T + stop_T)/2; 
                    g_coefficients(j,1) = c;
                    g_coefficients(j,2) = avg_T;
                    g_coefficients(j,3) = stop-start;
                    g_coefficients(j,4) = start;
                    g_coefficients(j,5) = stop;
                    
%                     check_c(c,avg_T,start,stop)

                end
                
                start = 0;
                stop = 0;
                start_T = 0;
                stop_T = 0;
                isDrilling = false;
                sum_dT = 0;
                sum_E_l = 0;
                sum_E_in = 0;
            end
    end
end