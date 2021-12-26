clc
clear
% nc�ļ���·��
%filepath='C:\Users\User\Desktop\test\';
% ���txt��·��
%txt='C:\Users\User\Desktop\test\';
% ��ȡ���ļ���������nc��
%list=dir(strcat(filepath,'*.nc'));

%% ����ȡNC�ļ���׼������
datadir = 'C:\Users\User\Desktop\result\'; %ָ�������������ڵ��ļ���
filelist = dir([datadir,'*.nc']);       %�г���������ָ�����͵��ļ�

k=length(filelist);

for i = 1:k  %���ζ�ȡ������
    
    %% ������ȡNC�ļ�
    ncFilePath = ['C:\Users\User\Desktop\result\',filelist(i).name]; %�趨NC·��
    num = filelist(i).name(27:32); %��ȡ���ݱ�ţ��Ա��ڱ���ʱ�Դ˱�Ŵ���
      
    %% ��ȡ����ֵ
    lon=ncread(ncFilePath,'lon'); %��ȡ����
    lat=ncread(ncFilePath,'lat'); %��ȡά��
    var=ncread(ncFilePath,'SM');%��ȡsm��������
    a = find(lon >= 70 & lon <= 130);
    b = find(lat >= 25 & lat <= 55);     
    lon_num = length(a);
    lat_num = length(b);
    sm = ncread(ncFilePath,'SM',[a(1) b(1) 1 ],[lon_num lat_num 1]); 
    z = sm.';%ת��
    c = reshape(z,[],1);
    dlmwrite(['C:\Users\User\Desktop\result\',num,'.csv'],c,'\t');
    
end
disp('finish!')
