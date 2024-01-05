%% Not Considering the weights
clear all; close all;clc;

% Initialising measuremants of distances from each base tower to the phone
num_pings = 1000;
pings = measurements(num_pings);



%%
% Initialising the inital coordinatess, maximum iterations and the
% tolerance of LMM
p0 = [5;5];
max_iter = 100;
tol = 1e-6;

% Initialising all the weights to 1
weights = [1,1,1];

% Initializing the arrays for plotting the results
parameter_x = zeros(num_pings,1);
parameter_y = zeros(num_pings,1);
variance_of_measuremants = zeros(num_pings,2);
Num_iteratins = zeros(num_pings,1);
accuracys = zeros(num_pings,1);
variances = zeros(num_pings,1);

%  Testing the NLS with different number of measuremants
for i = 1:num_pings
    pings1 = pings(1:i,:);
    ping_size = size(pings1);
    num_pings = ping_size(1);
    [x,H,f,iter,C_par] = LMM(p0, max_iter, tol, @function_J_f, pings1,weights);
    parameter_x(i) = x(1);
    parameter_y(i) = x(2);
    Num_iteratins(i) = iter;
    accuracys(i) = mean(f);
    variances(i) = var(f);

    variance_of_measuremants(i,:) = diag(C_par);
end
fprintf("\n Not weighted \n")
fprintf("Results with %d numbers of measuremants from each tower: \n \n",num_pings);
fprintf("- Estitamed coordinates are: (%d, %d). \n", x(1),x(2));
fprintf("- Mean of the error is %d. \n", mean(f));
fprintf("- error variance is %d \n" , variances(end));
fprintf("- Estimated variance of the parameter x is %d and variance of the parameter y is %d. \n", variance_of_measuremants(end,1), variance_of_measuremants(end,2));
fprintf("- Number of iterations: %d \n", iter)


% ploting the parameter x during iterations
figure(1)
plot(parameter_x(2:end))
hold on;

% Plotting the errorbars
plot(parameter_x(2:end) - sqrt(variance_of_measuremants(2:end,1)))
hold on;
plot(parameter_x(2:end) + sqrt(variance_of_measuremants(2:end,1)))
hold off;

xlabel('Measurements');
ylabel('x');
title('Value of coordinate x through measurements');

legend({'Parameter x', ' x - sqrt(estimated variance of x)', 'x + sqrt(estimated variance of x)'});


% ploting the parameter x during iterations
figure(2)
plot(parameter_y(2:end))
hold on;

% Plotting the errorbars
plot(parameter_y(2:end) - sqrt(variance_of_measuremants(2:end,2)))
hold on;
plot(parameter_y(2:end) + sqrt(variance_of_measuremants(2:end,2)))
hold off;

xlabel('Measurements');
ylabel('y');
title('Value of coordinate y through measurements');

legend({'Parameter y', ' y - sqrt(estimated variance of y)', 'y + sqrt(estimated variance of y)'});



% variance of x
figure(3)
plot(variance_of_measuremants(:,1))
xlabel('Measuremants');
ylabel('Estimated variance');
title('Estimated variance of parameter x through measuremants');

% variance of y
figure(4)
plot(variance_of_measuremants(:,2))
xlabel('Measuremants');
ylabel('Estimated variance');
title('Estimated variance of parameter y through measuremants')
 
% ploting the values of objective function With all measuremants
figure(5)
plot(f)
xlabel('measuremants');
ylabel('f = (Measuremants - modeled distances)');
title('Ploting the f with all 3000 measuremants');



% ploting the error bias through measuremants
figure(6)
plot(variances(2:end))
xlabel('Number of measuremants used');
ylabel('Estimated variance');
title('Estimated variance error')


% ploting the error variance through measuremants
figure(7)
plot(accuracys(2:end))
xlabel('Number of measuremants used');
ylabel('Estimated error variance');
title('Estimated error bias')















%  reshape(pings', [], 1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Considering the weights
% Variance of parameters decreases

num_pings = 1000;

% Calculating the standard deviation from the measuremants
weights = [1/var(pings(:,1)), 1/var(pings(:,2)), 1/var(pings(:,3))]/sum([1/var(pings(:,1)), 1/var(pings(:,2)), 1/var(pings(:,3))]);
% weights = [1/var(pings(:,1)), 1/var(pings(:,2)), 1/var(pings(:,3))];

% Initializing the arrays for plotting the results
parameter_x = zeros(num_pings,1);
parameter_y = zeros(num_pings,1);
variance_of_measuremants = zeros(num_pings,2);
accuracys = zeros(num_pings,1);
variances = zeros(num_pings,1);

%  Testing the LMM with different number of measuremants
for i = 1:num_pings
    pings1 = pings(1:i,:);
    ping_size = size(pings1);
    num_pings = ping_size(1);
    [x,H,f,iter,C_par] = LMM(p0, max_iter, tol, @function_J_f, pings1,weights);
    parameter_x(i) = x(1);
    parameter_y(i) = x(2);
    Num_iteratins(i) = iter;
    accuracys(i) = mean(f);
    variances(i) = var(f);
%     variance_of_measuremants(i,:) = diag(inv(H));
    variance_of_measuremants(i,:) = diag(C_par);
end
fprintf("\n Weighted \n")
fprintf("Results with %d numbers of measuremants from each tower: \n \n",num_pings);
fprintf("- Estitamed coordinates are: (%d, %d). \n", x(1),x(2));
fprintf("- Mean of the error is %d. \n", mean(f));
fprintf("- error variance is %d \n" , variances(end));
fprintf("- Estimated variance of the parameter x is %d and variance of the parameter y is %d. \n", variance_of_measuremants(end,1), variance_of_measuremants(end,2));
fprintf("- Number of iterations: %d \n" , iter)



% Start ploting from 2 measuremants because the variance of 1 measuremant
% is 0...


% ploting the parameter x during iterations
figure(1)
plot(parameter_x(2:end))
hold on;
% Plotting the errorbars
plot(parameter_x(2:end) - sqrt(variance_of_measuremants(2:end,1)))
hold on;
plot(parameter_x(2:end) + sqrt(variance_of_measuremants(2:end,1)))
hold off;
xlabel('Measurements');
ylabel('x');
title('Value of coordinate x through measurements');

legend({'Parameter x', ' x - sqrt(estmamted variance of x)', 'x + sqrt(estimated variance of x)'});


% ploting the parameter y during iterations
figure(2)
plot(parameter_y(2:end))
hold on;
% Plotting the errorbars
plot(parameter_y(2:end) - sqrt(variance_of_measuremants(2:end,2)))
hold on;
plot(parameter_y(2:end) + sqrt(variance_of_measuremants(2:end,2)))
hold off;

xlabel('Measurements');
ylabel('y');
title('Value of coordinate y through measurements');

legend({'Parameter y', ' y - sqrt(estimated variance of y)', 'y + sqrt(estimated variance of y)'});


% variance of x
figure(3)
plot(variance_of_measuremants(2:end,1))
xlabel('Number of measuremants used');
ylabel('Estimated variance');
title('Estimated variance of parameter x through measuremants');

% variance of y
figure(4)
plot(variance_of_measuremants(2:end,2))
xlabel('Number of measuremants used');
ylabel('Estimated variance');
title('Estimated variance of parameter y through measuremants')
 
% ploting the values of objective function With all measuremants
figure(5)
plot(f)
xlabel('measuremants');
ylabel('f = (Measuremants - modeled distances)');
title('Ploting the f with all 3000 measuremants');



% ploting the error bias through measuremants
figure(6)
plot(variances(2:end))
xlabel('Number of measuremants used');
ylabel('Estimated variance');
title('Estimated error variance')


% ploting the error variance through measuremants
figure(7)
plot(accuracys(2:end))
xlabel('Number of measuremants used');
ylabel('Estimated error variance');
title('Estimated error bias')














%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOTING COUNTOUR

% Define the grid
[x_vals, y_vals] = meshgrid(linspace(-5, 15, 100), linspace(-5, 10, 100));


% Initialize the function values
f_vals = zeros(size(x_vals));

% Evaluate the objective function over the grid
for i = 1:numel(x_vals)
    [f, ~] = function_J_f([x_vals(i), y_vals(i)], pings, [1, 1, 1]);
    f_vals(i) = sum(f.^2); % Calculate the sum of squared residuals
end

% Reshape the function values into a matrix
f_matrix = reshape(f_vals, size(x_vals));

% Create a contour plot
levels = linspace(0, max(f_vals,[],"all"), 20);
contourf(x_vals, y_vals, f_matrix, levels);
colorbar;
xlabel('X coordinate');
ylabel('Y coordinate');
title('Contour plot of loss function');
%% 3D Plot
% Define the grid
[x_vals, y_vals] = meshgrid(linspace(-5, 15, 100), linspace(-5, 10, 100));

% Evaluate the objective function over the grid
f_vals = zeros(size(x_vals));
for i = 1:numel(x_vals)
    [f, ~] = function_J_f([x_vals(i), y_vals(i)], pings, [1, 1, 1]);
    f_vals(i) = sum(f.^2);
end

% Reshape the function values into a matrix
f_matrix = reshape(f_vals, size(x_vals));

% Create a 3D surface plot
figure;
surf(x_vals, y_vals, f_matrix);
xlabel('X coordinate');
ylabel('Y coordinate');
zlabel('Objective function value');
title('Surface plot of objective function');
%% Just to check the results
% Define the noise levels for each measurement
w = [0.1; 0.01; 0.05];


% Initialising measuremants of distances from each base tower to the phone
num_pings = 1000;
pings = measurements(num_pings);

% Initialising the inital coordinatess
x0 = [3,3];

% Calculating the standard deviation from the measuremants
w = [1/std(pings(:,1))^2, 1/std(pings(:,2))^2, 1/std(pings(:,3))^2];


fun = @(x) function_J_f(x, pings, w);

% Call the lsqnonlin function to minimize the objective function
[x,~,f,~,~] = lsqnonlin(fun, x0);

% Display the estimated phone location
disp(['Estimated phone location: (' num2str(x(1)) ', ' num2str(x(2)) ')']);
fprintf("~n mean of error is %d \n", mean(f));


