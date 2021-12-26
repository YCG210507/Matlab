% （1）首先在我们在arcgis中加载我们的图像，并在符号系统中显示出来Nodata值，如下图所示
% （2）进入到目录Catalog中创建一个点图层，并将地理投影设置成WGS1984即可
% （3）然后对点图层进行编辑，随意在图上打点，注意点要覆盖到整个图像，同时四周也都要有点，保证图像范围之外的四周都有点的存在，如下
% （4）停止编辑，在点图层中增加经纬度表头，浮点型，计算出经纬度的值
% （5）利用自然邻近法插值经度和纬度值，插值时设置投影，范围和栅格分析与图像保持一致。
clc
clear 
lon=importdata('D:\sjy\lon.tif');
lat=importdata('D:\sjy\lat.tif');
vsum=[];
for year=2000:2015
    filename=['D:\sjy\GLASS-LAI_modis_1km_tif_mean_clip\GLASS_LAI',int2str(year),'.tif'];
    data=importdata(filename);
    sy=find(data>0); % 注意下有效值范围
    value=[data(sy),lon(sy),lat(sy)];
    x1=sum(value(:,1).*value(:,2))./sum(value(:,1));% 经度
    x2=sum(value(:,1).*value(:,3))./sum(value(:,1));% 纬度度
    v=[year,x1,x2];
    vsum=[vsum;v];
end
csvwrite('D:\sjy\重心.csv',vsum)
%绘制图
plot(vsum(:,2),vsum(:,3))


