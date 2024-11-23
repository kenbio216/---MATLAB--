clc;
clear;

% 数据初始化
years = 2019:2023; % 时间
future_years = 2024:2026; % 预测时间
data_cats = [4412, 4862, 5806, 6536, 6980]; % 猫数量(万)

% 二次指数平滑
a = 0.5; % 平滑系数
lenD = length(data_cats);

% 初始化
S1 = zeros(1, lenD); % 一次平滑
S2 = zeros(1, lenD); % 二次平滑
F = zeros(1, lenD + 3); % 二次指数平滑预测

% 一次平滑和二次平滑
S1(1) = data_cats(1);
S2(1) = data_cats(1);
for t = 2:lenD
    S1(t) = a * data_cats(t) + (1 - a) * S1(t - 1);
    S2(t) = a * S1(t) + (1 - a) * S2(t - 1);
end

% 水平值和趋势值
At = 2 * S1 - S2; % 水平值
Bt = (a / (1 - a)) * (S1 - S2); % 趋势值

% 打印二次指数平滑公式
fprintf('Double Exponential Smoothing Formula for Cats:\n');
fprintf('F(t + k) = A(t) + B(t) * k\n');
fprintf('A(t) = %.2f\n', At(end));
fprintf('B(t) = %.2f\n', Bt(end));

% 预测未来
for t = 1:3
    F(lenD + t) = At(end) + Bt(end) * t; % 未来预测值
end
F(1:lenD) = data_cats; % 当前值+历史预测值

% 绘图
figure;
plot(years, data_cats, 'k-o', 'LineWidth', 1.5, 'MarkerSize', 8, 'DisplayName', 'Actual Data');
hold on;
plot([years, future_years], F, 'b--x', 'LineWidth', 1.5, 'MarkerSize', 8, 'DisplayName', 'Predicted Data');
title('Cats Population with Double Exponential Smoothing');
xlabel('Year');
ylabel('Cats Population (10k)');
legend show;
grid on;

% 输出预测值
disp('Future Cats Population (10k):');
disp(F(lenD + 1:end));
