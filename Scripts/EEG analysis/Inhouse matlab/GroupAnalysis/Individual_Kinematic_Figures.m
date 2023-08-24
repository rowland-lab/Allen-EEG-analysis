clear all
clc

% Add Github Path
gitpath = 'C:\Users\allen\Documents\GitHub\Allen-EEG-analysis';
cd(gitpath)
allengit_genpaths(gitpath,'tDCS')

% CSV Paths
healthy_table_path = 'C:\Users\allen\Documents\tDCS_VR\healthy_metric.xlsx';
stroke_table_path = 'C:\Users\allen\Documents\tDCS_VR\stroke_metric.xlsx';

% Metrics analyzed
metrics = {'avgAcceleration','maxAcceleration'};

%% Create a figure with each metric

stim_types_name = {'Sham','Anodal'};
stim_types = [0 2];
diseases = {'healthy','stroke'};
timepoints = {'BL','ES','LS','PS'};

for m = 1:numel(metrics)
    figure('WindowState','maximized')
    axies = [];
    for d = 1:numel(diseases)
        
        % Load csv
        data_table = readtable(eval([diseases{d},'_table_path']),'Sheet',metrics{m});
        sham_data = data_table{data_table.StimulationType == 0,3:6};
        anodal_data = data_table{data_table.StimulationType == 2,3:6};


        % Plot Individual
        nt = nexttile;
        axis square
        hold on
        a1 = plot(sham_data','o--','Color',[0.7 0.7 0.7]);
        a2 = plot(anodal_data','ok-');
        legend([a1(1) a2(1)],stim_types_name)
        axies = [axies;nt];

        
        xlim([0 5]);
        xticks(1:4);
        xticklabels(timepoints)
        title(diseases{d})

        % Plot Bar
        nt = nexttile;
        axis square
        bar_xdata = [zeros(size(timepoints));ones(size(timepoints))];
        bar_ydata = [mean(sham_data,1); mean(anodal_data,1)]';
        error = [std(sham_data,1)/sqrt(size(sham_data,1)); std(anodal_data,1)/sqrt(size(anodal_data,1))]';
        ab = bar([0 1],bar_ydata);
        hold on
        bar_xpoints = cat(1,ab.XEndPoints);
        errorbar(bar_xpoints(:),bar_ydata(:),error(:),'Color',[0 0 0],'LineStyle','none');    
        axies = [axies;nt];
    end
    
    linkaxes(axies','y')
    sgtitle(metrics{m})
end
        