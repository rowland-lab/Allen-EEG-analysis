for i=1:12
%mean_temp(i)=man(epochs.vrevents.t1.atStartPosition.psd.saw(5:8,7,i))
mean_temp_atStartPosition(i)=mean(log10(epochs.vrevents.t1.atStartPosition.psd.saw(5:8,7,i)));
end
mean_atStartPosition=mean(mean_temp_atStartPosition)

for i=1:12
mean_temp_cueEvent(i)=mean(log10(epochs.vrevents.t1.cueEvent.psd.saw(5:8,7,i)))
end
mean_cueEvent=mean(mean_temp_cueEvent)

for i=1:12
    
mean_temp_targetUp(i)=mean(log10(epochs.vrevents.t1.targetUp.psd.saw(5:8,7,i)))
end
mean_targetUp=mean(mean_temp_targetUp)
  
27 557 737 489

%Questions for Allen
for the first several subjects the subject # in the trialinformation.xml file may be off bc the first subject was a test subject (Taylor)
S1 - fig1 - start before first VR deflection
fig 2 - replace Fp1 with 'EEG'
%is the question being asked to select start of VR session or tDCS session?
%what exactly is the signal being displayed?
%next what is fp1?
%for start/end blue text/arrows are these in notes? where are these saved?
those are EEG notes being saved in the EEG machine (sometimes us, sometimes tech) - saved in edf filew
%15 i had to manually select 4th one in???? this is why I don't understand
seems to be fixed in the new script??
%the diff between the 1st plot and the 3rd plot???
% why does getArryEditorBrushCache come up when you look at
% 'preprocessed_vr' variable?
maybe from too many toolboxes?

exit
%S2-metrics
% is trialData.sessioninfo same as preprocessed? 
yes
% what is movement start? can we see that somewhere else?
the exact time they began the reach

%S3 
%atStartPosition different than S1? which epochs should I use?
%would epoch-based video reconstruction help us?
%based on fig, how would you know if correctly epoched or not?

%where do the beta values on the spreadsheet come from? whole?

need to be able to go back and match specific atstartpositions with specific times shown in variable

%no trial 3 in sbj17??

for 42 use vr_chan=40;