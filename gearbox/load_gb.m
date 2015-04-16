%%
X = csvread('/media/lstopar/hdd/data/Aker/drilling-joined/blocks/drilling-24.csv', 1, 0);
X1 = csvread('/media/lstopar/hdd/data/Aker/drilling-joined/blocks/drilling-25.csv', 1, 0);

M = [X; X1];