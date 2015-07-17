clear
A = [];
for i = [0:10 14:20 26 33:39 45:47 53]
    i
    if i < 10
        load(['C:\Users\Miha\Documents\ProaSense\drilling-2015-00',num2str(i),'.mat'], 'M')
    else
        load(['C:\Users\Miha\Documents\ProaSense\drilling-2015-0',num2str(i),'.mat'], 'M')
    end
    [g_coefficients] = calcGCoeff(M);
    A = [A; g_coefficients];
    clear M
end