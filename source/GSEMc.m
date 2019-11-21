function [ Xhat, Ct1 ] = GSEMc( X, G, alpha, mbeta, mlambda, variance, mgamma, tolX, maxiter)
% GSEMc: Geometric Self-Expressive Model (COLUMN).
% INPUTS:
% X: binary n x m matrix.
% G: cell array of L elements containing the graph side
% information. Each G{j} contains a matrix of m x m.
% alpha: vector of L elements containing the penalization for each
% graph. alpha(j) corresponds to G{j}.
% mbeta: L2- regularization parameter.
% mlambda: L1- regularization parameter.
% gamma: null-diagonal penalization. Typical value 10^4.
% variance: variance of the initial distribution of weights for C.
% Typical value 1e-2.
% tolX: the max change tolerable in C (stopping criteria). Typical
% value 1e-2.
% maxiter: maximun number of iterations. Typical value 100.
% OUTPUTS:
% Xhat: prediction scores.
% Ct1: matrix C of m x m described in the paper.
[~, m] = size(X); % column dimension
L = length(G);    % number of graphs in cell G
Ct1 = rand(m, m)*sqrt(variance); % initialization
I = eye(m); % identity matrix
COV = X'*X; % covariance matrix
Ct0 = Ct1;  % C in t - 1

if ~isempty(G) % graphs available
    Dc = zeros(size(Ct1));
    Gc = zeros(size(Ct1));
    for i = 1:L           
          Dc = Dc + alpha(i).*diag(sum(G{i},2)); 
          Gc = Gc + alpha(i).*G{i};
    end
    
    for iter = 1:maxiter        
        numerator = COV + Ct1*Gc;
        denominator = COV*Ct1 + Ct1*Dc + mbeta*Ct1  + mlambda + mgamma*I +  eps(numerator);
        Ct1 = max(0, Ct0.* (numerator./denominator)); % update C

        % stopping criteria
        dw = max(max(abs(Ct1-Ct0) / (sqrt(eps)+max(max(abs(Ct0))))));
        if dw <= tolX
            break;
        end
        Ct0 = Ct1; % memory
    end
else
    for iter = 1:maxiter      
        numerator = COV;
        denominator = COV*Ct1 + mbeta*Ct1  + mlambda + mgamma*I +  eps(numerator);

        Ct1 = max(0, Ct0.* (numerator./denominator)); % update C

        % stopping criteria
        dw = max(max(abs(Ct1-Ct0) / (sqrt(eps)+max(max(abs(Ct0))))));
        if dw <= tolX
            break;
        end
        Ct0 = Ct1; % memory
    end
    
    
end

Xhat = X*Ct1; % scores
end

