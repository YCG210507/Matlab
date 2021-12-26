%«±‘⁄’Ù…¢∑¢º∆À„

clear, clc
% p = parpool(6);
file = 'C:\Users\User\Desktop\Temp\test.txt';
data = importdata(file);
resu = [];
result = [];
[i,k] = size(data);
parpool;
for q=1:i
    yearday = data(q,1);
    Tmean = data(q,2);
    Tmax = data(q,3);
    Tmin = data(q,4);
    RHmean = data(q,5);
    wind = data(q,6);
    sunshineHour = data(q,7);
    DEM = data(q,8);
    latitude = data(q,9);
    PE = PMET0(yearday,Tmean,Tmax,Tmin,RHmean,wind,sunshineHour,DEM,latitude)
    resu=[PE];
    result = [result;resu];
    dlmwrite(['C:\Users\User\Desktop\Temp\','aaaaaa.txt'],result);
end
disp('finsh!!');