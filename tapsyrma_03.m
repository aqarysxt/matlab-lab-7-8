% Зертханалық жұмыс 7-8 | 3-тапсырма
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

%% 3-тапсырма — сол интегралды parfor арқылы есептеу
Nint = 1000000;
a = 0;
b = 1;
h = (b - a) / Nint;
sumParallel = 0;

timer = tic;
parfor i = 1:Nint
    x = a + (i - 0.5) * h;
    % sumParallel — reduction variable, аралық қосындылар біріктіріледі.
    sumParallel = sumParallel + 4 / (1 + x^2);
end
Ipar = h * sumParallel;
T3par = toc(timer);

fprintf('\nTASK 3: midpoint integration, parfor\n');
fprintf('Integral = %.15f; absolute error = %.3e\n', Ipar, abs(Ipar - pi));
fprintf('Time = %.6f s\n', T3par);

% Нәтижені тексеру
assert(abs(Ipar - pi) < 1e-8, 'Task 3 integral check failed.');

% Жұмыстан кейін қажет болса pool-ды жабу командасы:
% delete(gcp('nocreate'))
