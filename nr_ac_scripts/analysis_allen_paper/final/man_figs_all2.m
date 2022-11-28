



go over rest of one notes for allen


%questions for allen
%we should maybe plot the acceleration curves next to the line plot and
%show how the two groups differ





%2022_08_13
%positive/interesting figures
lin reg
alpha avg velocity/max acceleration/max velocity/movement durationpos prep
alpha intra5 prep reaction time/accuracy
beta reach handpath length pos/avg accel intra 5
delta movement duration hold, i5 reach
theta movement duration reach, pre, handpathlength i15 prep


gamma max accel, avg accel reach intra5

%%mat
%     visually for the mat coh's, I don't see an overall effect of the stimulation for healthy or stroke
%     best examples healthy 25 alpha HOWEVER it does look like healthy's have lower alpha coh than stroke(?)
%     find out if lin reg is c3c4 only
%     
%     42 beta good example of nothing happending during stim
%     43 beta hold/prep MUCH lower than reach
%     
%     gamma mixed anova stroke hold intra5?? i don't think this applies
%     anymore, please check
%     btw 30 can be removed and rerun stats

couple of interesting theta mixed anova results, same with diff
    
        
    %%mat diff
%     sbj 5 has noticeable decrease in alpha during stim, 24 has increase(?)
%     22,26,43 beta decreased (see if these are still true with the colormap turn off then
%     can turn it back on
% 
%     gamma mean diffs look completely different between stroke and healthy
%     (again just confirm)
% delta
theta
%     alpha - not much there
%     beta - literally nothing!
%     gamma - friedman - stroke sham and stim look almost opposites for hold-prep!!
%     mixed anova - increased over healthy at i15 for prep-reach but this
%     might go away if you remove 30



%9/24/22
%power doesn't show much difference after removing ica but there is a
%broadband beta-gamma increase in power for hc only that you don't see in
%stim, delta, theta as well

final list
beta desync/resync - consider subtracting the trials to generate reactivity data (WAIIITTTTTTT!! YOUVE ALREADY DONE
THIS WITH YOUR COH DIFF!!!
%then go all the way back and repeat for flex-ex and imaginary movement
%need to look at post10 and post15
% you will need topoplots (eeglab) and spectrograms (fieldtrip),
% coherograms
%you will need claudia's figure of mri's and she needs to make a table

%if the question comes up about how to filter the eeg based on beta power
%you should look at the functions nr_eeg_anal_05_replot_data_orig,
%nr_eeg_anal_06_epochs_new and nr_eeg_anal_07_psd_stats_new. I am going to
%put them in the prelim folder for now but they look like pretty powerful
%functions and might even provide a methods figure if you need it
%also try bandpass filtering for just beta - you should do this and look at
%raw data 

%%%%Just thought of a great idea, just simply plot the accelerometer
%%%%signals during flexion and extension!!!!!!

% 7) try z-scoring, common average referencing

% don't forget to analyze control experiments
% 1) person at rest no blinking
% 2) person blinking at regular interval
% 3) move cords, stand up
% 4) imaginary movement

%make sure the number of rejected trials did not differ between groups
also make sure each phase h,p,m have same number of rejections
%4 at some point, will need to check all these with at least two
%normalization schemes - % and z-scoring

to be able to look at individual reach metrics, have to use latest version of s2metric plot


this sounds like a second paper
things to include in paper
tractography
ROAST
CONN
FMA 
MRI structural
reconstructions

questions for future study
5 things that could potentially get changed by tdcs
accuracy
speed
path
strength (grip?)
fine motor skills

include oculogram next time?
btw, need lots more repetititions next time 50 to 100

% see if velocity curves correlate with FMA scores
