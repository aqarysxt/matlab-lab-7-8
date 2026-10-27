% Зертханалық жұмыс 7-8 | 4-тапсырма
% Жеке орындалатын файл: MATLAB-та ашып, Run басыңыз.
% Басқа тапсырмалардың файлдары қажет емес.
% Бұл тапсырмаға Parallel Computing Toolbox қажет емес.

clearvars;
clc;
format long g;
rng(42, 'twister');

%% 4-тапсырма — Монте-Карло әдісімен pi, for
Nmc = 1000000;
insideSerial = 0;

timer = tic;
for i = 1:Nmc
    x = rand;
    y = rand;
    if x^2 + y^2 <= 1
        insideSerial = insideSerial + 1;
    end
end
piSerial = 4 * insideSerial / Nmc;
T4for = toc(timer);
errMCSerial = abs(pi - piSerial);

fprintf('\nTASK 4: Monte Carlo, for\n');
fprintf('pi estimate = %.8f; absolute error = %.8f; time = %.6f s\n', ...
    piSerial, errMCSerial, T4for);
