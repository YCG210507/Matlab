% @author yinlichang3064@163.com
[a,R]=geotiffread('D:\qixiang\年尺度数据\插值的结果\平均温度\tem2000.tif');%先导入纬度数据
info=geotiffinfo('D:\qixiang\年尺度数据\插值的结果\平均温度\tem2000.tif');
[m,n]=size(a);
cd=2020-2000+1;
temsum=zeros(m*n,cd);%16表示时间序列长度
presum=zeros(m*n,cd);%16表示时间序列长度
ndvisum=zeros(m*n,cd);%16表示时间序列长度
k=1;
for year=2000:2020
     temp=importdata(['D:\qixiang\年尺度数据\插值的结果\年平均温度\tem',int2str(year),'.tif']) ; %
     pre=importdata(['D:\qixiang\年尺度数据\插值的结果\年降水\pre',int2str(year),'.tif']) ; 
     ndvi=importdata(['D:\qixiang\年尺度数据\ndvi',int2str(year),'.tif']) ; 
     %注意数据的有效范围
     temp(temp<-1000)=NaN;%温度有效范围
     pre(pre<0)=NaN;%有效范围大于0
     ndvi(ndvi<-1)=NaN; %有效范围是-1到1
     temsum(:,k)=reshape(temp,m*n,1);    %temsum(:,year-1999)=reshape(temp,m*n,1);
     presum(:,k)=reshape(pre,m*n,1);     %presum(:,year-1999)=reshape(pre,m*n,1);
     ndvisum(:,k)=reshape(ndvi,m*n,1);   %ndvisum(:,year-1999)=reshape(ndvi,m*n,1);
     k=k+1;   
end
%多元回归，ndvi=a*pre+b*tem
pre_slope=zeros(m,n)+NaN;
tem_slope=zeros(m,n)+NaN;
pz=zeros(m,n)+NaN;
for i=1:m*n
    pre=presum(i,:)';
    if min(pre)>=0
        ndvi=ndvisum(i,:)';
        tem=temsum(i,:)';
        X=[ones(size(ndvi)),tem,pre];
        [b,bint,r,rint,stats] = regress(ndvi,X);
        pre_slope(i)=b(3);
        tem_slope(i)=b(2);
        pz(i)=stats(3);
    end
end
filename='d:/降水的系数.tif';
geotiffwrite(filename,pre_slope,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)

filename='d:/温度的系数.tif';
geotiffwrite(filename,tem_slope,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)

filename='d:/方程的显著性.tif';
geotiffwrite(filename,pz,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)

pre_slope(pz>0.05)=NaN;
filename='d:/方程通过0.05显著性检验的降水的系数.tif';
geotiffwrite(filename,pre_slope,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)

tem_slope(pz>0.05)=NaN;
filename='d:/方程通过0.05显著性检验的温度的系数.tif';
geotiffwrite(filename,tem_slope,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)
disp('over!');
