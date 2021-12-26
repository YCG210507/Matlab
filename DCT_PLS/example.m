clc;
clear;
%% 批读取NC文件的准备工作
datapath = 'C:\Users\User\Desktop\pls\2000\'; %指定批量数据所在的文件夹
filelist = dir([datapath,'*.nc']);       %列出所有满足指定类型的文件
k = length(filelist);
for i = 1:k  %依次读取并处理    
    %% 批量读取NC文件
    datapath = ['C:\Users\User\Desktop\pls\2000\',filelist(i).name]; %设定NC路径
    num = filelist(i).name(39:46); %读取数据编号，以便于保存时以此编号储存tif25：32      
    %% 读取变量值
    lon = ncread(datapath,'lon');          %读取经度信息（范围、精度）
    lat = ncread(datapath,'lat');          %读取维度信息
    time = ncread(datapath,'time');        %读取时间序列
    sm = ncread(datapath,'sm');           %获取变量数据
    %% 存为tif格式
    data = flipud(sm.'); %镜像反转    
%   data2 = flipud(data1);%左右翻转  data2 = rot90(data1,2);%逆时针旋转180° data1 = rot90(data,2);%逆时针旋转90°
%     data(isnan(data)) = 0; %空值设为0
    ph_result = smoothn(data); %DCT-PLS 平滑
    R = georasterref('RasterSize', size(ph_result),'Latlim', [double(min(lat)) double(max(lat))], 'Lonlim', [double(min(lon)) double(max(lon))]);
    geotiffwrite(['C:\Users\User\Desktop\pls\output\2000\sm',num,'.tif'],ph_result,R);
    disp([num,'over'])
end
disp('finish!')

