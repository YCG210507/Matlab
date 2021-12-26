% ��1��������������arcgis�м������ǵ�ͼ�񣬲��ڷ���ϵͳ����ʾ����Nodataֵ������ͼ��ʾ
% ��2�����뵽Ŀ¼Catalog�д���һ����ͼ�㣬��������ͶӰ���ó�WGS1984����
% ��3��Ȼ��Ե�ͼ����б༭��������ͼ�ϴ�㣬ע���Ҫ���ǵ�����ͼ��ͬʱ����Ҳ��Ҫ�е㣬��֤ͼ��Χ֮������ܶ��е�Ĵ��ڣ�����
% ��4��ֹͣ�༭���ڵ�ͼ�������Ӿ�γ�ȱ�ͷ�������ͣ��������γ�ȵ�ֵ
% ��5��������Ȼ�ڽ�����ֵ���Ⱥ�γ��ֵ����ֵʱ����ͶӰ����Χ��դ�������ͼ�񱣳�һ�¡�
clc
clear 
lon=importdata('D:\sjy\lon.tif');
lat=importdata('D:\sjy\lat.tif');
vsum=[];
for year=2000:2015
    filename=['D:\sjy\GLASS-LAI_modis_1km_tif_mean_clip\GLASS_LAI',int2str(year),'.tif'];
    data=importdata(filename);
    sy=find(data>0); % ע������Чֵ��Χ
    value=[data(sy),lon(sy),lat(sy)];
    x1=sum(value(:,1).*value(:,2))./sum(value(:,1));% ����
    x2=sum(value(:,1).*value(:,3))./sum(value(:,1));% γ�ȶ�
    v=[year,x1,x2];
    vsum=[vsum;v];
end
csvwrite('D:\sjy\����.csv',vsum)
%����ͼ
plot(vsum(:,2),vsum(:,3))


