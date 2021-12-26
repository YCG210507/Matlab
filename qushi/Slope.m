clc
clear all
[a,R]=geotiffread('C:\Users\User\Desktop\Temp\K2011.tif');%�ȵ���ĳ��ͼ���ͶӰ��Ϣ��Ϊ����ͼ�������׼ȷ
info=geotiffinfo('C:\Users\User\Desktop\Temp\K2011.tif');
[m,n]=size(a);
years=10; %��ʾ�ж��������Ҫ���ع�
data=zeros(m*n,years);
k=1;
for year=2011:2020 %��ʼ���
    file=['C:\Users\User\Desktop\Temp\K',int2str(year),'.tif'];%ע���Լ���������ʽ������ʹ�õ���������prec2000.tif������������޸�
    bz=importdata(file);
    bz=reshape(bz,m*n,1);
    data(:,k)=bz;
    k=k+1;
end
    xielv=zeros(m,n);p=zeros(m,n);
for i=1:length(data)
    bz=data(i,:);
    if max(bz)>0 %ע�����ǽ����ж���Чֵ��Χ�������Ч��Χ��-1��1����ĳ�max(bz)>-1����
        bz=bz';
        X=[ones(size(bz)) bz];
        X(:,2)=[1:years]';
        [b,bint,r,rint,stats] = regress(bz,X);
        pz=stats(3);
        p(i)=pz;
        xielv(i)=b(2);
    end
end
name1='C:\Users\User\Desktop\Temp\һԪ���Իع�����ֵ.tif';
name2='C:\Users\User\Desktop\Temp\һԪ���Իع�Pֵ.tif';
geotiffwrite(name1,xielv,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag);
geotiffwrite(name2,p,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag);
%һ����˵��ֻ��ͨ�������Լ��������ֵ���ǿɿ���
xielv(p>0.05)=NaN;
name1='C:\Users\User\Desktop\Temp\������0.05����.tif';
geotiffwrite(name1,xielv,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag);
disp('finish!')
