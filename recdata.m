% 
clc;
clear;
ncdisp('C:\Users\User\Desktop\aaa\tmp_2015_2017.nc')
lat = ncread('C:\Users\User\Desktop\aaa\tmp_2015_2017.nc','lat');
lon = ncread('C:\Users\User\Desktop\aaa\tmp_2015_2017.nc','lon');
time = ncread('C:\Users\User\Desktop\aaa\tmp_2015_2017.nc','time');
data = ncread('C:\Users\User\Desktop\aaa\tmp_2015_2017.nc','tmp');  %和pre格式一样
% rastersize = [4717 7680];
% R = georefcells(latlim,lonlim,rastersize,'ColumnsStartFrom','south','RowsStartFrom','west');


for year = 2015:2017
    data1 = data(:,:,1+12*(year-2015):12+12*(year-2015)); %得到每年的12个月数据
    for mon = 1:12
        data2 = data1(:,:,mon);
%         data2(isnan(data2))=-999;
        data3 = rot90(data2);
        filename = strcat('C:\Users\User\Desktop\aaa\',int2str(year),'年_',int2str(mon),'月tmp.tif');
        R = georasterref('RasterSize', size(data3),'Latlim', [double(min(lat)) double(max(lat))], 'Lonlim', [double(min(lon)) double(max(lon))]);
        geotiffwrite(filename,data3,R);
    end
    
end

disp(['done']);