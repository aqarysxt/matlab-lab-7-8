% Зертханалық жұмыс 7-8 | 9-тапсырма
% Жеке орындалатын файл: MATLAB-та ашып, Run басыңыз.
% Басқа тапсырмалардың файлдары қажет емес.
% Бұл тапсырмаға Parallel Computing Toolbox қажет емес.

clearvars;
clc;
format long g;
rng(42, 'twister');

%% 9-тапсырма — Монте-Карло әдісіндегі N көлемінің әсері
Ns = [1000; 10000; 100000; 1000000; 10000000];
piEstimates = zeros(size(Ns));
absoluteErrors = zeros(size(Ns));
mcSeconds = zeros(size(Ns));
rng(42, 'twister');

for k = 1:numel(Ns)
    N = Ns(k);
    inside = 0;
    timer = tic;
    for i = 1:N
        x = rand;
        y = rand;
        if x^2 + y^2 <= 1
            inside = inside + 1;
        end
    end
    piEstimates(k) = 4 * inside / N;
    mcSeconds(k) = toc(timer);
    absoluteErrors(k) = abs(pi - piEstimates(k));
end

mcTable = table(Ns, piEstimates, absoluteErrors, mcSeconds, ...
    'VariableNames', {'N', 'PiEstimate', 'AbsoluteError', 'Seconds'});
fprintf('\nTASK 9: Monte Carlo sample sizes\n');
disp(mcTable);

%% Қатенің N көлеміне тәуелділік графигі
% Бұл сызық нақты бір тәжірибе қатесінің шегі емес, стандарттық ауытқу.
theoreticalStd = sqrt(4 * pi - pi^2) ./ sqrt(Ns);
figure('Name', 'Monte Carlo error', 'Color', 'w');
loglog(Ns, absoluteErrors, 'o-', Ns, theoreticalStd, '--', 'LineWidth', 1.4);
xlabel('Number of points N');
ylabel('Absolute error / standard deviation');
legend('Observed absolute error', 'Theoretical standard deviation', ...
    'Location', 'best');
title('Monte Carlo accuracy');
grid on;
