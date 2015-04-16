function [coeffs] = calc_friction(data, alpha, intervals, I2)
%      alpha(2) = alpha(2);
%     alpha(2) = alpha(2)*2;   % TODO hack, this one was best

     Q = 600000;
%     Q = 600000*100;


     temp_drop = @(T_i, delta_T, dt) (delta_T + alpha(1))*(1 - exp(alpha(2)*dt));%*alpha(2)*dt*(-1);

     function val = get_El(T_i, dT, dt)
         deriv = temp_drop(T_i, dT, dt);
         val = deriv*Q;
     end

     function [c] = calc_fric(interval)
         X = data(interval,:);

         t = X(:,1)/1000;
         rpm = X(:,6) / (60);
         torque = X(:,8) * 1000;
         T = X(:,4);
         T_a = X(:,7);
         
         E_l = 0;
         E_in = 0;
         T_gain = 0;
         for k = 1:length(interval)-1
             dt = t(k+1) - t(k);

             delta_T = T(k) - T_a(k);

             P_in = 2*pi*torque(k)*rpm(k);

             E_l = E_l + get_El(T(k), delta_T, dt);
             E_in = E_in + P_in*dt;
             T_gain = T_gain + (T(k+1) - T(k));
         end

         c = (T_gain*Q + E_l) / E_in;    
     end
 
    n_intervals = size(intervals, 1);
    coeffs = zeros(n_intervals,1);
 
    for i = 1:n_intervals
        s = intervals(i,1);
        e = intervals(i,2);
        
        coeffs(i) = calc_fric(s:e);
    end
 

%     % compute c
    

     disp('Got the coefficient, evaluate ...');

     % simulate the temperature
     % start with the starting temperature
%      X = data(I2,:);
% 
%      t_old = t;
%      T_old = T;
% 
%      t = X(:,1)/1000;
%      rpm = X(:,6) / (60);
%      torque = X(:,8) * 1000;
%      T = X(:,4);
%      T_a = X(:,7);
% 
%      m = length(t);
% 
%      T_sim = zeros(m,1);
% 
%      T_curr = T(1);
%      T_sim(1) = T_curr;
% 
%      for i = 1:m-1
%          delta_T = T_curr - T_a(i);
% 
%          dt = t(i+1) - t(i);
% 
%          E_l = get_El(T(i), delta_T, dt);
%          P_l = E_l / dt;
% 
%          P_in = 2*pi*torque(i)*rpm(i);
% %         deriv = P*c / Q + loss_cooling;
% 
%          if mod(i, 20000) == 0
%              disp('========================================');
%              disp(['delta_T: ',num2str(delta_T)]);
%              disp(['E_l: ',num2str(E_l)]);
%              disp(['P_l: ',num2str(P_l)]);
%              disp(['P_f: ',num2str(c*P_in)]);
%              disp('========================================');
%          end
% 
%          T_curr = T_curr + (c*dt*P_in - E_l) / Q;
%          T_sim(i+1) = T_curr;
%      end
% 
%      figure;
%      plot(u2mTime(t*1000), rpm*60, 'g', u2mTime(t*1000), T, 'r');
%      hold on;
% %     plot(u2mTime(t_old*1000), T_old, 'rx');
%      plot(u2mTime(t*1000), T_sim, 'b');
%      datetick('x');
%      grid on;
%      hold off;
% 
%      disp('Done!')
end