function mc=nr_multcompare_ind_tdcs_plot2(stats,p,ylim_min)

%some change
%subplot(8,5,5)22
mc=multcompare(stats,'display','off','ctype','tukey-kramer')

ylim=get(gca,'ylim')
ylim_new=set(gca,'ylim',[ylim_min ylim(2)*2])
xlim_new=get(gca,'xlim')

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
if p<0.05
    h=text(xlim_new(2),ylim_min,num2str(p),'FontSize',9,'Color',[1 0 0]); set(h,'Rotation',90)
else
    h=text(xlim_new(2),ylim_min,num2str(p),'FontSize',9); set(h,'Rotation',90)
end