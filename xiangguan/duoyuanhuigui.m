% @author yinlichang3064@163.com
[a,R]=geotiffread('D:\qixiang\��߶�����\��ֵ�Ľ��\ƽ���¶�\tem2000.tif');%�ȵ���γ������
info=geotiffinfo('D:\qixiang\��߶�����\��ֵ�Ľ��\ƽ���¶�\tem2000.tif');
[m,n]=size(a);
cd=2020-2000+1;
temsum=zeros(m*n,cd);%16��ʾʱ�����г���
presum=zeros(m*n,cd);%16��ʾʱ�����г���
ndvisum=zeros(m*n,cd);%16��ʾʱ�����г���
k=1;
for year=2000:2020
     temp=importdata(['D:\qixiang\��߶�����\��ֵ�Ľ��\��ƽ���¶�\tem',int2str(year),'.tif']) ; %
     pre=importdata(['D:\qixiang\��߶�����\��ֵ�Ľ��\�꽵ˮ\pre',int2str(year),'.tif']) ; 
     ndvi=importdata(['D:\qixiang\��߶�����\ndvi',int2str(year),'.tif']) ; 
     %ע�����ݵ���Ч��Χ
     temp(temp<-1000)=NaN;%�¶���Ч��Χ
     pre(pre<0)=NaN;%��Ч��Χ����0
     ndvi(ndvi<-1)=NaN; %��Ч��Χ��-1��1
     temsum(:,k)=reshape(temp,m*n,1);    %temsum(:,year-1999)=reshape(temp,m*n,1);
     presum(:,k)=reshape(pre,m*n,1);     %presum(:,year-1999)=reshape(pre,m*n,1);
     ndvisum(:,k)=reshape(ndvi,m*n,1);   %ndvisum(:,year-1999)=reshape(ndvi,m*n,1);
     k=k+1;   
end
%��Ԫ�ع飬ndvi=a*pre+b*tem
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
filename='d:/��ˮ��ϵ��.tif';
geotiffwrite(filename,pre_slope,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)

filename='d:/�¶ȵ�ϵ��.tif';
geotiffwrite(filename,tem_slope,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)

filename='d:/���̵�������.tif';
geotiffwrite(filename,pz,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)

pre_slope(pz>0.05)=NaN;
filename='d:/����ͨ��0.05�����Լ���Ľ�ˮ��ϵ��.tif';
geotiffwrite(filename,pre_slope,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)

tem_slope(pz>0.05)=NaN;
filename='d:/����ͨ��0.05�����Լ�����¶ȵ�ϵ��.tif';
geotiffwrite(filename,tem_slope,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)
disp('over!');
