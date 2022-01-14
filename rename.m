clc;
clear;
data = 'C:\Users\User\Desktop\AAAA\SM\'; %指定批量数据所在的文件夹
filelist = dir([data,'*.tif']);       %列出所有满足指定类型的文件

k = length(filelist);

for i = 1:k  %依次读取并处理
    
    %% 批量读取文件
    ncFilePath = ['C:\Users\User\Desktop\AAAA\SM\',filelist(i).name]; %设定文件路径
    oldname = filelist(i).name;
    name1 = filelist(i).name(1:2); %截取所需字段
    name2 = filelist(i).name(77:91);
    a = num2str(name1);%转为字符串  
    b = num2str(name2);%转为字符串  
    newname = strcat(a,b);
    copyfile([data oldname],['C:\Users\User\Desktop\renam\output\2010\' newname]);%复制到文件夹中
end

disp('over!')
