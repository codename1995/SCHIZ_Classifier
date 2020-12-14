function ID = genSubjectID()

ID = cell(70,1);

for i = 1:30 
    ID{i} = ['CTRL', num2str(1000+i)];
end

for i = 31:70
    idx = i - 30;
    ID{i} = ['SCHIZ', num2str(1000+idx)];
end

end