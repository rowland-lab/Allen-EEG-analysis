function error=find_error(input,dim)

if dim==2
    input=input';
end
    

for i=1:size(input,2)
    temp=input(:,i);
    error(i)=std(temp,'omitnan')/sqrt(sum(~isnan(temp)));
end

end
    
    

