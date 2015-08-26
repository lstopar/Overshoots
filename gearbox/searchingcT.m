clear
A = [];
for i = [3:13]
    i
    if i < 10
        load(['C:\Users\Miha\Documents\ProaSense\drilling-high-coeff-00',num2str(i),'.mat'], 'M')
    else
        load(['C:\Users\Miha\Documents\ProaSense\drilling-high-coeff-0',num2str(i),'.mat'], 'M')
    end
    [G_coefficients] = calcGCoeff(M);
    A = [A; G_coefficients];
    clear M
end