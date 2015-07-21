load X
load y

y = y(:,1);

idxs = y > 0;

X = X(idxs,:);
X = [ones(size(X,1),1), X];
y = y(y > 0);

%%
n_bins = 20;

w = (X'*X)\(X'*y);
y_hat = X*w;
% u = y(:,1)>=0;
% Y = y(u)-y_hat(u);
% v = y(:,1)<0;
subplot(2,1,1)
hist(y - mean(y), n_bins)
subplot(2,1,2)
% hist(y(u), n_bins)

hist(y - y_hat, n_bins);

std(y - mean(y))^2
std(y - y_hat)^2



% subplot(3,1,2)
% hist(y(v))

%%
average_1 = sum(Y(:,1))/length(Y(:,1));
x=0;
for i=1:length(Y(:,1))
    x = x + ((Y(i,1)-average_1))^2;
end
var_1 = x/length(Y(:,1))

average_2 = sum(y(:,1))/length(y(:,1));
z=0;
for j=1:length(y(:,1))
    z = z + ((y(j,1)-average_2))^2;
end
var_2 = z/length(y(:,1))

