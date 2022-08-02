


%But first.. Who are all my subjects and where is my file path?
%This section will depend on how your data are stored. The following
%assumes there is a "mother" filepath and that my data are stored in
%sub-folders depending on what stage of processing they are in.


path_data = 'C:\Users\danie\OneDrive - Oklahoma A and M System\LEAP\ALE\EEG\'; %Mother folder and in the processing script subfolders are added using the function "strcat"

subjects = {'001', '002', '003', '004', '005', '006', '007', '008', '009', '010',... %These should be your data file names. In the script below, their data types are identified - see line 31 for example.
            '012', '013', '014', '015', '016', '017', '018', '021', '022', '023',...
            '025', '026', '027', '029', '031', '032', '033', '035', '036', '037',...
            '038', '040', '041', '042', '043', '044', '045', '047', '048', '049',...
            '050', '051', '052', '053', '054', '055', '056', '057', '058', '059',...
            '060', '061', '062', '063', '064', '065', '066', '067', '068', '069',...
            '070', '071', '072', '073', '074', '075', '076'};

% Now let's do some work! %
% This script completes many jobs: Importing data, re-referencing to
% mastoids, identify channel locs, high/low pass filter, and 60 hz notch
% filter. Then saving for continued processing


for i=1:length(subjects) %Process for the length of the subject list
    
    datapath = path_data; %Create a variable that is the mother file path. Equivalent to 'C:\Users....' above.
    dataset = subjects{i}; %Create a variable that is the name of the current data set, so the first loop of this script, dataset = '001'.
    


     EEG = pop_biosig(strcat(datapath, '\1 Raw\', dataset, '.ALE.bdf') , 'channels',[1:37] ,'ref',33); %Import a biosemi dataset from subpath by calling on my variable "datapath" and adding the subfolder name. Your "dataset" variable is the current dataset. You will need to add any other filepath names (eg .ALE) and you will need to add ".bdf" as I have here. You can remove the "Channels" command if you want to import all channels. I did not want the heart rate and extra physio in the data. You also do not need to include the reference here (channel 33), but make sure you identify it immediately after import using Chan operations.
     EEG.setname=dataset; % This simply names your data as you have to after import. I am calling mine the subject number using the variable "dataset" % In the next line, I am re-referencing to the average of the 2 mastoids. Make sure your channels are labeled.
     EEG = pop_eegchanoperator( EEG, {  'nch1 = ch1 - ( (34)/2 ) Label FP1',  'nch2 = ch2 - ( (34)/2 ) Label AF3',  'nch3 = ch3 - ( (34)/2 ) Label F7',  'nch4 = ch4 - ( (34)/2 ) Label F3', ...
         'nch5 = ch5 - ( (34)/2 ) Label FC1',  'nch6 = ch6 - ( (34)/2 ) Label FC5',  'nch7 = ch7 - ( (34)/2 ) Label T7',  'nch8 = ch8 - ( (34)/2 ) Label C3', 'nch9 = ch9 - ( (34)/2 ) Label CP1', ...
         'nch10 = ch10 - ( (34)/2 ) Label CP5',  'nch11 = ch11 - ( (34)/2 ) Label P7',  'nch12 = ch12 - ( (34)/2 ) Label P3',  'nch13 = ch13 - ( (34)/2 ) Label PZ', ...
         'nch14 = ch14 - ( (34)/2 ) Label PO3',  'nch15 = ch15 - ( (34)/2 ) Label O1',  'nch16 = ch16 - ( (34)/2 ) Label OZ',  'nch17 = ch17 - ( (34)/2 ) Label O2', ...
         'nch18 = ch18 - ( (34)/2 ) Label PO4',  'nch19 = ch19 - ( (34)/2 ) Label P4',  'nch20 = ch20 - ( (34)/2 ) Label P8',  'nch21 = ch21 - ( (34)/2 ) Label CP6',...
         'nch22 = ch22 - ( (34)/2 ) Label CP2',  'nch23 = ch23 - ( (34)/2 ) Label C4',  'nch24 = ch24 - ( (34)/2 ) Label T8',  'nch25 = ch25 - ( (34)/2 ) Label FC6', ...
         'nch26 = ch26 - ( (34)/2 ) Label FC2',  'nch27 = ch27 - ( (34)/2 ) Label F4',  'nch28 = ch28 - ( (34)/2 ) Label F8',  'nch29 = ch29 - ( (34)/2 ) Label AF4', ...
         'nch30 = ch30 - ( (34)/2 ) Label FP2',  'nch31 = ch31 - ( (34)/2 ) Label FZ',  'nch32 = ch32 - ( (34)/2 ) Label CZ',  'nch33 = ch33 Label M1',  'nch34 = ch34 Label M2',...
         'nch35 = ch35 Label SO1',  'nch36 = ch36 Label LO1',  'nch37 = ch37 Label LO2'} , 'ErrorMsg', 'popup', 'Warning', 'on' ); % Re-reference to the average of the mastoids - this may vary based on online reference and whether you choose for an average reference
     EEG =pop_chanedit(EEG, 'lookup','C:\\Users\\danie\\OneDrive\\Documents\\MATLAB\\eeglab2021.0\\plugins\\dipfit\\standard_BESA\\standard-10-5-cap385.elp','changefield',{33,'labels','M1'},'changefield',{34,'labels','M2'},'changefield',{35,'labels','SO1'},'changefield',{36,'labels','LO1'},'changefield',{37,'labels','LO2'},'lookup','C:\\Users\\danie\\OneDrive\\Documents\\MATLAB\\eeglab2021.0\\plugins\\dipfit\\standard_BESA\\standard-10-5-cap385.elp'); % Here I am importing channel locations using standard cap. The filepath will change depending on where your plugins are stored.
     EEG = pop_basicfilter( EEG,  1:32 , 'Boundary', 'boundary', 'Cutoff', [ 0.01 30], 'Design', 'butter', 'Filter', 'bandpass', 'Order',  2, 'RemoveDC', 'on' ); % Run a high and low pass filter on the data [.1,30] could be adjusted if you want a lower or higher end. Make sure you only run it on the EEG (1:32 in this case). Ideally RUNICA on .1 or 1 HZ filter and copy those ICA weights to .01 HZ data
     EEG = pop_basicfilter( EEG,  1:32 , 'Boundary', 'boundary', 'Cutoff',  60, 'Design', 'notch', 'Filter', 'PMnotch', 'Order',  180, 'RemoveDC', 'on' ); % Run a 60 Hz notch filter on the data. If you have other expected contamination of the data at a particular frequency you could run this again for that frequency. Make sure you only run it on the EEG (1:32 in this case)
     EEG = pop_saveset( EEG, 'filename',[dataset, '.ALE', '.set'],'filepath', strcat(datapath, '2 Filtering')); %Save the data. Name the data, its ID number using variable "dataset" add a tag to the end with my study name ".ALE" << Not a necessary step. MAKE SURE YOU INCLUDE filetype though >> ".set" Then put it in the subfolder "2 Filtering" which is located in Motherfolder "datapath"
     
     
     
     
end %When data is processed through the number of subjects end the script.

%Next you will want to RUNICA to identify occular or other artifact.
%You can also choose to remove and interpolate channels - make sure you
%have chan locs before doing so.
%Then run the PostICA script to create an event list, epoch and bin,
%complete artifact detection and average a subject level ERP.

%Make sure to visualize your data along the way and view a grand average
%before exporting measurements.
     
