clc
clear
% nc文件根路径
%filepath='C:\Users\User\Desktop\test\';
% 输出txt根路径
%txt='C:\Users\User\Desktop\test\';
% 获取该文件夹下所有nc文
%list=dir(strcat(filepath,'*.nc'));

%% 批读取NC文件的准备工作
datadir = 'C:\Users\User\Desktop\result\'; %指定批量数据所在的文件夹
filelist = dir([datadir,'*.nc']);       %列出所有满足指定类型的文件

k=length(filelist);

for i = 1:k  %依次读取并处理
    
    %% 批量读取NC文件
    ncFilePath = ['C:\Users\User\Desktop\result\',filelist(i).name]; %设定NC路径
    num = filelist(i).name(27:32); %读取数据编号，以便于保存时以此编号储存
      
    %% 读取变量值
    lon=ncread(ncFilePath,'lon'); %读取经度
    lat=ncread(ncFilePath,'lat'); %读取维度
    var=ncread(ncFilePath,'SM');%获取sm变量数据
    a = find(lon >= 70 & lon <= 130);
    b = find(lat >= 25 & lat <= 55);     
    lon_num = length(a);
    lat_num = length(b);
    sm = ncread(ncFilePath,'SM',[a(1) b(1) 1 ],[lon_num lat_num 1]); 
    z = sm.';%转置
    c = reshape(z,[],1);
    dlmwrite(['C:\Users\User\Desktop\result\',num,'.csv'],c,'\t');
    
end
disp('finish!')
