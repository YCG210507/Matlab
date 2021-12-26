clc;
clear;
%�����߶�������ݷ���������ͬ�ľ�����
[a,R]=geotiffread('F:\Temp\SM\2000.tif');%�ȵ���γ������
info=geotiffinfo('F:\Temp\SM\2000.tif');
[m,n]=size(a);
cd=2020-2000+1; %��ʾʱ�����г���
sm_sum=zeros(m*n,cd); % sm_sum=zeros(104*218,10);
for year=2000:2020
    filename=strcat('F:\Temp\SM\',int2str(year),'.tif');
    data=importdata(filename);
    data=reshape(data,m*n,1);
    sm_sum(:,year-1999)=data;
end

ndvi_sum=zeros(m*n,cd);
for year=2000:2020
    filename=strcat('F:\Temp\NDVI\',int2str(year),'.tif');
    data=importdata(filename);
    data=reshape(data,m*n,1);
    ndvi_sum(:,year-1999)=data;
end
%����Ժ�������
sm_ndvi_xgx = zeros(m,n);  % xgx=zeros(104,218);
sm_ndvi_pz = zeros(m,n);  % p=zeros(104,218);
for i=1:length(sm_sum)
    sm=sm_sum(i,:);
    if min(sm)>=0  %ע�������NPP����Ч��Χ�Ǵ���0������Լ���������Ч��Χ��С��0�Ļ�������Բ��ü����
        ndvi=ndvi_sum(i,:);
        [r,p]=corrcoef(sm,ndvi);%Ĭ��95%��������   [r,p] = corrcoef(A,'Alpha',0.01) ָ�� 99% ��������
        sm_ndvi_xgx(i)=r(2);
        sm_ndvi_pz(i)=p(2);
    end
end
output='F:\Temp\r_value.tif';
output1='F:\Temp\p_value.tif';
%%���ͼ��
geotiffwrite(output,sm_ndvi_xgx,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag);
geotiffwrite(output1,sm_ndvi_pz,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag);
disp('process over!');

