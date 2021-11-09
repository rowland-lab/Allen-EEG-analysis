%% Notes

% Requires correct folder structure

%%% Protocol folder
%%%% Subject folder
%%%%% vr folder --> contain contents from VR machine output
%%%%% edf folder --> contains edf file ('subjectnumber'.edf)

% Channel Reference
% {'Fp1' }
% {'F7'  }
% {'T3'  }
% {'T5'  }
% {'O1'  } 5
% {'F3'  }
% {'C3'  } 7
% {'P3'  }
% {'A1'  }
% {'Fz'  } 10
% {'Cz'  }
% {'Fp2' }
% {'F8'  }
% {'T4'  }
% {'T6'  }
% {'O2'  }
% {'F4'  }
% {'C4'  } 18
% {'P4'  }
% {'A2'  }20
% {'Fpz' }
% {'Pz'  }
% {'X1'  }23 [EKG]
% {'X2'  }
% {'X3'  }25
% {'X4'  }
% {'X5'  }
% {'X6'  }
% {'X7'  }
% {'X8'  }30
% {'X9'  }
% {'X10' }
% {'X11' }
% {'X12' }
% {'X13' }35
% {'X14' }
% {'X15' }
% {'X16' }
% {'X17' }
% {'X18' }40
% {'DC1' } 41- VR
% {'DC2' } 42- VR
% {'DC3' } 43- tDCS
% {'DC4' } 44- tDCS
% {'OSAT'}
% {'PR'  }

%% Input
clear all
close all
clc

% Enter gitpath
gitpath='C:\Users\allen\Documents\GitHub\Allen-EEG-analysis';
cd(gitpath)

% Enter in protocol folder
protocolfolder='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153';

% Add EEG related paths
allengit_genpaths(gitpath,'EEG')

% Detect subjects
sbj=dir(fullfile(protocolfolder,'pro000*'));
sbj={sbj.name}';

%% Run code

% Preproc --> S1_VR_trial_preproc(sbjnum,protocolfolder,manual)
clear manual status
parfor i=1:numel(sbj)
    try
        S1_VR_trial_preproc(sbj{i},protocolfolder,false)
    catch ME
        manual{i}=i;
        status{i}.message=ME.message; 
        status{i}.stack=ME.stack;
    end
end

for i=cell2mat(manual);
     S1_VR_trial_preproc(sbj{i},protocolfolder,true)
end


for i=5
    % Metric Plots --> S2_MetricPlot (sbjnum,protocolfolder,threshold[seconds])
    S2_MetricPlot(sbj{i},protocolfolder,2)
    
    % EEG Analysis --> S3_EEGanalysis(sbjnum,protocolfolder,window,nooverlap,nfft,manual)
    S3_EEGanalysis(sbj{i},protocolfolder,128,0.5,128,false)
end

% Reconstruction --> S4_Reconstruction(subjectName,protocol_folder,positionalplot,eegplot,tfplot,metricplot,metriccurves,trial_num)
for i=4:numel(sbj)
%     S4_Reconstruction(sbj{i},protocolfolder,false,false,false,false,false,[])
%     S4_Reconstruction(sbj{i},protocolfolder,false,true,false,false,false,[])
    S4_Reconstruction(sbj{i},protocolfolder,true,true,true,false,false,[])
end

