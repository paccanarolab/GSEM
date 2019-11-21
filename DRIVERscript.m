%% Interpretable drug side effect prediction
% Geometric self-expressive model (GSEM)
% author: Diego Galeano, 21/05/2019
% Copyright: MIT 

% Initialization
clear all; close all; clc;
addpath('source'); addpath('data');

% Load the side effect data
load('sideEffectdata.mat');

% Load the side graphs for drugs 
% G{1} is chemical similarity
% G{2} is drug-drug interaction.
% G{3} is drug target similarity.
% G{4} is drug indication similarity.
load('DrugGraphs');

% Cross-validation
nfolds = 10;
AUROC = zeros(nfolds, 1);
AUPRC = zeros(nfolds, 1);
time = zeros(nfolds, 1);

parfor i = 1:nfolds % use normal 'for' if do not want to parallelize
    Xtrain = full(double(R_train{i}));
    Xtest = full(double(R_test{i}));
    
    tStart = tic;
    % Learn C by using the GSEMc model 
    [ Xc, ~ ] = GSEMc( Xtrain,...     % binary input matrix
                               {},...     % side graphs for side effects
                               [],...     % alpha_c for side graphs
                               1,...      % beta_c
                               0.5,...    % lambda_c
                               0.01,...   % initial variance in C
                               10^4,...   % gamma_c
                               1e-2,100); % tolX, maxiter (stopping criteria)
                                 
    % Learn R by using the GSEMr model 
    [ Xr, ~ ] = GSEMc( Xtrain',...    % binary input matrix
                               G,...      % side graphs for drugs
                               [0.5,1,1,0.01],...     % alpha for drugs
                               2,...      % beta_r
                               0.5,...    % lambda_r
                               0.01,...   % initial variance in C
                               10^4,...   % gamma_r
                               1e-2,100); % tolX, maxiter (stopping criteria)
    
    % Prediction model GSMC
    p = 0.45;
    Xhat = p*Xc + (1-p)*Xr'; 
    
    % measure the time
    time(i) = toc(tStart); 
    
    [AUROC(i), AUPRC(i) ] = performanceEvaluation( Xtest, Xtrain, Xhat);
    
end


fprintf('\n mAUC = %.3f (std %.4f)\n', mean(AUROC), std(AUROC));
fprintf('\n mAUPR = %.3f (std %.4f)\n', mean(AUPRC), std(AUPRC));
fprintf(  '\n mTime = %.3f (std %.4f)\n', mean(time), std(time));

% ----------------- end -----------------------------------------------