%将三者多年的数据放在三个不同的矩阵中
[a,R]=geotiffread('F:\长安大学校级课题项目\data\屏障带\2002water_yield.tif');%先导入投影信息
info=geotiffinfo('F:\长安大学校级课题项目\data\屏障带\2002water_yield.tif');
cd=2015-2000+1;
nppsum=zeros(size(a,1)*size(a,2),cd);
for year=2000:2015
    filename=strcat('F:\长安大学校级课题项目\data\屏障带\',int2str(year),'npp.tif');
    data=importdata(filename);
    data=reshape(data,size(a,1)*size(a,2),1);
    nppsum(:,year-1999)=data;
end
scsum=zeros(size(a,1)*size(a,2),cd);
for year=2000:2015
    filename=strcat('F:\长安大学校级课题项目\data\屏障带\',int2str(year),'sc.tif');
    data=importdata(filename);
    data=reshape(data,size(a,1)*size(a,2),1);
    scsum(:,year-1999)=data;
end
wcsum=zeros(size(a,1)*size(a,2),cd);
for year=2000:2015
    filename=strcat('F:\长安大学校级课题项目\data\屏障带\',int2str(year),'water_yield.tif');
    data=importdata(filename);
    data=reshape(data,size(a,1)*size(a,2),1);
    wcsum(:,year-1999)=data;
end
%控制NPP，看产水和土壤保持的偏相关
rho_value=zeros(size(a,1),size(a,2))+nan;
p_value=zeros(size(a,1),size(a,2))+nan;
for i=1:size(a,1)*size(a,2)
      nppdata=nppsum(i,:);
      if min(nppdata)>0
            nppdata=nppdata';
            scdata=scsum(i,:)';
            wcdata=wcsum(i,:)';
            [rho,p]=partialcorr(scdata,wcdata,nppdata);%注意，控制的变量放在最后面
            rho_value(i)=rho;
            p_value(i)=p;
      end
end
rho_value(p_value>0.05)=NaN;
filename='F:\课题项目\data\通过显著性0.05检验的产水和土壤保持偏相关系数.tif';
geotiffwrite(filename,rho_value,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag);
disp('over!');
