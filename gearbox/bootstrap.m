N = zeros(5000,2);

for i = 1:10000
    M = zeros(16,2);
    
    for j = 1:16
        a = randi(117);
        M(j,1) = c1(a,1);
        M(j,2) = T1(a,1);
    end
    
    p = polyfit(M(:,2),M(:,1),1);
    N(i,1) = p(1);
    N(i,2) = p(2);
end