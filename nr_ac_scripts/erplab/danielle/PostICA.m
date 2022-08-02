

%First.. Who are all my subjects and where is my file path?

path_data = 'C:\Users\danie\OneDrive - Oklahoma A and M System\LEAP\ALE\EEG\';

subjects = {'001', '002', '003', '004', '005', '006', '007', '008', '009', '010', ...
            '012', '013', '014', '054', '015', '016', '017', '018', '021',  '023', ...
            '025', '026', '027', '029', '031',  '032', '033', '035',  '036','037',...
            '038', '040', '041', '043', ' 044', '045','047', '048', '049', '050', ...
            '051', '052', '053', '055', '056', '057', '058', '059', '060', '061', ...
            '062', '063', '064', '065', '066', '067', '068', '069', '070', '071',...
            '072', '073', '074', '075', '076' };



% Now let's do some work! %
% This script completes many jobs.
%1)create new BI heog and veog, create event
%list, assign bins, epoch, use moving window, blink, flat line, and step AR routines for these
%artifacts occuring within a trial and save as.
%2)Get an AD Summary to make sure you have enough trials and run ERP
%averager
%3) use bin operator and save ERP


for i=1:length(subjects)
    
    datapath = path_data;
    dataset = subjects{i};
    
    EEG = pop_loadset('filename',[dataset, '.ALE', '.set'],'filepath', strcat(datapath, '4 ICA Pruned')); %% Load in the ICA pruned file
    EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist', strcat(datapath, 'Exported ELs\', dataset, '.txt')); % extract events from the EEG and save as a text event list
    EEG  = pop_binlister( EEG , 'BDF', strcat(datapath, 'BDF\', 'ALE_bdf.txt'), 'IndexEL',  1, 'SendEL2', 'EEG', 'UpdateEEG', 'on', 'Voutput', 'EEG' ); % load your bin descriptor file (BDF)
    EEG = pop_epochbin( EEG , [-400.0  6100.0],  [ -200 0]); %create epochs in the EEG based off of your BDF
    EEG = pop_eegchanoperator( EEG, {  'ch38 = ch36-ch37 label biHEOG',  'ch39 = 35 - ((ch1+ch30)/2) label biVEOG'} ,  'Warning', 'off' ); % If running additional artifact detection routines based on EOG, create bipolar VEOG and HEOG channels
    EEG  = pop_artblink( EEG , 'Blinkwidth',  400, 'Channel', 39, 'Crosscov',  0.85, 'Flag',  1, 'Twindow', [ -200 500] );   % Run AD routine for blink detection within a certain time frame of pertinent stimulus   
    EEG  = pop_artstep( EEG , 'Channel',  38, 'Flag',  1, 'Threshold',  450, 'Twindow', [ -200 500], 'Windowsize',  400, 'Windowstep',  200 ); % Run AD routine for saccade detection within a certain time frame of pertinent stimulus  
    EEG  = pop_artmwppth( EEG , 'Channel', 1:32, 'Flag',  1, 'Threshold',  200, 'Twindow', [ -200 6000], 'Windowsize',  100, 'Windowstep',  50 ); % Run AD routine to detect channels with excessively large changes in amplitude
    EEG  = pop_artflatline( EEG , 'Channel', 1:32, 'Duration',  500, 'Flag',  1, 'Threshold', [ -0.5 0.5], 'Twindow', [ -398.4 6097.7] ); % Run AD routine to detect channels that flatline for a certain duration of time - here 500 ms
    EEG = pop_saveset( EEG, 'filename',[dataset, '.ALE', '.set'],'filepath', strcat(datapath, '7 AD')); % Save data in epochs that have been flagged or not as artifacted
    EEG = pop_summary_AR_eeg_detection(EEG, [datapath, '\AD Summaries', dataset,  '.txt']); %Save a text file with % bins marked as artifact (in total and broken down by bin
    EEG = pop_loadset('filename', [dataset '.ALE.set'],'filepath', strcat(datapath, '7 AD')); %load the epoched data
    ERP = pop_averager( EEG , 'Criterion', 'good', 'DSindex',1, 'ExcludeBoundary', 'on', 'SEM', 'on' ); %average epochs into ERPs
    ERP = pop_binoperator( ERP, {  'b7 = wavgbin(1:3) label PicOnset',... % if averaged bins/not at the zero order level are needed, then use bin operator
     'b8 = wavgbin(4:6) label ViewChange',...
     'b9 = wavgbin(2:3) label ThreatOnset',...
     'b10 = wavgbin(5:6) label ThreatViewChange'});
    ERP = pop_savemyerp(ERP, 'erpname', dataset, 'filename', [dataset, '.pic', '.erp'], 'filepath', strcat(datapath, '8 ERP')); %Save the ERP. 
   
 
    
end


%Done with this script? 
%You are not Done-done yet. Double check N & % ERPS for each sub after AR.
%Grand average ERP to visualize effects and make sure all is well.  % % for
%grand average Create a grouplist (.txt consisting of file path for each
%ERP) then use ERPLAB to create grand average. Double check scalp
%topography and check ERP waveform/baseline, etc.
%THEN Export either average scores (using ERP measurements) from ERPLAB 
%Or continuous epochs for use in JMP or other analysis software

% complete  



%