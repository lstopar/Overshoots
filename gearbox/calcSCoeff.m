function [s_coefficients] = calcSCoeff(M)
    L = +6.5e-08;
    a = -1.3;
    
    start = 0;
    stop = 0;
    start_T = 0;
    stop_T = 0;
    isDrilling = false;
    j = 0;
    s_coefficients = [];
    sum_dT = 0;
    sum_E_l = 0;
    sum_E_in = 0;

    len = size(M,1);
    
    for i = 2:len
        t = M(i,1);
        dt = M(i, 1) - M(i-1,1);
        T = M(i,7);
        dT = M(i,7) - M(i-1,7);
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

            c = (sum_dT + sum_E_l) / sum_E_in;
            
%             if mod(i, 10000) == 0
%                 disp(['c = ',num2str(c)]);
%             end

            if ~isDrilling 
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
                s_coefficients(j,1) = c;
                s_coefficients(j,2) = avg_T;
                s_coefficients(j,3) = stop-start;
                s_coefficients(j,4) = start;
                s_coefficients(j,5) = stop;

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