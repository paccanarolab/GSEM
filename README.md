# GSMC
Geometric Sparse Matrix Completion Model for Predicting Drug Side Effects

Matlab scripts to run the algorithm.

* DRIVERscript.m contains the code to run our model in a cross-validation settting in our dataset.
* GSMCc.m contains the implementation of our algorithm.
* performanceEvaluation.m returns AUC and AUPR.
* data/ folder contains the data used in our studies.

The usage of the GSMC model is very simple, explained step-by-step below:

## Step 1: Column model GSMC-c

It uses the graph regularization on the semantic similarities between diseases.

``` Matlab
[ Xc, ~ ] = GSMCc( Xtrain,...     % binary input matrix
                               {},...     % side graphs for side effects
                               [],...     % alpha_c for side graphs
                               1,...      % beta_c
                               0.5,...    % lambda_c
                               0.01,...   % initial variance in C
                               10^4,...   % gamma_c
                               1e-2,100); % tolX, maxiter (stopping criteria)
```
## Step 2: Row model GSMC-r

It uses the graph regularization on the human PPI network.

``` Matlab
 [ Xr, ~ ] = GSMCc( Xtrain',...    % binary input matrix
                               G,...      % side graphs for drugs
                               [0.5,1,1,0.01],...     % alpha for drugs
                               2,...      % beta_r
                               0.5,...    % lambda_r
                               0.01,...   % initial variance in C
                               10^4,...   % gamma_r
                               1e-2,100); % tolX, maxiter (stopping criteria)
```
## Step 3: Final linear combination
``` Matlab
 p = 0.45;
    Xhat = p*Xc + (1-p)*Xr'; 
``` 

