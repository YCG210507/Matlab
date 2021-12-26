clc
clear
[a,R]=geotiffread('H:\Global\NDVI3g\GIMMSraster\raster\最大合成\GIMMS_NDVI2015.tif');%先投影信息
info=geotiffinfo('H:\Global\NDVI3g\GIMMSraster\raster\最大合成\GIMMS_NDVI2015.tif');
cd=2015-1982+1;
ndvisum=zeros(size(a,1)*size(a,2),cd);%34期数据
k=1;
for year=1982:2015
    filename=strcat('H:\Global\NDVI3g\GIMMSraster\raster\最大合成\GIMMS_NDVI',int2str(year),'.tif');
    ndvi=importdata(filename);
    ndvi=reshape(ndvi,size(ndvi,1)*size(ndvi,2),1);
    ndvisum(:,k)=ndvi;
    k=k+1;
end
hsum=zeros(size(a,1),size(a,2))+NaN;
for kk=1:size(ndvisum,1);
    ndvi=ndvisum(kk,:);
    if min(ndvi)>0
        ndvi_cf=[];
        for i=1:length(ndvi)-1
            ndvi_cf1=ndvi(i+1)-ndvi(i);
            ndvi_cf=[ndvi_cf,ndvi_cf1];
        end
        M=[];
        for i=1:size(ndvi_cf,2)
            M1=mean(ndvi_cf(1:i));
            M=[M,M1];
        end
        S=[];

        for i=1:size(ndvi_cf,2)
            S1=std(ndvi_cf(1:i))*sqrt((i-1)/i);
            S=[S,S1];
        end

        for i=1:size(ndvi_cf,2)
            for j=1:i
                der(j)=ndvi_cf(1,j)-M(1,i);
                cum=cumsum(der);
                RR(i)=max(cum)-min(cum);
            end
        end

        RS=S(2:size(ndvi_cf,2)).\RR(2:size(ndvi_cf,2));
        T=[];
        for i=1:size(ndvi_cf,2)
            T1=i;
            T=[T,T1];
        end
        lag=T(2:size(ndvi_cf,2));                  
        g=polyfit(log(lag/2),log(RS),1);                
        H=g(1);
        hsum(kk)=H;
        clear der
    end
end
geotiffwrite('1982-2015年全球NDVI_Hurst指数.tif',hsum,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag);
disp('over!');
