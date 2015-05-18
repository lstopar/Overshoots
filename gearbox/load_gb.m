%%
X = csvread('/media/lstopar/hdd/data/Aker/drilling-joined/blocks/drilling-24.csv', 1, 0);
X1 = csvread('/media/lstopar/hdd/data/Aker/drilling-joined/blocks/drilling-25.csv', 1, 0);

M = [X; X1];

%%
swivelavgstd2

%%
I11 = 5800000:5887200;
I2 = 5909000:6048000;
I3 = 6048000:6148000;
I4 = 5800000:11200000;
% I4 = 5800000:10200000;


% alpha = calc_cooling(T(:,2), T(:,1), temp(I1,2));
% calc_friction([X; X1], alpha, [I11, I2], I4, length(I11));
coeffs = calc_friction(M,[1.056312139524447, -6.300906623039639e-05],intervals,I4)