clc;
clear;
data = 'C:\Users\User\Desktop\AAAA\SM\'; %ָ�������������ڵ��ļ���
filelist = dir([data,'*.tif']);       %�г���������ָ�����͵��ļ�

k = length(filelist);

for i = 1:k  %���ζ�ȡ������
    
    %% ������ȡ�ļ�
    ncFilePath = ['C:\Users\User\Desktop\AAAA\SM\',filelist(i).name]; %�趨�ļ�·��
    oldname = filelist(i).name;
    name1 = filelist(i).name(1:2); %��ȡ�����ֶ�
    name2 = filelist(i).name(77:91);
    a = num2str(name1);%תΪ�ַ���  
    b = num2str(name2);%תΪ�ַ���  
    newname = strcat(a,b);
    copyfile([data oldname],['C:\Users\User\Desktop\renam\output\2010\' newname]);%���Ƶ��ļ�����
end

disp('over!')
