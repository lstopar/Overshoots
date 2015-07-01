clear
A = [];
for i = [0:13]
    i
    if i < 10
        load(['drilling-high-coeff-00',num2str(i),'.mat'], 'M')
    else
        load(['drilling-high-coeff-0',num2str(i),'.mat'], 'M')
    end
    [coefficients] = calcSCoeff(M);
    A = [A; coefficients];
    clear M
end