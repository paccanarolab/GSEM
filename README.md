# Interpretable drug side effect prediction
Geometric Self-Expressive Model (GSEM)

Matlab scripts to run the algorithm.

* DRIVERscript.m contains the code to run our model in a cross-validation settting in our dataset.
* GSEMc.m contains the implementation of our algorithm.
* performanceEvaluation.m returns AUC and AUPR.
* data/ folder contains the data used in our studies.

The usage of the GSEM model is very simple, explained step-by-step below:

## Step 1: Column model GSEMc

``` Matlab
[ Xc, ~ ] = GSEMc( Xtrain,...     % binary input matrix
                               {},...     % side graphs for side effects
                               [],...     % alpha_c for side graphs
                               1,...      % beta_c
                               0.5,...    % lambda_c
                               0.01,...   % initial variance in C
                               10^4,...   % gamma_c
                               1e-2,100); % tolX, maxiter (stopping criteria)
```
## Step 2: Row model GSEMr

``` Matlab
 [ Xr, ~ ] = GSEMc( Xtrain',...    % binary input matrix
                               G,...      % side graphs for drugs
                               [0.5,1,1,0.01],...     % alpha for drugs
                               2,...      % beta_r
                               0.5,...    % lambda_r
                               0.01,...   % initial variance in C
                               10^4,...   % gamma_r
                               1e-2,100); % tolX, maxiter (stopping criteria)
```
## Step 3: Linear combination
``` Matlab
 p = 0.45;
    Xhat = p*Xc + (1-p)*Xr'; 
``` 

## References

If you find these resources useful, please cite our work: 

Galeano, Diego Ariel Galeano, and Alberto Paccanaro. "The Geometric Sparse Matrix Completion Model for Predicting Drug Side effects." bioRxiv (2019): 652412.
