  function [AUROC, AUPRC, XROC_AUC, YROC_AUC,XPR, YPR ] = performanceEvaluation( YTest, YTrain, Res)
      
                YTest = full(YTest); YTrain = full(YTrain);        
                poslabels = YTest > 0;
                neglabels = YTrain == 0 & YTest == 0;

                no_poslabels = sum(poslabels(:));
                no_neglabels = sum(neglabels(:));
                fprintf('\n number of pos labels %d neg %d\n', no_poslabels, no_neglabels);

                % Define the labels
                labels = zeros(no_poslabels + no_neglabels,1);
                labels(1:no_poslabels) = ones(no_poslabels,1);

                % Get the predicted scores.
                scores = zeros(no_poslabels + no_neglabels,1);
                scores(1:no_poslabels) = Res(poslabels);   
                scores(no_poslabels+1:end) = Res(neglabels);   

                [XROC_AUC,YROC_AUC,~, AUROC] = perfcurve(labels,scores,1);
                
                [XPR,YPR,~, AUPRC] = perfcurve(labels,scores, 1,'xCrit', 'reca', 'yCrit', 'prec');

        end
