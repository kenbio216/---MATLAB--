% 自变量和应变量数据
F1 = [7157.60134; 7590.97337; 8486.58239; 9011.917775; 9792.36871];
F2 = [9946.691286; 10402.41392; 11313.21852; 11853.15074; 13050.0634];
pet_quantity = [9915; 10084; 11235; 11655; 12155]; % 宠物数量 (万)

% 构造自变量矩阵 (加上偏置项)
X = [ones(size(F1)), F1, F2];

% 回归计算
b = regress(pet_quantity, X);

% 预测值
predicted_quantity = X * b;

% 绘制三维散点图
figure;
scatter3(F1, F2, pet_quantity, 50, 'r', 'filled'); % 真实数据点
hold on;

% 绘制拟合平面
[F1_grid, F2_grid] = meshgrid(linspace(min(F1), max(F1), 20), linspace(min(F2), max(F2), 20));
z_fit = b(1) + b(2)*F1_grid + b(3)*F2_grid;
surf(F1_grid, F2_grid, z_fit, 'EdgeColor', 'none', 'FaceAlpha', 0.5); % 拟合平面

% 图形设置
xlabel('F1');
ylabel('F2');
zlabel('Pet Quantity (ten thousand)');
title('Three-dimensional fitting results of multiple linear regression');
grid on;
view(45, 30); % 设置视角
legend('Real data points', 'Fit the plane');
hold off;
