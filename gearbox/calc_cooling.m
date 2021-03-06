function [alpha] = calc_cooling(T, time, temp_ambient)
    m = length(T);
    
    I = 1:m;

    to_plot_time = 1 / (60*60);
    line_width = 2;
    
    time = time/1000;
    
    T_0 = T(1);
    T_a = mean(temp_ambient);
    

    a = 2.16086;
    t_offset = T_a - a;
    
    X = [ones(length(I),1), log(T(I) - t_offset)];
    y = time(I);
    
    w = (X'*X) \ X'*y;
    
    alpha = [exp(-w(1) / w(2)), 1 / w(2)];
    
    f = @(alpha) t_offset + alpha(1)*exp(alpha(2)*time);

    subplot(1,2,1);
    plot(time(I)*to_plot_time, T(I), 'rx');
    hold on;
    plot(time*to_plot_time, f(alpha), 'b', 'LineWidth', line_width);
    xlabel('time [h]');
    ylabel('temperature [ ^{o}C]');
    grid on;
    hold off;
    
    subplot(1,2,2);
    plot(time*to_plot_time, log(T - t_offset), 'rx');
    hold on;
    plot(time*to_plot_time, log(alpha(1)*exp(alpha(2)*time)), 'b', 'LineWidth', line_width);
    xlabel('time [h]');
    ylabel('log(temperature) [ ^{o}C]');
    grid on;
    hold off;
    
    alpha(1) = alpha(1) / (T_0 - T_a);
end
