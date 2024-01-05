

function [f, J] = function_J_f(x, pings,w)
% x, y: the coordinates of the mobile phone
% pings: a matrix of size num_pings x 3 containing the measurements from
%        the three base stations for each ping
% n: a vector containing the noise levels for each measurement

% Number of measurements
num_pings = size(pings, 1);

tower_positions = [1, 1; 10, 5; 2, 4];


% Initialize the function value and Jacobian matrix
f = zeros(num_pings * 3, 1);
J = zeros(num_pings * 3, 2);

for i = 1:num_pings
    for j = 1:3
        % Calculate the expected distance for the j-th measurement of the i-th ping
        expected_d = sqrt((x(1) - tower_positions(j, 1))^2 + (x(2) - tower_positions(j, 2))^2);
        
        % Evaluate the function f in vector form (y - modeled_y)
        k = (i - 1) * 3 + j;
        f(k) = (expected_d - pings(i, j))*w(j);
        
        % Evaluate the Jacobian matrix
        J(k, 1) = w(j)*(x(1) - tower_positions(j, 1)) / expected_d;
        J(k, 2) = w(j)*(x(2) - tower_positions(j, 2)) / expected_d;
    end
end
end


















