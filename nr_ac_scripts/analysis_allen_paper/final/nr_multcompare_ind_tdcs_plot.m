function mc=nr_multcompare_ind_tdcs_plot(stats,ylim_min)

%some change
%subplot(8,5,5)22
mc=multcompare(stats,'display','off','ctype','bonferroni')

ylim=get(gca,'ylim');
ylim_new=set(gca,'ylim',[ylim_min ylim(2)*2]);

if size(mc,1)==6
    for i=1:6
        if mc(1,6)<0.05
            text(1.9,ylim(2)+0.1*ylim(2),'*','Color',[1 0 0])
        else
            text(1.9,ylim(2)+0.1*ylim(2),'-')
        end

        if mc(2,6)<0.05
            text(2.9,ylim(2)+0.1*ylim(2),'*','Color',[1 0 0])
        else
            text(2.9,ylim(2)+0.1*ylim(2),'-')
        end

        if mc(3,6)<0.05
            text(3.9,ylim(2)+0.1*ylim(2),'*','Color',[1 0 0])
        else
            text(3.9,ylim(2)+0.1*ylim(2),'-')
        end

        if mc(4,6)<0.05
            text(2.9,ylim(2)+0.5*ylim(2),'*','Color',[1 0 0])
        else
            text(2.9,ylim(2)+0.5*ylim(2),'-')
        end

        if mc(5,6)<0.05
            text(3.9,ylim(2)+0.5*ylim(2),'*','Color',[1 0 0])
        else
            text(3.9,ylim(2)+0.5*ylim(2),'-')
        end

        if mc(6,6)<0.05
            text(3.9,ylim(2)+0.8*ylim(2),'*','Color',[1 0 0])
        else
            text(3.9,ylim(2)+0.8*ylim(2),'-')
        end
    end
elseif size(mc,1)==3
    for i=1:3
        if mc(1,6)<0.05
            text(1.9,ylim(2)+0.1*ylim(2),'*','Color',[1 0 0])
        else
            text(1.9,ylim(2)+0.1*ylim(2),'-')
        end

        if mc(2,6)<0.05
            text(2.9,ylim(2)+0.1*ylim(2),'*','Color',[1 0 0])
        else
            text(2.9,ylim(2)+0.1*ylim(2),'-')
        end

        if mc(3,6)<0.05
            text(2.9,ylim(2)+0.5*ylim(2),'*','Color',[1 0 0])
        else
            text(2.9,ylim(2)+0.5*ylim(2),'-')
        end
    end
end