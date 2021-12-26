clc
clear 
[a,R]=geotiffread('F:\Temp\input\2001.tif'); %先导入投影信息
info=geotiffinfo('F:\Temp\input\2001.tif');%先导入投影信息
data=importdata('F:\Temp\input\sm检验结果.tif'); 
sen_value=importdata('F:\Temp\input\sm变化趋势.tif');
sen_value(abs(data)<1.96)=-9999; %MK结果值高于1.96则认为通过了显著性95% %abs (x)是去绝对值的函数
geotiffwrite('F:\Temp\output\sm显著性.tif',sen_value,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag);%注意修改路径
disp('process over!');

