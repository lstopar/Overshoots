function [beta] = test_coeff(X, y, y_idx)
    y = y(:,y_idx);

    if y_idx == 1
        idxs = y < 140;
        X = X(idxs, :);
        y = y(idxs);
    elseif y_idx == 2
        idxs = 1000 < y & y < 4500;
        X = X(idxs, :);
        y = y(idxs) / 1000;
    end
     
    mean(y)
    
    n = size(X,1);
    p = size(X,2)+1;
    
    X = [ones(n,1), X];
    beta = (X'*X) \ X'*y;
    
    y_hat = X*beta;
    
    e = y - y_hat;
    
    mu = mean(e);
    var = e'*e / (n - p);
    
    sigma_sq = e'*e / (n - p);
    V_beta = sigma_sq * (X'*X)^(-1);
    
    var_beta = diag(V_beta);
    se_beta = sqrt(var_beta);
    
    t_vals = beta ./ se_beta;
    p_vals = tpdf(t_vals, p);
    
    % perform validation
    n_blocks = 10;
    block_size = ceil(n / 10);
    
    mae = 0;
    mse = 0;
    idxs = randperm(n);
    
    for block_idx = 1:n_blocks
        
        test_idxs = (block_idx-1)*block_size + 1:min(block_idx*block_size,n);
        train_idxs = [1:test_idxs(1)-1, test_idxs(end)+1:n];
                
        test_idxs = idxs(test_idxs);
        train_idxs = idxs(train_idxs);
        
        X_test = X(test_idxs, :);
        y_test = y(test_idxs);
        X_train = X(train_idxs, :);
        y_train = y(train_idxs);
        
        w = (X_train'*X_train) \ X_train'*y_train;
        
        e_test = y_test - X_test*w;
        
        se = (e_test'*e_test) / length(y_test);
        ae = sum(abs(e_test)) / length(y_test);
       
        mse = mse + se / n_blocks;
        mae = mae + ae / n_blocks;
    end
    
    disp(['mean: ',num2str(mu),', var: ',num2str(var), ', std: ',num2str(sqrt(var)),', MSE: ',num2str(mse),', MAE: ',num2str(mae)]);
    for i = 1:p
        disp(['beta_',num2str(i-1),': val = ',num2str(beta(i)),', SE = ',num2str(se_beta(i)),', t = ',num2str(t_vals(i)),', p = ',num2str(p_vals(i))]);
    end
    
    bins = 20;
    subplot(2,1,1);
    hist(y, bins);
    if y_idx == 1
        xlabel('overshoot [mm]');
    else
        xlabel('settling time [s]');
    end
    grid on;
    subplot(2,1,2);
    hist(e, bins);
    if y_idx == 1
        xlabel('residuals [mm]');
    else
        xlabel('residuals [s]');
    end
    grid on;
end