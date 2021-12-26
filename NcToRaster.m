clc;
clear;

%% 批读取NC文件的准备工作
datadir = 'C:\Users\User\Desktop\pls\2020\'; %指定批量数据所在的文件夹
filelist = dir([datadir,'*.nc']);       %列出所有满足指定类型的文件          
k=length(filelist);

for i = 1:k  %依次读取并处理
    
    %% 批量读取NC文件
    ncFilePath = ['C:\Users\User\Desktop\pls\2020\',filelist(i).name]; %设定NC路径
    num = filelist(i).name(39:46); %读取数据编号，以便于保存时以此编号储存tif
      
    %% 读取变量值
    lon=ncread(ncFilePath,'lon');          %读取经度信息（范围、精度）
    lat=ncread(ncFilePath,'lat');          %读取维度信息
    %sm_uncertainty=ncread(ncFilePath,'sm_uncertainty');        %读取时间序列
    sm=ncread(ncFilePath,'sm');%获取降雨变量数据
   % sum_pre=sum(pre,3);                    %此处我是为了求月总降水，所以他人可以不管
   
    %% 展示数据内部结构等信息
     pcolor(lat,lon,sm);
     shading flat;                        %移除网格线，否则图上一片黑什么都没有
     [x,y]=meshgrid(lon,lat);             %根据经纬度信息产生格网，3600列（经度），1800列（纬度）
     phandle=pcolor(x,y,sm');        %显示一个矩阵，其中x,y,sum_pre的行列数必须一致
     shading flat;
     colorbar
     %imwrite(var','...................................','tif')
    
    %% 存为tif格式
%     data = flipud(sm.');                 %很重要,否则最后的图像的南北朝向是错的
    data = rot90(sm);
    f = smoothn(data);
    R = georasterref('RasterSize', size(f),'Latlim', [double(min(lat)) double(max(lat))], 'Lonlim', [double(min(lon)) double(max(lon))]);
    geotiffwrite(['C:\Users\User\Desktop\pls\output\',num,'.tif'],f,R);
    disp([num,'done'])
    
end
disp('finish!')

