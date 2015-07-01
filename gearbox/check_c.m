function check_c(c, avg_T, start, stop)
     mu = -4.884e-10 * avg_T + 3.445e-08;
     sigma = 5.3808e-09;
     p = normcdf(c,mu,sigma);
                    
    if p > 0.99
        disp('coefficient is in the top 1% values!');
        start
        stop
        c
        return
    elseif p > 0.95  
        disp('coefficient is in the top 5% values!');
        start
        stop
        c
        return
    elseif p > 0.9  
        disp('coefficient is in the top 10% values!');
        start
        stop
        c
    end     

end