clc
clear
[a,R]=geotiffread('F:\\Temp\\input\\2001.tif');%�ȵ���ͶӰ��Ϣ
info=geotiffinfo('F:\\Temp\\input\\2001.tif');
[m,n]=size(a);
cd = 2020-2000+1; %ʱ���ȣ�������Ҫ�����޸�
datasum=zeros(m*n,cd)+NaN; 
k=1;
for year=2000:2020 %��ʼ���
    filename=['F:\\Temp\\input\\',int2str(year),'.tif'];
    data=importdata(filename);  % importdata���滻Ϊimread
    data=reshape(data,m*n,1);
    datasum(:,k)=data;
    k=k+1;
end
trend=zeros(m,n)+NaN;
for i=1:size(datasum,1)
    data=datasum(i,:);
    if min(data)>=0 %�ж��Ƿ�����Чֵ,���������Чֵ�������0
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
filename=['F:\\Temp\\output\\ndvi����.tif'];
geotiffwrite(filename,trend,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)
disp('process over!');
