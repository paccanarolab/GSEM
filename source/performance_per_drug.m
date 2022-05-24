function [result, result_binned] = performance_per_drug(Xhat,X, Xpost, Xoffs)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
    [ndrugs, nses] = size(X);
    characterisation_drugs = sum(X > 0, 2);

    RRF_ses = sum(X > 0, 1);

    RRF_ses = RRF_ses./max(RRF_ses);


    auroc_per_drug_sider = zeros(1,1);
    aupr_per_drug_sider = zeros(1,1);
    count_per_drug_training_sider = zeros(1,1);
    mean_char_ses_sider = zeros(1,1);
    p  = 1;
    for i = 1:ndrugs
        if sum(Xpost(i,:)) >= 10
            labels = Xpost(i,:);
            scores = Xhat(i,:);
            % delete training
            labels(X(i,:) > 0) = [];
            scores(X(i,:) > 0) = [];       
            mean_char_ses_sider(p) = median(RRF_ses(Xpost(i,:) > 0));
            count_per_drug_training_sider(p) = characterisation_drugs(i);
            [~,~,~,auroc_per_drug_sider(p)] = perfcurve(labels,scores, 1);
            [~,~,~,aupr_per_drug_sider(p)] = perfcurve(labels,scores, 1, 'xCrit', 'reca', 'yCrit', 'prec');

            p = p + 1;
        end    
    end
    
    %% OFFSIDES
    auroc_per_drug_off = zeros(1,1);
    aupr_per_drug_off = zeros(1,1);
    count_per_drug_training_off = zeros(1,1);
    mean_char_ses_off = zeros(1,1);
    p  = 1;
    for i = 1:ndrugs
        if sum(Xoffs(i,:)) >= 10
            labels = Xoffs(i,:);
            scores = Xhat(i,:);
            % delete training
            labels(X(i,:) > 0) = [];
            scores(X(i,:) > 0) = [];       
            mean_char_ses_off(p) = median(RRF_ses(Xoffs(i,:) > 0));
            count_per_drug_training_off(p) = characterisation_drugs(i);
            [~,~,~,auroc_per_drug_off(p)] = perfcurve(labels,scores, 1);
            [~,~,~,aupr_per_drug_off(p)] = perfcurve(labels,scores, 1, 'xCrit', 'reca', 'yCrit', 'prec');

            p = p + 1;
        end    
    end
    
   


    result = struct('auroc_sider', auroc_per_drug_sider,...
                    'aupr_sider', aupr_per_drug_sider,...
                    'count_sider', count_per_drug_training_sider,...
                    'rrf_sider', mean_char_ses_sider,...
                    'auroc_offs', auroc_per_drug_off,...
                    'aupr_offs', aupr_per_drug_off,... 
                    'rrf_off', mean_char_ses_off,...
                    'count_off', count_per_drug_training_off);
                
    result = result(1);            
    nbins = 5;
    [~,edges] = histcounts(mean_char_ses_sider, nbins);
    group_sider_bins = [];
    auroc_sider_bins = [];
    aupr_sider_bins = [];
    labels_sider = cell(nbins, 1);
    
    for i = 1:length(edges)-1
        idx = mean_char_ses_sider >= edges(i) & mean_char_ses_sider < edges(i+1);
        group_sider_bins = [group_sider_bins, i.*ones(1,sum(idx))];
        auroc_sider_bins = [auroc_sider_bins, auroc_per_drug_sider(idx)];
        aupr_sider_bins = [aupr_sider_bins, aupr_per_drug_sider(idx)];
        labels_sider{i} = strcat('[', num2str(edges(i)), ',', num2str(edges(i+1)),')');    
    end 
    
    nbins = 5;
    [~,edges] = histcounts(mean_char_ses_off, nbins);
    group_offs_bins = [];
    auroc_offs_bins = [];
    aupr_offs_bins = [];
    labels_off = cell(nbins, 1);
    
    for i = 1:length(edges)-1
        idx = mean_char_ses_off >= edges(i) & mean_char_ses_off < edges(i+1);
        group_offs_bins = [group_offs_bins, i.*ones(1,sum(idx))];
        auroc_offs_bins = [auroc_offs_bins, auroc_per_drug_off(idx)];
        aupr_offs_bins = [aupr_offs_bins, aupr_per_drug_off(idx)];
        labels_off{i} = strcat('[', num2str(edges(i)), ',', num2str(edges(i+1)),')');    
    end 
    
    result_binned = struct('group_sider',group_sider_bins,...
                           'auroc_sider',auroc_sider_bins,...
                           'aupr_sider',aupr_sider_bins,...
                           'labels_sider', {labels_sider},...
                           'group_offs',group_offs_bins,...
                           'auroc_offs',auroc_offs_bins,...
                           'labels_offs',{labels_off},...
                             'aupr_offs',aupr_offs_bins);
                       
    result_binned = result_binned(1);
    
end

