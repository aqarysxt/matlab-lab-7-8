% Зертханалық жұмыс 7-8 | 7-тапсырма
% Жеке орындалатын файл: MATLAB-та ашып, Run басыңыз.
% Басқа тапсырмалардың файлдары қажет емес.
% Parallel Computing Toolbox қажет.

clearvars;
clc;
format long g;

%% Параллель ортаны іске қосу
if isempty(ver('parallel')) || ~license('test', 'Distrib_Computing_Toolbox')
    error('This lab requires Parallel Computing Toolbox.');
end

pool = gcp('nocreate');
if isempty(pool)
    localCluster = parcluster('local');
    workerCount = min(4, localCluster.NumWorkers);
    pool = parpool(localCluster, workerCount);
end
workerCount = pool.NumWorkers;
fprintf('Workers: %d\n', workerCount);

% Алғашқы parfor шақыруын өлшенетін есептерден бұрын орындаймыз.
warmup = zeros(1, workerCount);
parfor k = 1:workerCount
    warmup(k) = sum(sqrt(1:1000));
end

%% 7-тапсырма — f(x) = sin(x)*cos(x) + sqrt(x) + ln(x+1)
% MATLAB-та табиғи логарифм: log(x), ln(x) емес.
% Құжатта аралық берілмеген: x = 1:N7 деп алынды.
N7 = 2000000;
F1 = zeros(1, N7);
F2 = zeros(1, N7);

timer = tic;
for i = 1:N7
    F1(i) = sin(i) * cos(i) + sqrt(i) + log(i + 1);
end
T7for = toc(timer);

timer = tic;
parfor i = 1:N7
    F2(i) = sin(i) * cos(i) + sqrt(i) + log(i + 1);
end
T7par = toc(timer);

diff7 = max(abs(F1 - F2));
fprintf('\nTASK 7: second function\n');
fprintf('for = %.6f s; parfor = %.6f s; speedup = %.4f\n', ...
    T7for, T7par, T7for / T7par);
fprintf('Maximum result difference = %.3e\n', diff7);

% Нәтижені тексеру
assert(diff7 <= 1e-10 * max(1, max(abs(F1))), 'Task 7 mismatch.');

% Worker санына қатысты тиімділік
speedup = T7for / T7par;
efficiencyPercent = 100 * speedup / workerCount;
fprintf('Efficiency = %.2f %%\n', efficiencyPercent);

figure('Name', 'Task 7: execution times', 'Color', 'w');
bar([T7for T7par]);
set(gca, 'XTick', [1 2], 'XTickLabel', {'for', 'parfor'});
ylabel('Time (seconds)');
grid on;

% Жұмыстан кейін қажет болса pool-ды жабу командасы:
% delete(gcp('nocreate'))
