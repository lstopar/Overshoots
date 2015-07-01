function fit()
    
%     gearbox
    
    eps = 1e-10;
    
    a = -1.1;
    
    load 'drilling-2015-037.mat' M
    
    start = 1978591;
    stop = 2299850;

    t = M(start:stop,1)/1000;
    swivel_oil_T = M(start:stop,6);
    ambient_T = M(start:stop,10);

    T_0 = M(start,6);

    diff = T_0 - ambient_T;
    
    format long
    t_0 = M(start,1)/1000;

    function val = f(t, L)
        val = ambient_T + a + (diff - a) .* exp(L*(t_0-t));
    end
    
    function val = loss(L)
        val = sum(swivel_oil_T - f(t,L)).^2;
    end

    disp('fitting ...');
    [L,fval] = fminsearch(@loss, 6.4e-05)

    
    plot(u2mTime(t), swivel_oil_T, 'g', u2mTime(t), ambient_T, 'black');
    hold on;
    grid on;
    plot(u2mTime(t), f(t,L), 'b');
    datetick()
    hold on;
    hold off;
end