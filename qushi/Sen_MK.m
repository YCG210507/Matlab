clc
clear 
[a,R]=geotiffread('F:\Temp\input\2001.tif'); %�ȵ���ͶӰ��Ϣ
info=geotiffinfo('F:\Temp\input\2001.tif');%�ȵ���ͶӰ��Ϣ
data=importdata('F:\Temp\input\sm������.tif'); 
sen_value=importdata('F:\Temp\input\sm�仯����.tif');
sen_value(abs(data)<1.96)=-9999; %MK���ֵ����1.96����Ϊͨ����������95% %abs (x)��ȥ����ֵ�ĺ���
geotiffwrite('F:\Temp\output\sm������.tif',sen_value,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag);%ע���޸�·��
disp('process over!');

