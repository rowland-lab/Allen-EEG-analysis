function [Mrm1,Mrm2]=mixANOVA(input,b)

% Run Mixed Anova for contra
[~,rm]=simple_mixed_anova(vertcat(input{:}),vertcat(ones(size(input{1},1),1)*0,ones(size(input{2},1),1)*2),{'Trial'},{'Stim'});

% Compare stim vs sham
Mrm1 = multcompare(rm,'Stim','By','Trial','ComparisonType','tukey-kramer');
assignin('base','Mrm1',Mrm1)

if any(Mrm1.pValue<=0.05)
    sigidx=double(unique(Mrm1.Trial(find(Mrm1.pValue<=0.05))));
    Ylimits=get(gca,'YLim');
    for i=1:numel(sigidx)
        text(b(1).XData(sigidx(i))-0.8,Ylimits(2)*0.8,num2str(unique(Mrm1.pValue(double(Mrm1.Trial)==sigidx(i)))),'FontSize',9,'HorizontalAlignment','center','Rotation',90)
    end
end

barpos(:,1)=b(1).XData;
barpos(:,2)=b(2).XData;

% Compare time points
Mrm2 = multcompare(rm,'Trial','By','Stim','ComparisonType','bonferroni');
if any(Mrm2.pValue<=0.05)
    idx=find(Mrm2.pValue<=0.05);
    for i=1:numel(idx)
        t1=double(Mrm2.Trial_1(idx(i)));
        t2=double(Mrm2.Trial_2(idx(i)));
        pval=Mrm2.pValue(idx(i));
        if t1<t2
            if double(Mrm2.Stim(idx(i)))==1
                sigpos=barpos(:,1);
            else
                sigpos=barpos(:,2);
            end
            Ylimits=get(gca,'YLim');
            nYlimits=[Ylimits(1) Ylimits(2)+0.1*Ylimits(2)];
            set(gca,'YLim',nYlimits)
            l=line(gca,[sigpos(t1) sigpos(t2)],[1 1]*Ylimits(2));
            text(gca,mean([sigpos(t1) sigpos(t2)]),Ylimits(2),num2str(pval),'FontSize',9,'HorizontalAlignment','center');
            if double(Mrm2.Stim(idx(i)))==1
                set(l,'linewidth',2,'Color','b')
            else
                set(l,'linewidth',2,'Color',[0.8500 0.3250 0.0980])
            end
        end
    end
end

end
