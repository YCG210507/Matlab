
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
    pre = data(k,1);
    pet = data(k,2);
    SPEI = SPEIc(pre,pet)
    resu = [SPEI];
    result = [result;resu];
    result = [result,a];
    parp = [parp;result];
end
% dlmwrite(['C:\Users\User\Desktop\Temp\aaaaaa.txt'],parp);
xlswrite(['C:\Users\User\Desktop\Temp\consule.xlsx'],parp);
disp('finsh!!');

