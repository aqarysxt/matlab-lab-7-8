% Зертханалық жұмыс 7-8 | 5-тапсырма
% Жеке орындалатын файл: MATLAB-та ашып, Run басыңыз.
% Басқа тапсырмалардың файлдары қажет емес.
% Parallel Computing Toolbox қажет.

clearvars;
clc;
format long g;
rng(42, 'twister');

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

%% 5-тапсырма — Монте-Карло әдісімен pi, parfor
% Worker-лер тәуелсіз кездейсоқ ағындарды пайдаланады.
% Клиенттегі rng(42) олардың нәтижесін бекітпейді.
% 4 және 5 тапсырмалардағы нүктелер бөлек, бағалары бірдей болмауы мүмкін.
Nmc = 1000000;
insideParallel = 0;

timer = tic;
parfor i = 1:Nmc
    x = rand;
    y = rand;
    if x^2 + y^2 <= 1
        insideParallel = insideParallel + 1;
    end
end
piParallel = 4 * insideParallel / Nmc;
T5par = toc(timer);
errMCParallel = abs(pi - piParallel);

fprintf('\nTASK 5: Monte Carlo, parfor\n');
fprintf('pi estimate = %.8f; absolute error = %.8f; time = %.6f s\n', ...
    piParallel, errMCParallel, T5par);

% Жұмыстан кейін қажет болса pool-ды жабу командасы:
% delete(gcp('nocreate'))
