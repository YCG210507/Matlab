clc;clear;close all;
%%  input
MetDy_pt = 'G:\outputdata\test';
[yr1,yr2] = deal(1961,2016);
outpt = 'G:\outputdata\ET';
outhd = 'SURF_CLI_CHN_MUL_ID_';
%%  operate
hd = 'SURF_CLI_CHN_MUL_ID_';
A=xlsread('G:\selectstations.xlsx');
% SURF_CLI_CHN_MUL_DAY_STATIONΪ����̨վ��
S=size(A,1);
% StnIDs = A(:,1);  % ��ȡ��һ��վ��ID
for r=1:S
    S_ID=A(r,1);
 for yr = yr1:yr2
    fl=dir([MetDy_pt,filesep,hd,num2str(S_ID),'_',num2str(yr),'.txt']);
    tmp=dlmread([MetDy_pt,filesep,fl.name]);
    m=size(tmp,1);
  for R=1:m
    Y=tmp(R,2);     % γ��
    X=tmp(R,3);     % ����
    Z=tmp(R,4);     % ����
    h=10;             % hight of the wind speed ������ �߶ȣ�
    % define variables   ����������Ҫ�� ������
    year=tmp(R,5);
    month=tmp(R,6);
    Tmean=tmp(R,9);
    Tmax=tmp(R,10);
    Tmin=tmp(R,11);
    RH=tmp(R,13);
    WS=tmp(R,14)/10;     
    SSD=tmp(R,15)/10;        
    u=WS*0.7480; % ���� 
%     ******************����ѹ*************
    Pre=101.3*((293-0.065*Z)/293)^5.26;
%     ******************����ˮ��ѹ����б��*************
    delta=(4098*0.6108*exp(17.27*Tmean/(Tmean+273.3)))/((Tmean+273.3)^2);
%     pre=Pre;        %  air pressure
    % ********step 5:psychrometric constant��ʪ����********
    gamma=6.65E-4*Pre;
    %********step 6:Delta Term(DT)(auxiliary for calculation for Radiation Term)********
    DT=delta/(delta+gamma*(1+0.34*u));
    % ********step 7:Psi Term(PT)(auxiliary for calculation for Wind Term)********
    PT=gamma/(delta+gamma*(1+0.34*u));
    % ********step 8:Tempreture Term(TT)(auxiliary for calculation for Wind
    % Term)********
    TT=900*(Tmean+273)^-1*u;
    % ********step 9:mean saturation vapor pressure derived from air tempreture(eS)********
    eTmax=0.6108*exp(17.27*Tmax/(Tmax+237.3));
    eTmin=0.6108*exp(17.27*Tmin/(Tmin+237.3));
    eS=(eTmax+eTmin)/2;
    % ********step 10:actual vapor pressure(eA) derived from relative humidity********
    eA=eS.*RH;   %eA=RH.*(eTmax+eTmin)/2
    %*****step 12:the inverse relative distance Earth-Sun(dr)and solar declination
    dr=1+0.033*cos(2*pi*m/365);
    theta=0.409*sin(2*pi*m/365-1.39);
    %***step 13:conversion of latitude phi in degree to radian
    phi=Y*pi/180;
    %***step 14:sunset hour angle(ws)
    ws=acos(-tan(theta)*tan(phi));
    %***step 15:extraterrestrial radiation(Ra)
    M1=ws*sin(phi)*sin(theta);
    M2=cos(phi)*cos(theta)*sin(ws);
    Ra=24*60/pi*0.082*dr*(M1+M2);
    %***step 16:clear sky solar radiation(Rso)
    Rso=(0.75+2E-5*Z)*Ra;
    %***step 17:calculate the net solar radiation kick out bad data
    %  �޳�����ʱ���е��쳣ֵ
%     SD_cal=SSD;
%     index1=find(SD_cal>3000);
%     SD_cal(index1)=0;
% get the parameters for the RA calculation 
%     n=SD_cal;      % n,sunshine hours of a day,unit:hour
    n=SSD;
    a=0.207;   % ����ǳ��ؼ���
    b=0.725;   % ����ǳ��ؼ���
    % calculate the theory lenth of day(sunrise-sunset)
    N1=-sin(phi)*sin(theta)-0.044;
    N2=cos(phi)*cos(theta);
    N=7.64*acos(N1/N2);
    %calculate net daily solar radiation ̫������
    Rs=Rso*(a+b*n/N);
    %step 18:net shortwave radiation  ���̲�����
    alpha=0.23;
    Rns=(1-alpha)*Rs;
    %step 19:net outgoing longwave solar radiation ���������
    R1=((Tmax+273.15)^4+(Tmin+273.15)^4)/2;
    R2=0.34-0.14*eA^0.5;
    R3=1.35*Rs/Rso-0.35;
    Rnl=4.903E-09*R1*R2*R3;
    %step 20:net radiation  ������
    Rn=Rns-Rnl;
    Rng=0.408*Rn;
    %step 21:Radiation Term (ETrad)
    ETrad=DT*Rng;
    %step 22:Wind Term(ETwind)
    ETwind=PT*TT*(eS-eA);
    %step 23:final reference evapotranspiration value(ETo) ��������ETo_penman
    ETo=ETrad+ETwind;
    tmp(R,18)=ETo;
  end
    dlmwrite([outpt,filesep,outhd,num2str(S_ID),'_',num2str(yr),'.txt'],tmp,'delimiter',' ')
    disp([num2str(S_ID),' ',num2str(yr)])
 end
end
    disp('finish!')