%�����߶�������ݷ���������ͬ�ľ�����
[a,R]=geotiffread('F:\������ѧУ��������Ŀ\data\���ϴ�\2002water_yield.tif');%�ȵ���ͶӰ��Ϣ
info=geotiffinfo('F:\������ѧУ��������Ŀ\data\���ϴ�\2002water_yield.tif');
cd=2015-2000+1;
nppsum=zeros(size(a,1)*size(a,2),cd);
for year=2000:2015
    filename=strcat('F:\������ѧУ��������Ŀ\data\���ϴ�\',int2str(year),'npp.tif');
    data=importdata(filename);
    data=reshape(data,size(a,1)*size(a,2),1);
    nppsum(:,year-1999)=data;
end
scsum=zeros(size(a,1)*size(a,2),cd);
for year=2000:2015
    filename=strcat('F:\������ѧУ��������Ŀ\data\���ϴ�\',int2str(year),'sc.tif');
    data=importdata(filename);
    data=reshape(data,size(a,1)*size(a,2),1);
    scsum(:,year-1999)=data;
end
wcsum=zeros(size(a,1)*size(a,2),cd);
for year=2000:2015
    filename=strcat('F:\������ѧУ��������Ŀ\data\���ϴ�\',int2str(year),'water_yield.tif');
    data=importdata(filename);
    data=reshape(data,size(a,1)*size(a,2),1);
    wcsum(:,year-1999)=data;
end
%����NPP������ˮ���������ֵ�ƫ���
rho_value=zeros(size(a,1),size(a,2))+nan;
p_value=zeros(size(a,1),size(a,2))+nan;
for i=1:size(a,1)*size(a,2)
      nppdata=nppsum(i,:);
      if min(nppdata)>0
            nppdata=nppdata';
            scdata=scsum(i,:)';
            wcdata=wcsum(i,:)';
            [rho,p]=partialcorr(scdata,wcdata,nppdata);%ע�⣬���Ƶı������������
            rho_value(i)=rho;
            p_value(i)=p;
      end
end
rho_value(p_value>0.05)=NaN;
filename='F:\������Ŀ\data\ͨ��������0.05����Ĳ�ˮ����������ƫ���ϵ��.tif';
geotiffwrite(filename,rho_value,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag);
disp('over!');
