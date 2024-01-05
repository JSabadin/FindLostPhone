function [x,H,f,iter,covariance] = LMM(x0, maxiter, tol, objective_function, pings, w)

    % Initialize parameters
    x = x0;
    alpha = 0.01;
    resnorm = inf;
    delta_x = inf;
    iter = 0;
    
    % Resnorm represents the difference between the predicted and actual values of the objective function,
    % whereas delta_x represents the difference between the estimated parameter values  in two consecutive iterations.
    % These are two different measures of convergence, and may not converge at the same rate or to the same level of accuracy.

    while (iter < maxiter) && (delta_x > tol) && (resnorm > tol)
        % If the primary goal is to estimate the parameter values with high accuracy, then delta_x may be more important
        % On the other hand, if the primary goal is to minimize the objective function with high accuracy, then resnorm may be more important.

        [f, J] = objective_function(x, pings,w);

    
        % Compute the Hessian approximation
        H = J' * J;
     
    
        % Add the damping parameter to the diagonal of H
        H = H + alpha * eye(2);
    
        % Compute the step direction
        p = -H \ (J' * f);
    
        % Compute the new parameter values
        x_new = x + p;
    
        % Evaluate the objective function at the new parameter values
        [f_new, J] = objective_function(x_new, pings,w);
    
        % Compute the new residual norm
        resnorm_new = norm(f_new);
     
        if resnorm_new < resnorm
            % If the new solution is better, accept it
            delta_x = norm(x_new - x);
            x = x_new;
            resnorm = resnorm_new;
            % For faster convergence
            alpha = max(alpha / 10, 1e-6); % Decrease apha parameter, with a minimum value of 1e-6
%             alpha = alpha / 10;
        else
            % If the new solution is worse, increase the alpha parameter
            % For better stabilitys
            alpha = min(alpha * 10, 1e6); % Increase damping parameter, with a maximum value of 1e6
%             alpha = alpha*10;
        end
    
        % Increment iteration counter
        iter = iter + 1;
    

%         covariance = inv(J' * J) * resnorm / (size(pings, 1) - length(x));
        % More robust than -> covariance = inv(J' * J) * resnorm / (size(pings, 1) - length(x));
        [U,S,V] = svd(J, 'econ');
        Sinv = diag(1./diag(S));
        covariance = V*Sinv*Sinv'*V';

%         MSE = (f'*f)/ (size(pings, 1) * 3 - 2);
%        covariance = inv(J' * J) * MSE;



    end
end
