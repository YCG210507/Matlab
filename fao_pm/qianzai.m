
%«±‘⁄’Ù…¢∑¢º∆À„
clear, clc
parp = [];
% p = parpool('local',5);
file = 'C:\Users\User\Desktop\Temp\test.txt';
data = importdata(file);
resu = [];
result = [];
[i,j] = size(data);

parfor k = 1:i
    a = k;
    result = [];
    yearday = data(k,1);
    Tmean = data(k,2);
    Tmax = data(k,3);
    Tmin = data(k,4);
    RHmean = data(k,5);
    wind = data(k,6);
    sunshineHour = data(k,7);
    DEM = data(k,8);
    latitude = data(k,9);
    PE = PMET0(yearday,Tmean,Tmax,Tmin,RHmean,wind,sunshineHour,DEM,latitude)
    resu = [PE];
    result = [result;resu];
    result = [result,a];
    parp = [parp;result];
end
% dlmwrite(['C:\Users\User\Desktop\Temp\aaaaaa.txt'],parp);
xlswrite(['C:\Users\User\Desktop\Temp\consule.xlsx'],parp);
disp('finsh!!');

