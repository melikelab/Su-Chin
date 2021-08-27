

%Adaprted from Chiara

%% Voronoi tessels statistic

% adjsut the paramter in the first part and then run the code
% output: figure 2x2 with histograms (left) and cdf (rigth) of all the
% single experiments (top) and the mean values (bottom)

% mean_hist contains m cell (one for each category) with mean values of
% tessels area and std 

% cvicario 20/06/2018
% update on 13/07/2018 (normalization factor density of localizations)
% update on 25/10/2018 (add standard deviation on plots)


clear all

%% parameter to add:

% number of categories (each category may include many experiments)
categ =3 ; 
% change jet colormap or add new colors as you wish
% Colors =jet(categ);
Colors = [0.49 0.18 0.56; 0.93 0.69 0.13; 0.85 0.32 0.09 ;0 0.48 0.74]; %(Purple, Yellow, Brown)
% Colors = [0.49 0.18 0.56];

% size of the line for the single experiment
sizeline_exp = 0.5;
% size of the line for the mean
sizeline_mean = 2;

edges_histogram = logspace(-8,8,500);
edges_cdf = logspace(-8,8,500);
[fileNames,path] = uigetfile('*.mat',  'All Files (*.*)','MultiSelect','on');


    
numFiles = length(fileNames);
normedAreas = {};
normedAreas_pulled = cell(numFiles,1);
logAreas = cell(numFiles,1);

for m = 1:categ        

    tempFile = load(fullfile(path,fileNames{m}));
    
    normedAreas{m} = [];
    logAreas{m} = [];
    for k = 1:length(tempFile.VoronoiAreas)
        normedAreas_pulled{m} = [normedAreas_pulled{m}; ...
            tempFile.VoronoiAreas{k}/mean(tempFile.VoronoiAreas{k})];
        normedAreas{m}{k} = tempFile.VoronoiAreas{k}/mean(tempFile.VoronoiAreas{k});
    
    
            figure(2)
        subplot(2,2,1)
        hold all
%         [N_hist{k},EDGES_hist{k}] = HistStepPlot(VoronoiAreas{m,1}{k},edges_histogram,Colors(m,:),sizeline_exp,'-');
        [N_hist{m}{k},EDGES_hist{m}{k}] = histcounts(1./normedAreas{m}{k},edges_histogram,'normalization','probability');
         plot(1./EDGES_hist{m}{k}(1:end-1),N_hist{m}{k},'-',...
            'LineWidth',sizeline_exp,...
            'Color',Colors(m,:));
        set (gca, 'Fontsize',14);
        grid on;
        set(gcf,'color','w');
        title('Tessels areas histogram')
        xlabel('nm^{-2}')
        ylabel('Probability')
        
        set(gca, 'XScale', 'log') 
         
        
        % figure 2x2, top right
        % overlay of all cfd of the experiments in the specified 
        % category (thin line, color of the category)
        figure(2)
        subplot(2,2,2)
        hold all
        %[N{m}{k},EDGES{m}{k}] = histcounts(normedAreas{m}{k},edges_cdf,'normalization','cdf');
        
        [N{m}{k},EDGES{m}{k}] = histcounts(1./normedAreas{m}{k},edges_cdf,'Normalization','cdf');
        
        % area normalization
%         F{k} = cumsum(N{k})./sum(N{k});
%         plot(EDGES{k}(:,1:end-1),F{k},'Color',Colors(m,:),'linewidth',sizeline_exp);
        %plot(1./EDGES{m}{k}(:,1:end-1),N{m}{k},'Color',Colors(m,:),'linewidth',sizeline_exp);
         plot(EDGES{m}{k}(:,1:end-1),N{m}{k},'Color',Colors(m,:),'linewidth',sizeline_exp);
        set(gca, 'XScale', 'log') 
        set (gca, 'Fontsize',14);
        grid on;
        set(gcf,'color','w');  
        title('Tessels areas CDF')
        xlabel('nm^{-2}')
        ylabel('Probability')
%     
    end


    general_hist{m} = vertcat(N_hist{m}{:});
    general_cum{m} = vertcat(N{m}{:});
    
    % mean values 
    
    mean_hist{m}(1,:) = mean(general_hist{m},1);
    mean_hist{m}(2,:) = std(general_hist{m},1);
%     mean_hist{m}(2,:) = std(general_hist{m},1) / sqrt(length(general_hist{m}));
    
    mean_cum{m}(1,:) = mean(general_cum{m},1);
    mean_cum{m}(2,:) = std(general_cum{m},1);
%     mean_cum{m}(2,:) = std(general_cum{m},1) / sqrt(length(general_cum{m}));
    
    % figure 2x2, bottom left
    % mean histogram of all the experiments in the specified category
    figure(2)
    subplot(2,2,3)
    hold all
    p = plot(1./EDGES_hist{m}{1}(:,1:end-1),mean_hist{m}(1,:),...
        'linewidth',sizeline_mean,...
        'Color',Colors(m,:));
     p.Color(4) = 0.7; 
    % with std
        p = plot(1./EDGES_hist{m}{1}(:,1:end-1),(mean_hist{m}(1,:)+mean_hist{m}(2,:)),...
        'linewidth',0.5,...
        'linestyle','--',...
        'Color',Colors(m,:));
     p.Color(4) = 0.7;
            p = plot(1./EDGES_hist{m}{1}(:,1:end-1),(mean_hist{m}(1,:)-mean_hist{m}(2,:)),...
        'linewidth',0.5,...
        'linestyle','--',...
        'Color',Colors(m,:));
     p.Color(4) = 0.7;
    set (gca, 'Fontsize',14);
    grid on;
    set(gcf,'color','w');
    xlabel('nm^{-2}')
    ylabel('Probability')
    
        set(gca, 'XScale', 'log') 
    
    % figure 2x2, bottom right
    % mean cdf of all the experiments in the specified category
    figure(2)
    subplot(2,2,4)
    hold all
    p = plot(EDGES{m}{1}(:,1:end-1),mean_cum{m}(1,:),...
        'linewidth',sizeline_mean,...
        'Color',Colors(m,:));
    p.Color(4) = 0.7;   
    % with std
        p = plot(EDGES{m}{1}(:,1:end-1),mean_cum{m}(1,:)+mean_cum{m}(2,:),...
        'linewidth',0.5,...
        'linestyle','--',...
        'Color',Colors(m,:));
     p.Color(4) = 0.7;
            p = plot(EDGES{m}{1}(:,1:end-1),mean_cum{m}(1,:)-mean_cum{m}(2,:),...
        'linewidth',0.5,...
        'linestyle','--',...
        'Color',Colors(m,:));
     p.Color(4) = 0.7;
% %     
    
    
    set(gca, 'XScale', 'log') 
    set (gca, 'Fontsize',14);
    grid on;
    set(gcf,'color','w');
    xlabel('nm^{-2}')
    ylabel('Probability')
    
    % figure 3,
    % mean cdf of all the experiments in the specified category
%     figure(3)
%     hold all   
%         
%     p = plot(EDGES{m}{1}(:,1:end-1),mean_cum{m}(1,:),...
%         'linewidth',sizeline_mean,...
%         'Color',Colors(m,:));
%     p.Color(4) = 0.7;   
%     % with std
%         p = plot(EDGES{m}{1}(:,1:end-1),mean_cum{m}(1,:)+mean_cum{m}(2,:),...
%         'linewidth',0.5,...
%         'linestyle','--',...
%         'Color',Colors(m,:));
%      p.Color(4) = 0.7;
%             p = plot(EDGES{m}{1}(:,1:end-1),mean_cum{m}(1,:)-mean_cum{m}(2,:),...
%         'linewidth',0.5,...
%         'linestyle','--',...
%         'Color',Colors(m,:));
%      p.Color(4) = 0.7;
% % %     
%     
%     
%     set(gca, 'XScale', 'log') 
%     set (gca, 'Fontsize',14);
%     grid on;
%     set(gcf,'color','w');
%     xlabel('nm^{2}')
%     ylabel('Probability')

end
