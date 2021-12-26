clc;
clear;

%% ����ȡNC�ļ���׼������
datadir = 'C:\Users\User\Desktop\pls\2020\'; %ָ�������������ڵ��ļ���
filelist = dir([datadir,'*.nc']);       %�г���������ָ�����͵��ļ�          
k=length(filelist);

for i = 1:k  %���ζ�ȡ������
    
    %% ������ȡNC�ļ�
    ncFilePath = ['C:\Users\User\Desktop\pls\2020\',filelist(i).name]; %�趨NC·��
    num = filelist(i).name(39:46); %��ȡ���ݱ�ţ��Ա��ڱ���ʱ�Դ˱�Ŵ���tif
      
    %% ��ȡ����ֵ
    lon=ncread(ncFilePath,'lon');          %��ȡ������Ϣ����Χ�����ȣ�
    lat=ncread(ncFilePath,'lat');          %��ȡά����Ϣ
    %sm_uncertainty=ncread(ncFilePath,'sm_uncertainty');        %��ȡʱ������
    sm=ncread(ncFilePath,'sm');%��ȡ�����������
   % sum_pre=sum(pre,3);                    %�˴�����Ϊ�������ܽ�ˮ���������˿��Բ���
   
    %% չʾ�����ڲ��ṹ����Ϣ
     pcolor(lat,lon,sm);
     shading flat;                        %�Ƴ������ߣ�����ͼ��һƬ��ʲô��û��
     [x,y]=meshgrid(lon,lat);             %���ݾ�γ����Ϣ����������3600�У����ȣ���1800�У�γ�ȣ�
     phandle=pcolor(x,y,sm');        %��ʾһ����������x,y,sum_pre������������һ��
     shading flat;
     colorbar
     %imwrite(var','...................................','tif')
    
    %% ��Ϊtif��ʽ
%     data = flipud(sm.');                 %����Ҫ,��������ͼ����ϱ������Ǵ��
    data = rot90(sm);
    f = smoothn(data);
    R = georasterref('RasterSize', size(f),'Latlim', [double(min(lat)) double(max(lat))], 'Lonlim', [double(min(lon)) double(max(lon))]);
    geotiffwrite(['C:\Users\User\Desktop\pls\output\',num,'.tif'],f,R);
    disp([num,'done'])
    
end
disp('finish!')

