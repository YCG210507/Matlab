% GPCC���ݴ���
clc;
clear;
ncdisp('C:\Users\User\Desktop\aaa\data2.nc')
latlim = [-90 90];
lonlim = [-180 180];
data = ncread('C:\Users\User\Desktop\aaa\data2.nc','precip');%��pre��ʽһ��
rastersize = [720 1440];
R = georefcells(latlim,lonlim,rastersize,'ColumnsStartFrom','south','RowsStartFrom','west');

for year=2011:2019
    data1=data(:,:,1+12*(year-2011):12+12*(year-2011)); %�õ�ÿ���12��������
    for mon=1:12
        data2=data1(:,:,mon);
        data4=rot90(data2);
        data4(isnan(data4))=-999;
        filename=strcat('C:\Users\User\Desktop\aaa\',int2str(year),'��_',int2str(mon),'��tmp.tif');
        geotiffwrite(filename,data4,R);
    end
    
end

disp(['done']);




