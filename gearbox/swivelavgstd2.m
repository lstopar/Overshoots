%%
sum = 0;
j = 0;
k = 0;
% coeffs = zeros(1,3);
intervals = zeros(27,2);
% intervalTime = zeros(27,2);

Q = 600000; %gearbox
L = 6.2605e-08; %old 8.634e-08
a = 2.1886; %old 0.418 

start = 0;
stop = 0;
isDrilling = false;

% for g = 24
%     disp(['Reading file: ',num2str(g)]);
%     M = csvread(['drilling-',num2str(g),'new.csv'], 1, 0);
    
    [p, q] = size(M);
       
    for i = 1:(p-1)
        if mod(i, 10000) == 0
            disp(num2str(i));
        end
        
        t = M(i,1);
        hook_load = M(i,2);
        swivel_oil_T = M(i,4);
        rpm = M(i,6);
        ambient_T = M(i,7);
        torque = M(i,8);
        
        diff_t = M(i+1,1) - M(i,1);
        diff_swivel_oil_T = M(i+1,4) - M(i,4);
        avg_swivel_oil_T = (M(i+1,4) + M(i,4)) / 2; 
        avg_rpm = (M(i,6) + M(i+1,6)) / (2 * 60000);
        avg_torque = (M(i,8) + M(i+1,8)) * 1000 / 2;
        avg_T_a = (M(i,7) + M(i+1,7)) / 2;
        P = 2 * pi * avg_torque * avg_rpm;

        friction_coeff = ((diff_swivel_oil_T/diff_t + (avg_swivel_oil_T - avg_T_a - a)*L)*Q) / P;

        if rpm*torque > 1000 
            
            if friction_coeff > 1 
                friction_coeff = 1;  
            elseif friction_coeff < 0
                friction_coeff = 0;
            end
            
            k = k + 1;
            sum = sum + friction_coeff;
            
            if isDrilling == false 
                start = t;
                start1 = i;
				isDrilling = true;
            end
                    
        else 
			stop = t;
            stop1 = i;
				
            if ((stop - start) > 2000000) && (start > 0)        
                j = j + 1;
%                 coeffs(j,1) = sum / k;
%                 coeffs(j,2) = stop - start;
%                 coeffs(j,3) = k;
                intervals(j,1) = start1;
                intervals(j,2) = stop1;
%                 intervalTime(j,1) = start;
%                 intervalTime(j,2) = stop;
            end
            
            start = 0;
 		    stop = 0;
            start1 = 0;
            stop1 = 0;
            isDrilling = false;
            sum = 0;
            k = 0;
        end
    end
% end
