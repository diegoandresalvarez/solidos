% Se modifica la semilla del generador de numeros aleatorios
loteria_medellin = 1234123;  % NNNNSSS donde N es el numero y S la serie
rng(loteria_medellin)

% Se listan los estudiantes y se determina su numero
estudiante = [ ...
1007227570
1007235308
1087424148
1007234325
1002800602
1002859978
1002543492
1004680056
1010107107
1115082172
1053872065
1053864743
1007584977
1116808454
1010099167
1088599397
1053864795
1002853135
1053870860 ];
num_estudiantes = length(estudiante);

% Se rifan los ejercicios
ejercicio = randperm(num_estudiantes);

% Se imprimen los ejercicios
for i = 1:num_estudiantes
    fprintf('El estudiante %d hace el ejercicio %02d.(jpg/png) \n', estudiante(i), ejercicio(i))
end