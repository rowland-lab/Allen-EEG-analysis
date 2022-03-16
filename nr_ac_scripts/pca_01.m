%Code figure 2a PCA
%July 6, 2021

%Change path below to load data variable(s) and access FieldTrip toolbox
% C:\Users\Irene\Desktop\SourceCode_DataForFigs - use ctrl+F for Find & Replace tool


%% add scripts & toolboxes

cd('C:\Users\Irene\Desktop\SourceCode_DataForFigs');
addpath(genpath('C:\Users\Irene\Desktop\SourceCode_DataForFigs'));
rmpath(genpath('C:\Users\Irene\Desktop\SourceCode_DataForFigs\toolbox'));   %requires removal of toolboxes to run PCA


%% load matrix 39x84

load('C:\Users\Irene\Desktop\SourceCode_DataForFigs\figure_2_PCA\variable_figure_2a_PCA_20210706.mat');


%% panel A & B eigenanalysis & scree plots
%zscore input data and run matlab PCA covariance on it is the same as PCA correlation

%specify observations (subjects) - rows
data = FOI_ROI_all_avg2([1:11 12:25],:);   %HC11 STNOFF9 GPiOFF5
clear FOI*

data=metric_pca_all;
data_cs=metric_pca_all(1:10,:);
data_hc=metric_pca_all(11:21,:);
data_cs_hc_stm=metric_pca_all([1:5 11:16],:);
data_cs_hc_non=metric_pca_all([6:10 17:21],:);
data=data_cs_hc_non;
data=metric_pca_all_01;
data=data_cs;

%zscore data
zdata = zscore(data);
%pca uses covariance so must zscore

%PCA using COVARIANCE matrix
%coeff: rows contain coefficients (loadings) for the variables, columns correspond to the principal components (PC1, PC2, PC3, ...)
%score: representation of X in the principal component space. Rows of SCORE correspond to observations, columns to components.
%latent: eigenvalues of the covariance matrix (variances of the principal components)

%[coeff,score,latent] = princomp(zdata);
[coeff,score,latent] = pca(zdata);
latent_sz=size(latent,1);


% Table 1. Eigenanalysis of the correlation (top 30)
cumulative_var = cumsum(latent)./sum(latent); %latent=eigenvectors
%pc = permute([1:40],[2 1]);
pc = permute([1:latent_sz],[2 1]);
eigenvalue = latent(1:latent_sz); %sumulative sum of eigenvectors
proportion = latent(1:latent_sz)./sum(latent);
cumulative = cumulative_var(1:latent_sz);
table_eigenanalysis = table([pc eigenvalue proportion cumulative]);
table_eigenanalysis = [table(table_eigenanalysis.Var1(:,1),'VariableNames',{'Var11'}),table(table_eigenanalysis.Var1(:,2),'VariableNames',{'Var12'}),table(table_eigenanalysis.Var1(:,3),'VariableNames',{'Var13'}),table(table_eigenanalysis.Var1(:,4),'VariableNames',{'Var14'})];
table_eigenanalysis.Properties.VariableNames{1} = 'PC';
table_eigenanalysis.Properties.VariableNames{2} = 'Eigenvalue';
table_eigenanalysis.Properties.VariableNames{3} = 'Proportion';
table_eigenanalysis.Properties.VariableNames{4} = 'Cumulative';



% scree plot: scatter of component vs eigenvalue
%all 84 variables %20IN MY CASE
figure; 
subplot(2,1,1); hold on;
scatter(1:latent_sz,latent,'b','filled');
plot(1:latent_sz,latent,'b');
title('Scree plot','FontSize',16);
xlabel('Component','FontSize',16);
ylabel('Eigenvalue','FontSize',16);
xlim([1 20]);
ax = gca;
ax.FontSize = 12;

% % contributing principal components %closeup imaging can use 1-5 e.g.
% subplot(2,1,2); hold on;
% scatter(1:20,latent(1:20),'b','filled');
% plot(1:20,latent(1:20),'b');
% % title('Scree plot','FontSize',16);
% xlabel('Component','FontSize',16);
% ylabel('Eigenvalue','FontSize',16);
% xlim([1 20]);
% ax = gca;
% ax.FontSize = 12;
% 
% set(gcf,'color','w');
% fh1 = gcf;
% fh1.Position = [500,100,800,700];



% Percent contribution 84 variables (x-freq, y-regions). Unthresholded & thresholded
% weighted-average all PCs

% Note that, the total contribution of a given variable, on explaining the variations retained by two principal components, say PC1 and PC2, is calculated as contrib = [(C1 * Eig1) + (C2 * Eig2)]/(Eig1 + Eig2), where
% C1 and C2 are the contributions of the variable on PC1 and PC2, respectively
% Eig1 and Eig2 are the eigenvalues of PC1 and PC2, respectively. Recall that eigenvalues measure the amount of variation retained by each PC.
% In this case, the expected average contribution (cutoff) is calculated as follow: As mentioned above, if the contributions of the 10 variables were uniform, the expected average contribution on a given PC would be 1/10 = 10%. The expected average contribution of a variable for PC1 and PC2 is : [(10* Eig1) + (10 * Eig2)]/(Eig1 + Eig2)

%X=84;
X=size(data,2);

%create Xx1 contribution matrices for all PCs
varIdx = reshape(1:X,[],1);
for i=1:latent_sz;
    absCoeffPCx = abs(coeff(:,i));   %PCx
    varIdx_absCoeffPCx = [varIdx absCoeffPCx];   %105x2
    varIdx_absCoeffPCx_sum = sum(varIdx_absCoeffPCx(:,2));
    varIdx_absCoeffPCx_contribution = varIdx_absCoeffPCx;
    varIdx_absCoeffPCx_contribution(:,3) = varIdx_absCoeffPCx(:,2)./varIdx_absCoeffPCx_sum*100;    
    perc_contribution_PCx = varIdx_absCoeffPCx_contribution(:,3);   %105x1

    eval(['C' num2str(i) ' = perc_contribution_PCx']);
    
    eval(['Eig' num2str(i) ' = latent(' num2str(i) ')']);
end

for i=1:latent_sz;
    eval(['CxEig' num2str(i) ' = C' num2str(i) '*Eig' num2str(i)]);
end

%perc_contribution_PCwgtavg numerator
CxEig_all = CxEig1;
for i=2:latent_sz;
    eval(['CxEig_all = CxEig_all + CxEig' num2str(i)]);
end

%perc_contribution_PCwgtavg denominator
Eig_all = Eig1;
for i=2:latent_sz;
    eval(['Eig_all = Eig_all + Eig' num2str(i)]);
end

perc_contribution_PCwgtavg = CxEig_all / Eig_all;   %[(C1* Eig1) + (C2 * Eig2) + (C3 * Eig3) + (C4 * Eig4)] / (Eig1 + Eig2 + Eig3 + Eig4);

%perc_contribution_PCwgtavg_FOI_ROI = reshape(perc_contribution_PCwgtavg,[12 7]);   %15x7
perc_contribution_PCwgtavg_FOI_ROI = reshape(perc_contribution_PCwgtavg,[4 12]);   %15x7
perc_contribution_PCwgtavg_FOI_ROI2 = permute(perc_contribution_PCwgtavg_FOI_ROI,[2 1]);   %7x15

perc_contribution_PCwgtavg_FOI_ROI_flip = flipud(reshape(perc_contribution_PCwgtavg,[4 12]));   %15x7

figure; hold on
imagesc(perc_contribution_PCwgtavg_FOI_ROI_flip);
c=colorbar;
ylabel(c,['PCA contribution (%)'],'fontsize',14);
c.FontSize = 12;
colormap jet(256);
ylabel('Trials','fontsize',14);
xlabel('Metrics','fontsize',14);
% regions = {'Trial 1','Left sensorimotor','Left parietal','Left occipital','Left temporal','Left cerebellum','Right frontal','Right sensorimotor','Right parietal','Right occipital','Right temporal','Right cerebellum'};
% freqbands = {'Delta (1-3 Hz)','Theta (4-8 Hz)','Alpha (8-12 Hz)','Beta (13-29 Hz)','LGm (30-50 Hz)','MidGm (50-70 Hz)','BBGm (70-170 Hz)'};

regions = {'Pre-Stim','Early Stim','Late Stim','Post Stim'};
freqbands = {'RT','HPL','VelA','VelM','VelP','VelTtM','VelTtMN','AccelA','AccelM','Accur','NJ','IOC'};
% freqbands = {'Pre-Stim','Early Stim','Late Stim','Post Stim'};
% regions = {'RT','HPL','VelA','VelM','VelP','VelTtM','VelTtMN','AccelA','AccelM','Accur','NJ','IOC'};

set(gca,'XTick',1:12,'YTickLabel',fliplr(regions),'fontsize',12,'TickLabelInterpreter','none');
set(gca,'YTick',1:4,'XTickLabel',freqbands,'fontsize',8,'TickLabelInterpreter','none');
title(['Percent contribution to PCA'],'fontsize',14);

% set(gcf,'color','w');            
% set(gcf, 'Position', get(0,'Screensize'));


% threshold clim to estimated average contribution (remove majority red)
figure; hold on
imagesc(perc_contribution_PCwgtavg_FOI_ROI_flip,[100/X c.Limits(2)]);
c=colorbar;
ylabel(c,['PCA contribution (%)'],'fontsize',14);
c.FontSize = 12;
colormap jet(256);
ylabel('Brain regions','fontsize',14);
xlabel('Frequency band','fontsize',14);
% regions = {'Pre-Stim','Early Stim','Late Stim','Post Stim'};
% freqbands = {'RT','HPL','VelA','VelM','VelP','VelTtM','VelTtMN','AccelA','AccelM','Accur','NJ','IOC'};
% set(gca,'YTick',1:4,'YTickLabel',fliplr(regions),'fontsize',12,'TickLabelInterpreter','none');
% set(gca,'XTick',1:12,'XTickLabel',freqbands,'fontsize',8,'TickLabelInterpreter','none');
set(gca,'XTick',1:12,'YTickLabel',fliplr(regions),'fontsize',12,'TickLabelInterpreter','none');
set(gca,'YTick',1:4,'XTickLabel',freqbands,'fontsize',8,'TickLabelInterpreter','none');

title(['Percent contribution to PCA'],'fontsize',14);

% set(gcf,'color','w');            
% set(gcf, 'Position', get(0,'Screensize'));

clear abs* coeff cumulative cumulative_var C* Cx* data* eigenvalue Eig* latent latent_sz pc perc* proportion score table_eigenanalysis var* X zdata

metric_pca_all_01(:,1)=metric_pca_all(:,1);
metric_pca_all_01(:,2)=metric_pca_all(:,5);
metric_pca_all_01(:,3)=metric_pca_all(:,9);
metric_pca_all_01(:,4)=metric_pca_all(:,13);
metric_pca_all_01(:,5)=metric_pca_all(:,17);
metric_pca_all_01(:,6)=metric_pca_all(:,21);
metric_pca_all_01(:,7)=metric_pca_all(:,25);
metric_pca_all_01(:,8)=metric_pca_all(:,29);
metric_pca_all_01(:,9)=metric_pca_all(:,33);
metric_pca_all_01(:,10)=metric_pca_all(:,37);
metric_pca_all_01(:,11)=metric_pca_all(:,41);
metric_pca_all_01(:,12)=metric_pca_all(:,45);

metric_pca_all_01(:,13)=metric_pca_all(:,2);
metric_pca_all_01(:,14)=metric_pca_all(:,6);
metric_pca_all_01(:,15)=metric_pca_all(:,10);
metric_pca_all_01(:,16)=metric_pca_all(:,14);
metric_pca_all_01(:,17)=metric_pca_all(:,18);
metric_pca_all_01(:,18)=metric_pca_all(:,22);
metric_pca_all_01(:,19)=metric_pca_all(:,26);
metric_pca_all_01(:,20)=metric_pca_all(:,30);
metric_pca_all_01(:,21)=metric_pca_all(:,34);
metric_pca_all_01(:,22)=metric_pca_all(:,38);
metric_pca_all_01(:,23)=metric_pca_all(:,42);
metric_pca_all_01(:,24)=metric_pca_all(:,46);

metric_pca_all_01(:,25)=metric_pca_all(:,3);
metric_pca_all_01(:,26)=metric_pca_all(:,7);
metric_pca_all_01(:,27)=metric_pca_all(:,11);
metric_pca_all_01(:,28)=metric_pca_all(:,15);
metric_pca_all_01(:,29)=metric_pca_all(:,19);
metric_pca_all_01(:,30)=metric_pca_all(:,23);
metric_pca_all_01(:,31)=metric_pca_all(:,27);
metric_pca_all_01(:,32)=metric_pca_all(:,31);
metric_pca_all_01(:,33)=metric_pca_all(:,35);
metric_pca_all_01(:,34)=metric_pca_all(:,39);
metric_pca_all_01(:,35)=metric_pca_all(:,43);
metric_pca_all_01(:,36)=metric_pca_all(:,47);

metric_pca_all_01(:,37)=metric_pca_all(:,4);
metric_pca_all_01(:,38)=metric_pca_all(:,8);
metric_pca_all_01(:,39)=metric_pca_all(:,12);
metric_pca_all_01(:,40)=metric_pca_all(:,16);
metric_pca_all_01(:,41)=metric_pca_all(:,20);
metric_pca_all_01(:,42)=metric_pca_all(:,24);
metric_pca_all_01(:,43)=metric_pca_all(:,28);
metric_pca_all_01(:,44)=metric_pca_all(:,32);
metric_pca_all_01(:,45)=metric_pca_all(:,36);
metric_pca_all_01(:,46)=metric_pca_all(:,40);
metric_pca_all_01(:,47)=metric_pca_all(:,44);
metric_pca_all_01(:,48)=metric_pca_all(:,48);





clear a
a=kmo(metric_pca_all(:,[1:32 37:48]))


for i=1:48
    eval(['[idx',num2str(i),',C,sumd',num2str(i),']=kmeans(metric_pca_all(1:10,',num2str(i),'),2)'])
end






































