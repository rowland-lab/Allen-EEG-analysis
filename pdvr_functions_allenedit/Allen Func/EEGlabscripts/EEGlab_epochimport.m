function [EEG]=EEGlab_epochimport(s4_mat,EEG)

    import=open(s4_mat);

    ft_vrdat=import.ft_vrdat;
    ft_sessioninfo=import.ft_sessioninfo;
    ft_epochs=import.ft_epochs;

    fn=fieldnames(ft_epochs.vrevents);
    trials=extractAfter(fn,'t');


    for t=1:numel(trials)
        wk=ft_epochs.vrevents.(fn{t});

        el_hold{t,1}=[wk.atStartPosition.val(:,1) 1*ones(size(wk.atStartPosition.val,1),1)+t*10];
        el_prep{t,1}=[wk.cueEvent.val(:,1) 2*ones(size(wk.cueEvent.val,1),1)+t*10];
        el_move{t,1}=[wk.targetUp.val(:,1) 3*ones(size(wk.targetUp.val,1),1)+t*10];
    end

    el_epochs=sortrows(cell2mat([el_hold; el_prep; el_move]),1);

    insertdat=zeros(1,size(EEG.data,2));

    for i=1:size(el_epochs,1)
        time=round(el_epochs(i,1));
        tag=el_epochs(i,2);
        insertdat(1,time)=tag;
    end

    EEG.data(46,:)=insertdat;
    EEG.sessioninfo=ft_sessioninfo;
    
    disp(['Inserting ',num2str(size(el_epochs,1)),' events in'])
end