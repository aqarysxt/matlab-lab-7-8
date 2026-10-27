% Зертханалық жұмыс 7-8 | 2-тапсырма
% Жеке орындалатын файл: MATLAB-та ашып, Run басыңыз.
% Басқа тапсырмалардың файлдары қажет емес.
% Бұл тапсырмаға Parallel Computing Toolbox қажет емес.

clearvars;
clc;
format long g;

%% 2-тапсырма — integral_0^1 4/(1+x^2) dx, for
Nint = 1000000;
a = 0;
b = 1;
h = (b - a) / Nint;
sumSerial = 0;

timer = tic;
for i = 1:Nint
    x = a + (i - 0.5) * h;
    sumSerial = sumSerial + 4 / (1 + x^2);
end
Ifor = h * sumSerial;
T2for = toc(timer);

fprintf('\nTASK 2: midpoint integration, for\n');
fprintf('Integral = %.15f; pi = %.15f\n', Ifor, pi);
fprintf('Absolute error = %.3e; time = %.6f s\n', ...
    abs(Ifor - pi), T2for);

% Нәтижені тексеру
assert(abs(Ifor - pi) < 1e-8, 'Task 2 integral check failed.');
