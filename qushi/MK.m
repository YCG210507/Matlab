clc;
clear;
[a,R]=geotiffread('F:\Temp\input\2001.tif'); %先导入投影信息
info=geotiffinfo('F:\Temp\input\2001.tif');%先导入投影信息
[m,n]=size(a);
cd = 2020-2000+1;       %10年，时间跨度  
datasum=zeros(m*n,cd)+NaN; 
p=1;
for year=2000:2020      %起始年份
    filename=['F:\Temp\input\',int2str(year),'.tif'];
    data=importdata(filename);
    data=reshape(data,m*n,1);
    datasum(:,p)=data;         %
    p=p+1;
end
sresult=zeros(m,n)+NaN;

for i=1:size(datasum,1)        %
    data=datasum(i,:);
    if min(data)>=0       % 有效格点判定，我这里有效值在0以上
        sgnsum=[];  
        for k=2:cd
            for j=1:(k-1)
                sgn=data(k)-data(j);
                if sgn>0
                    sgn=1;
                else
                    if sgn<0
                        sgn=-1;
                    else
                        sgn=0;
                    end
                end
                sgnsum=[sgnsum;sgn];
            end
        end  
        add=sum(sgnsum);
        sresult(i)=add; 
    end
end
vars=cd*(cd-1)*(2*cd+5)/18;
zc=zeros(m,n)+NaN;
sy=find(sresult==0);% sy=sresult==0;
zc(sy)=0;
sy=find(sresult>0);
zc(sy)=(sresult(sy)-1)./sqrt(vars);
sy=find(sresult<0);
zc(sy)=(sresult(sy)+1)./sqrt(vars);
geotiffwrite('F:\Temp\output\ndvi检验.tif',zc,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag); %注意修改路径
disp('process over!');
