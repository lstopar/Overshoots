%%
fname = '/media/lstopar/hdd/data/Aker/drilling-joined/blocks/drilling-24.csv';
X = csvread(fname, 1, 0);
X1 = csvread('/media/lstopar/hdd/data/Aker/drilling-joined/blocks/drilling-25.csv', 1, 0);
%%
I2 = 5800000:5887200;

plot(u2mTime(X(:,1)), X(:,4), 'r', u2mTime(X(:,1)), X(:,6), 'b');
hold on;
plot(u2mTime(X(I2,1)), X(I2,4), 'rx', u2mTime(X(I2,1)), X(I2,6), 'bx');
datetick('x', 'yyyy-mm-dd');
hold off;

%%
% I2 = 5800000:5887200;
% I3 = I2(1):7000000;

I11 = 5800000:5887200;
I2 = 5909000:6048000;
I3 = 6048000:6148000;
I4 = 5800000:11200000;
% I4 = 5800000:10200000;


alpha = calc_cooling(T(:,2), T(:,1), temp(I1,2));
calc_friction([X; X1], alpha, [I11, I2], I4, length(I11));
% calc_friction(X, alpha, [I2, I3], I4, I2(end) - I3(1) + 1);