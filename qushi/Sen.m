clc
clear
[a,R]=geotiffread('F:\\Temp\\input\\2001.tif');%先导入投影信息
info=geotiffinfo('F:\\Temp\\input\\2001.tif');
[m,n]=size(a);
cd = 2020-2000+1; %时间跨度，根据需要自行修改
datasum=zeros(m*n,cd)+NaN; 
k=1;
for year=2000:2020 %起始年份
    filename=['F:\\Temp\\input\\',int2str(year),'.tif'];
    data=importdata(filename);  % importdata可替换为imread
    data=reshape(data,m*n,1);
    datasum(:,k)=data;
    k=k+1;
end
trend=zeros(m,n)+NaN;
for i=1:size(datasum,1)
    data=datasum(i,:);
    if min(data)>=0 %判断是否是有效值,我这里的有效值必须大于0
        valuesum=[];
        for k1=2:cd
            for k2=1:(k1-1)
                cz=data(k1)-data(k2);
                jl=k1-k2;
                value=cz./jl;
                valuesum=[valuesum;value];
            end
        end
        value=median(valuesum);
        trend(i)=value;
    end
end
filename=['F:\\Temp\\output\\ndvi趋势.tif'];
geotiffwrite(filename,trend,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)
disp('process over!');
