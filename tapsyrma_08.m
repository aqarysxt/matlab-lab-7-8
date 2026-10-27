% Зертханалық жұмыс 7-8 | 8-тапсырма
% Жеке орындалатын файл: MATLAB-та ашып, Run басыңыз.
% Басқа тапсырмалардың файлдары қажет емес.
% Parallel Computing Toolbox қажет.

clearvars;
clc;
format long g;

%% Параллель ортаны іске қосу
% Toolbox папкасының атауы MATLAB нұсқасына байланысты өзгеруі мүмкін.
% Сондықтан орнатылған өнімдердің толық тізіміндегі атауын тексереміз.
installedProducts = ver;
hasParallelToolbox = any(strcmp({installedProducts.Name}, ...
    'Parallel Computing Toolbox'));
if ~hasParallelToolbox
    error('lab:ParallelToolboxNotFound', ...
        ['Parallel Computing Toolbox was not found in the installed product list. ' ...
         'Run ver to check. If it is missing, install it through Add-Ons ' ...
         'with a MATLAB license that includes this product.']);
end
if ~license('test', 'Distrib_Computing_Toolbox')
    error('lab:ParallelLicenseNotFound', ...
        ['Parallel Computing Toolbox is installed, but its license was not found. ' ...
         'Use a MATLAB license that includes this toolbox, or contact ' ...
         'your university license administrator.']);
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

%% 8-тапсырма — integral_0^5 exp(-x^2) dx
N8 = 1000000;
a8 = 0;
b8 = 5;
h8 = (b8 - a8) / N8;
sum8for = 0;

timer = tic;
for i = 1:N8
    x = a8 + (i - 0.5) * h8;
    sum8for = sum8for + exp(-x^2);
end
I8for = h8 * sum8for;
T8for = toc(timer);

sum8par = 0;
timer = tic;
parfor i = 1:N8
    x = a8 + (i - 0.5) * h8;
    sum8par = sum8par + exp(-x^2);
end
I8par = h8 * sum8par;
T8par = toc(timer);

I8reference = sqrt(pi) / 2 * erf(5);
fprintf('\nTASK 8: Gaussian integral\n');
fprintf('Reference = %.15f\n', I8reference);
fprintf('for:    I = %.15f; error = %.3e; time = %.6f s\n', ...
    I8for, abs(I8for - I8reference), T8for);
fprintf('parfor: I = %.15f; error = %.3e; time = %.6f s\n', ...
    I8par, abs(I8par - I8reference), T8par);
fprintf('Speedup = %.4f\n', T8for / T8par);

% Нәтижені тексеру
assert(abs(I8for - I8reference) < 1e-8 && abs(I8par - I8reference) < 1e-8, ...
    'Task 8 integral check failed.');

% Worker санына қатысты тиімділік
speedup = T8for / T8par;
efficiencyPercent = 100 * speedup / workerCount;
fprintf('Efficiency = %.2f %%\n', efficiencyPercent);

figure('Name', 'Task 8: execution times', 'Color', 'w');
bar([T8for T8par]);
set(gca, 'XTick', [1 2], 'XTickLabel', {'for', 'parfor'});
ylabel('Time (seconds)');
grid on;

% Жұмыстан кейін қажет болса pool-ды жабу командасы:
% delete(gcp('nocreate'))
