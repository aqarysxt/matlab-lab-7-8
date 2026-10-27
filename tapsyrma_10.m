% Зертханалық жұмыс 7-8 | 10-тапсырма
% Жеке орындалатын файл: MATLAB-та ашып, Run басыңыз.
% Басқа тапсырмалардың файлдары қажет емес.
% Бұл тапсырмаға Parallel Computing Toolbox қажет емес.

clearvars;
clc;
format long g;
rng(42, 'twister');

%% 10-тапсырма — 2000 x 2000 матрицаларын көбейту
A = rand(2000);
B = rand(2000);

timer = tic;
C = A * B;
T10 = toc(timer);

fprintf('\nTASK 10: matrix multiplication\n');
fprintf('C size = %d x %d; A*B time = %.6f s\n', ...
    size(C, 1), size(C, 2), T10);
% Матрицаларды құру уақыты T10 ішіне кірмейді.

% Нәтижені тексеру
assert(isequal(size(C), [2000 2000]), 'Task 10 matrix size check failed.');
