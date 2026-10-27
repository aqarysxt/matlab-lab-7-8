% Зертханалық жұмыс 7-8 | 1-тапсырма
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

%% 1-тапсырма — y = sin(x) + cos(x^2) + sqrt(x)
N1 = 2000000;
Y1 = zeros(1, N1);
Y2 = zeros(1, N1);

timer = tic;
for i = 1:N1
    Y1(i) = sin(i) + cos(i^2) + sqrt(i);
end
T1for = toc(timer);

timer = tic;
parfor i = 1:N1
    Y2(i) = sin(i) + cos(i^2) + sqrt(i);
end
T1par = toc(timer);

diff1 = max(abs(Y1 - Y2));
fprintf('\nTASK 1: function values\n');
fprintf('for = %.6f s; parfor = %.6f s; speedup = %.4f\n', ...
    T1for, T1par, T1for / T1par);
fprintf('Maximum result difference = %.3e\n', diff1);

% Нәтижені тексеру
assert(diff1 <= 1e-10 * max(1, max(abs(Y1))), 'Task 1 mismatch.');

% Worker санына қатысты тиімділік
speedup = T1for / T1par;
efficiencyPercent = 100 * speedup / workerCount;
fprintf('Efficiency = %.2f %%\n', efficiencyPercent);

figure('Name', 'Task 1: execution times', 'Color', 'w');
bar([T1for T1par]);
set(gca, 'XTick', [1 2], 'XTickLabel', {'for', 'parfor'});
ylabel('Time (seconds)');
grid on;

% Жұмыстан кейін қажет болса pool-ды жабу командасы:
% delete(gcp('nocreate'))
