clc
clear all
[a,R]=geotiffread('C:\Users\User\Desktop\Temp\K2011.tif');%先导入某个图像的投影信息，为后续图像输出做准确
info=geotiffinfo('C:\Users\User\Desktop\Temp\K2011.tif');
[m,n]=size(a);
years=10; %表示有多少年份需要做回归
data=zeros(m*n,years);
k=1;
for year=2011:2020 %起始年份
    file=['C:\Users\User\Desktop\Temp\K',int2str(year),'.tif'];%注意自己的名字形式，这里使用的名字是年prec2000.tif，根据这个可修改
    bz=importdata(file);
    bz=reshape(bz,m*n,1);
    data(:,k)=bz;
    k=k+1;
end
    xielv=zeros(m,n);p=zeros(m,n);
for i=1:length(data)
    bz=data(i,:);
    if max(bz)>0 %注意这是进行判断有效值范围，如果有效范围是-1到1，则改成max(bz)>-1即可
        bz=bz';
        X=[ones(size(bz)) bz];
        X(:,2)=[1:years]';
        [b,bint,r,rint,stats] = regress(bz,X);
        pz=stats(3);
        p(i)=pz;
        xielv(i)=b(2);
    end
end
name1='C:\Users\User\Desktop\Temp\一元线性回归趋势值.tif';
name2='C:\Users\User\Desktop\Temp\一元线性回归P值.tif';
geotiffwrite(name1,xielv,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag);
geotiffwrite(name2,p,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag);
%一般来说，只有通过显著性检验的趋势值才是可靠的
xielv(p>0.05)=NaN;
name1='C:\Users\User\Desktop\Temp\显著性0.05检验.tif';
geotiffwrite(name1,xielv,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag);
disp('finish!')
