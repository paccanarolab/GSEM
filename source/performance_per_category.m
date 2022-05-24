function [auroc_per_ATC, aupr_per_ATC, auroc_per_MedDRA,aupr_per_MedDRA] = performance_per_category(Xhat, X, Xpost, Xoff, ATC, MedDRA)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
  
   
    nATCs = size(ATC, 2);
    nMedDRA = size(MedDRA, 2);


    auroc_per_ATC = cell(nATCs, 2);
    aupr_per_ATC = cell(nATCs, 2);
    aupr_per_MedDRA = cell(nMedDRA, 2);
    auroc_per_MedDRA = cell(nMedDRA, 2);
    
    for i = 1:nATCs
       idx = find(ATC(:, i) > 0);
       
       auc_per_drug_sider = [];
       aupr_per_drug_sider = [];
       
       auc_per_drug_off = [];
       aupr_per_drug_off = [];
       
       % for drugs on this category
       for j = 1:length(idx)
           % SIDER test set
           if sum(Xpost(idx(j),:)) >= 10
                labels = Xpost(idx(j),:) > 0;
                scores = Xhat(idx(j),:);
                % delete training
                labels(X(idx(j),:) > 0) = [];
                scores(X(idx(j),:) > 0) = [];       

           
               [~,~,~,AUC] = perfcurve(labels,scores, 1);
               [~,~,~,AUPR] = perfcurve(labels,scores, 1, 'xCrit', 'reca', 'yCrit', 'prec');
               
               auc_per_drug_sider = [auc_per_drug_sider, AUC];
               aupr_per_drug_sider = [aupr_per_drug_sider, AUPR];
           end
           
           % OFFSIDES test set
           if sum(Xoff(idx(j),:)) >= 10
                labels = Xoff(idx(j),:);
                scores = Xhat(idx(j),:);
                % delete training
                labels(X(idx(j),:) > 0) = [];
                scores(X(idx(j),:) > 0) = [];       

           
               [~,~,~,AUC] = perfcurve(labels,scores, 1);
               [~,~,~,AUPR] = perfcurve(labels,scores, 1, 'xCrit', 'reca', 'yCrit', 'prec');
               
               auc_per_drug_off = [auc_per_drug_off, AUC];
               aupr_per_drug_off = [aupr_per_drug_off, AUPR];
           end
           
       end
       if ~isempty(auc_per_drug_sider)
           auroc_per_ATC{i, 1} = auc_per_drug_sider;
       end
       
       if ~isempty(aupr_per_drug_sider)
           aupr_per_ATC{i, 1} = aupr_per_drug_sider;  
       end
       
       if ~isempty(auc_per_drug_off)
            auroc_per_ATC{i, 2} = auc_per_drug_off;
           
       end
       
       if ~isempty(aupr_per_drug_off)
           aupr_per_ATC{i, 2} = aupr_per_drug_off;  
       end
       
       
      
       
       
    end
    
    
    for i = 1:nMedDRA
       idx = find(MedDRA(:, i) > 0);
       
       auc_per_se_sider = [];
       aupr_per_se_sider = [];
       
       auc_per_se_off = [];
      aupr_per_se_off = [];
       
       % for side effects on this category
       for j = 1:length(idx)
           if sum(Xpost(:, idx(j))) >= 10
                labels = Xpost(:,idx(j));
                scores = Xhat(:, idx(j));
                % delete training
                labels(X(:, idx(j)) > 0) = [];
                scores(X(:, idx(j)) > 0) = [];       

           
               [~,~,~,AUC] = perfcurve(labels,scores, 1);
               [~,~,~,AUPR] = perfcurve(labels,scores, 1, 'xCrit', 'reca', 'yCrit', 'prec');
               
               auc_per_se_sider = [auc_per_se_sider, AUC];
               aupr_per_se_sider = [aupr_per_se_sider, AUPR];
           end
           
        
           if sum(Xoff(:, idx(j))) >= 10
                labels = Xoff(:,idx(j));
                scores = Xhat(:, idx(j));
                % delete training
                labels(X(:, idx(j)) > 0) = [];
                scores(X(:, idx(j)) > 0) = [];       

           
               [~,~,~,AUC] = perfcurve(labels,scores, 1);
               [~,~,~,AUPR] = perfcurve(labels,scores, 1, 'xCrit', 'reca', 'yCrit', 'prec');
               
               auc_per_se_off = [auc_per_se_off, AUC];
               aupr_per_se_off = [aupr_per_se_off, AUPR];
           end
       end
       
       if ~isempty(auc_per_se_sider)
           auroc_per_MedDRA{i, 1} = auc_per_se_sider;
       end
       if ~isempty(auc_per_se_off)
           auroc_per_MedDRA{i, 2} = auc_per_se_off;
       end
       if ~isempty(aupr_per_se_sider)
           aupr_per_MedDRA{i, 1} = aupr_per_se_sider;
       end
       
       if ~isempty(aupr_per_se_off)
           aupr_per_MedDRA{i, 2} = aupr_per_se_off;
       end
       
    end

%     result = struct('auroc_ATC', auroc_per_ATC,...
%                     'aupr_ATC', aupr_per_ATC,...
%                     'auroc_meddra', auroc_per_MedDRA,...
%                     'aupr_meddra', aupr_per_MedDRA);
                
   
end


