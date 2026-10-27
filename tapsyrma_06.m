% Зертханалық жұмыс 7-8 | 6-тапсырма
% Жеке орындалатын файл: MATLAB-та ашып, Run басыңыз.
% Басқа тапсырмалардың файлдары қажет емес.
% Parallel Computing Toolbox қажет.
% spmdIndex және spmdSize үшін MATLAB R2022b немесе жаңа нұсқа.

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

%% 6-тапсырма — SPMD арқылы 1-ден 100-ге дейін бөлу
Nspmd = 100;
spmd
    workerId = spmdIndex;
    totalWorkers = spmdSize;
    firstIndex = floor((workerId - 1) * Nspmd / totalWorkers) + 1;
    lastIndex = floor(workerId * Nspmd / totalWorkers);
    localSum = sum(firstIndex:lastIndex);
end

% spmd сыртында әр worker нәтижесі Composite ішінен {k} арқылы алынады.
ranges = zeros(workerCount, 4);
for k = 1:workerCount
    ranges(k, :) = [workerId{k}, firstIndex{k}, lastIndex{k}, localSum{k}];
end
spmdTable = array2table(ranges, 'VariableNames', ...
    {'Worker', 'FirstIndex', 'LastIndex', 'PartialSum'});
fprintf('\nTASK 6: SPMD ranges\n');
disp(spmdTable);
totalSum = sum(ranges(:, 4));
fprintf('Sum of 1:100 = %.0f; expected = 5050\n', totalSum);

% Нәтижені тексеру
assert(totalSum == 5050, 'Task 6 sum check failed.');

% Жұмыстан кейін қажет болса pool-ды жабу командасы:
% delete(gcp('nocreate'))
