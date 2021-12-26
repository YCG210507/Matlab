clc;
clear;
%% 批读取NC文件的准备工作
datadir = 'C:\Users\User\Desktop\CCI\2017\'; %指定批量数据所在的文件夹
filelist = dir([datadir,'*.nc']);       %列出所有满足指定类型的文件

k=length(filelist);

for i = 1:k  %依次读取并处理
    
    %% 批量读取NC文件
    ncFilePath = ['C:\Users\User\Desktop\CCI\2017\',filelist(i).name]; %设定NC路径
    num = filelist(i).name(39:46); %读取数据编号，以便于保存时以此编号储存
      
    %% 读取变量值
    lon = ncread(ncFilePath,'lon');%读取经度变量
    lat = ncread(ncFilePath,'lat');%读取纬度变量
    sm = ncread(ncFilePath,'sm');%读取变量值
    a = find(lon >= 70 & lon <= 125);
    b = find(lat >= 25 & lat <= 55);     
    lon_num = length(a);
    lat_num = length(b);
    sm = ncread(ncFilePath,'sm',[a(1) b(1) 1],[lon_num lat_num 1] ); 
    z = sm.';%转置
    c = reshape(z,[],1);
    dlmwrite(['C:\Users\User\Desktop\CCI\2017\',num,'.csv'],c,'\t');
    
end
disp('finish!')

