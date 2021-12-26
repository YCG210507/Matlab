clc;
clear;
%% ����ȡNC�ļ���׼������
datapath = 'C:\Users\User\Desktop\pls\2000\'; %ָ�������������ڵ��ļ���
filelist = dir([datapath,'*.nc']);       %�г���������ָ�����͵��ļ�
k = length(filelist);
for i = 1:k  %���ζ�ȡ������    
    %% ������ȡNC�ļ�
    datapath = ['C:\Users\User\Desktop\pls\2000\',filelist(i).name]; %�趨NC·��
    num = filelist(i).name(39:46); %��ȡ���ݱ�ţ��Ա��ڱ���ʱ�Դ˱�Ŵ���tif25��32      
    %% ��ȡ����ֵ
    lon = ncread(datapath,'lon');          %��ȡ������Ϣ����Χ�����ȣ�
    lat = ncread(datapath,'lat');          %��ȡά����Ϣ
    time = ncread(datapath,'time');        %��ȡʱ������
    sm = ncread(datapath,'sm');           %��ȡ��������
    %% ��Ϊtif��ʽ
    data = flipud(sm.'); %����ת    
%   data2 = flipud(data1);%���ҷ�ת  data2 = rot90(data1,2);%��ʱ����ת180�� data1 = rot90(data,2);%��ʱ����ת90��
%     data(isnan(data)) = 0; %��ֵ��Ϊ0
    ph_result = smoothn(data); %DCT-PLS ƽ��
    R = georasterref('RasterSize', size(ph_result),'Latlim', [double(min(lat)) double(max(lat))], 'Lonlim', [double(min(lon)) double(max(lon))]);
    geotiffwrite(['C:\Users\User\Desktop\pls\output\2000\sm',num,'.tif'],ph_result,R);
    disp([num,'over'])
end
disp('finish!')

