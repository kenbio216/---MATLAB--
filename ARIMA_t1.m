% 定义数据
years = (2019:2023)';
households = [5989, 6369, 9168, 9800, 10565]';
pet_economy = [2212, 2953, 3942, 4936, 5928]';
penetration_rate = [0.13, 0.14, 0.18, 0.20, 0.22]';
disposable_income = [30733, 32189, 35128, 36883, 39218]';
engel_coefficient = [0.282, 0.302, 0.298, 0.305, 0.298]';
aging_population = [25570, 26402, 26736, 28004, 29697]';
marriage_registration = [927, 814, 764, 684, 768]';
pet_number = [99.8, 108.5, 115.4, 122.6, 130.2]';
pet_market = [33.2, 35.6, 38.9, 42.1, 45.5]';
medical_market = [400, 500, 600, 640, 700]';
food_output = [440.7, 727.3, 1554, 1508, 2793]';

% 创建时间序列对象
ts_data = table(years, households, pet_economy, penetration_rate, disposable_income, ...
    engel_coefficient, aging_population, marriage_registration, pet_number, ...
    pet_market, medical_market, food_output);

% 拆分训练集和测试集
trainSize = length(years);
forecastHorizon = 3; % 预测未来三年
totalSize = trainSize + forecastHorizon;

% 训练ARIMA模型并预测
model = arima('ARLags',1:2,'D',1,'MALags',1:2);

% 预测变量
variables = ts_data.Properties.VariableNames(2:end);
predicted_data = zeros(forecastHorizon, length(variables));

for i = 1:length(variables)
    trainData = ts_data{:, variables{i}};
    fit = estimate(model, trainData);
    [forecast, forecastCI] = forecast(fit, forecastHorizon, 'Y0', trainData);
    predicted_data(:, i) = forecast;
end

% 生成预测年份
predicted_years = (years(end)+1:years(end)+forecastHorizon)';

% 合并实际数据和预测数据
full_years = [years; predicted_years];
full_data = [ts_data{:, 2:end}; predicted_data];

% 可视化结果
figure;
hold on;
for i = 1:length(variables)
    plot(full_years, full_data(:, i), 'DisplayName', variables{i});
end
legend('show');
xlabel('年份');
ylabel('值');
title('全球宠物产业发展预测');
hold off;

% 显示ARIMA模型公式
disp(fit);