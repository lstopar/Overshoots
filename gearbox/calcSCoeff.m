function [coefficients] = calcSCoeff(M)
    L = +6.5e-08;
    a = -1.3;
    
    start = 0;
    stop = 0;
    start_T = 0;
    stop_T = 0;
    isDrilling = false;
    j = 0;
    coefficients = [];
    sum_dT = 0;
    sum_E_l = 0;
    sum_E_in = 0;

    for i = 1:length(M) - 1
        t = (M(i,1) + M(i+1,1)) / 2;
        dt = M(i+1,1) - M(i,1);
        T = (M(i+1,7) + M(i,7)) / 2;
        dT = M(i+1,7) - M(i,7);
        rpm = (M(i,9) + M(i+1,9)) / (2 * 60000);
        torque = (M(i,11) + M(i+1,11)) * 1000 / 2;
        T_a = (M(i,10) + M(i+1,10)) / 2;

            if rpm*torque > 7 %RPM*torque>1000 (units from measurments)
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
                if ((stop - start) > 2000000) && (start > 0)
                    j = j + 1;
                    c = (sum_dT + sum_E_l) / sum_E_in;
                    avg_T = (start_T + stop_T)/2; 
                    coefficients(j,1) = c;
                    coefficients(j,2) = avg_T;
                    coefficients(j,3) = stop-start;
                    coefficients(j,4) = start;
                    coefficients(j,5) = i;
                    
                    check_c(c,avg_T,start,stop)

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