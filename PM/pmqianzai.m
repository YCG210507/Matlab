clc;clear;close all
file1=xlsread('testdata.xlsx'); 
data=load(file1);
dims=size(data);
row=dims(1);
col=dims(2);
Nt=row;
% define station information
LON=109.5;        % longititude of the station
LAT=35.817;       % latitude  of the station
alt=1159.8;       % altitude  of the station
h=10;             % hight of the wind speed
% define variables
year=data(:,2); % 年
month=data(:,3);% 月
day=data(:,4);  % 日
Pre=data(:,5)/100;           % 平均气压
Tmean0=data(:,6)/10;         % 平均气温
Tmax=data(:,7)/10;           % 最高气温
Tmin=data(:,8)/10;           % 最低气温
RH=data(:,9)/100;            % 平均相对湿度
RHmin=data(:,10)/100;        % 最低相对湿度
P=data(:,11)/10;             % 降雨量
WS=data(:,12)/10;            % 平均风速
WSmax=data(:,13);            % 最大风速
SD=data(:,17)/10;            % 日照时间  
% year series
yr_beg=1981;
yr_end=year(Nt);
Ny=yr_end-yr_beg+1;
yr_arr0=yr_beg:1:yr_end;
yr_arr=reshape(yr_arr0,Ny,1);
%%
% *********start to calculate the ET by Pemann-Montieth Equation***********
% ********step 1:mean daily tempreture********
% Tmean=zeros(Nt,1);
Tmean=(Tmax+Tmin)/2;   % Tmean in PM method
% ********step 2:wind speed********
  % u=WS*4.87/ln(67.8*h-5.42);in fact,ln is in format log:log=ln
    % h=10 ，so 4.87/ln(67.8*h-5.42)=0.7480
u=WS*0.7480;
% ********step 3:slope of saturation vapor pressure curve********
delta=4098*0.6108*exp(17.27*Tmean./(Tmean+273.3))./(Tmean+273.3).^2;
% ********step 4:air pressure curve********
pre=Pre;        %  air pressure
% ********step 5:psychrometric constant********
gamma=6.65E-4*pre;     
%********step 6:Delta Term(DT)(auxiliary for calculation for Radiation Term)********
DT=delta./(delta+gamma.*(1+0.34*u));
% ********step 7:Psi Term(PT)(auxiliary for calculation for Wind Term)********
PT=gamma./(delta+gamma.*(1+0.34*u));
% ********step 8:Tempreture Term(TT)(auxiliary for calculation for Wind
% Term)********
TT=900*(Tmean+273).^-1.*u;
% ********step 9:mean saturation vapor pressure derived from air tempreture(eS)********
eTmax=0.6108*exp(17.27*Tmax./(Tmax+237.3));
eTmin=0.6108*exp(17.27*Tmin./(Tmin+237.3));
eS=(eTmax+eTmin)/2;
% ********step 10:actual vapor pressure(eA) derived from relative humidity********
eA=eS.*RH;   %eA=RH.*(eTmax+eTmin)/2
%*****step 11:number of the day in the year******
doy=zeros(Nt,1);
idx_tp=0;
for i=1:1:Ny
    i_yr=yr_arr(i);
    Y_idx=find(year==i_yr); %find the index matching the selected year
    len=length(Y_idx);      %total days of the selected year
    % get the month and day array of the selected year
    tp_mon=month(Y_idx);
    tp_day=day(Y_idx);
    % count the number of day in the selcted year
    doy_tp=zeros(len,1);
    for j=1:1:len
        i_mon=tp_mon(j);
        i_day=tp_day(j);
        DA=[0,31,59,90,120,151,181,212,243,273,304,334];
        doy_tp(j)=DA(i_mon)+i_day;
        if (mod(i_yr,4)==0&&i_mon>2)  % if the year is leap year
            doy_tp(j)=doy(j)+1;
        end
    end
   %put every year dayth number into the day_array
   doy(idx_tp+1:idx_tp+len)=doy_tp;
   % make the begin index(idx_tp) forward
   idx_tp=idx_tp+len;
end
%*****step 12:the inverse relative distance Earth-Sun(dr)and solar
%declination
dr=1+0.033*cos(2*pi*doy/365);
theta=0.409*sin(2*pi*doy/365-1.39);
%***step 13:conversion of latitude phi in degree to radian
phi=LAT*pi/180;
%***step 14:sunset hour angle(ws)
ws=acos(-tan(theta)*tan(phi));
%***step 15:extraterrestrial radiation(Ra)
M1=ws*sin(phi).*sin(theta);
M2=cos(phi)*cos(theta).*sin(ws);
Ra=24*60/pi*0.082*dr.*(M1+M2);
%***step 16:clear sky solar radiation(Rso)
Rso=(0.75+2E-5*alt)*Ra;
%***step 17:calculate the net solar radiation
 %kick out bad data
   SD_cal=SD;      
   index1=find(SD_cal>3000);
   SD_cal(index1)=0;
  % get the parameters for the RA calculation
   n=SD_cal;      % n,sunshine hours of a day,unit:hour
   a=0.18;
   b=0.55;
   % calculate the theory lenth of day(sunrise-sunset)
   N1=-sin(phi)*sin(theta)-0.044;
   N2=cos(phi)*cos(theta);
   N=7.64*acos(N1./N2);
   %calculate net daily solar radiation
   Rs=Rso.*(a+b*n./N);
   %step 18:net shortwave radiation
   alpha=0.23;
   Rns=(1-alpha)*Rs;
   %step 19:net outgoing longwave solar radiation,according to Equation
   R1=((Tmax+273.16).^4+(Tmin+273.16).^4)/2;
   R2=0.34-0.14.*eA.^0.5;
   R3=1.35*Rs./Rso-0.35;
   Rnl=4.093E-09*R1.*R2.*R3;
   %step 20:net radiation
   Rn=Rns-Rnl;
   Rng=0.408*Rn;   % according to the P-M Equation
   %step 21:Radiation Term (ETrad)
   ETrad=DT.*Rng;
   %step 22:Wind Term(ETwind)
   ETwind=PT.*TT.*(eS-eA);
   %step 23:final reference evapotranspiration value(ETo)
   ETo=ETrad+ETwind;
 %%
 % calculate the ET monthly and yearly
 ET_ym=zeros(Ny,12);
 ET_yr=zeros(Ny,1);
 for k1=1:1:Ny
     yr_tp=yr_arr(k1);
     idx_yr=find(year==yr_tp);  %find the ETo matching the selected year
     ET_tp=ETo(idx_yr);
     ET_yr(k1)=sum(ET_tp);
     for k2=1:1:12
         idx_m=find(month(idx_yr)==k2); %find the ETo matching the selected month
         ET_tp1=ET_tp(idx_m);
         ET_ym(k1,k2)=sum(ET_tp1); 
     end
 end
 % save the yearly and monthly ET out to path D:\matlabpractise\dataset\
 dlmwrite('D:\matlabpractise\dataset\luoch53942ET_yr.txt',ET_yr,'delimiter','\t','newline','pc');
 xlswrite('D:\matlabpractise\dataset\luoch53942ET_P_Aridity.xls',ET_yr,'sheet1','B1');
 dlmwrite('D:\matlabpractise\dataset\luoch53942ET_ym.txt',ET_ym,'delimiter','\t','newline','pc');
 xlswrite('D:\matlabpractise\dataset\luoch53942ET_P_Aridity.xls',ET_ym,'sheet2');
%%
% calculate the aridity yearly
   % *****kick out the bad data****
   P_cal=P;      
   index2=find(P_cal>3000);
   P_cal(index2)=0;
   P_yr=zeros(Ny,1);  % yearly precipitation
   P_ym=zeros(Ny,12);  % monthly precipitation year by year
 % calculate the yearly and monthly precipitation  
   for ii=1:1:Ny
       yr_tp1=yr_arr(ii);
       index3=find(year==yr_tp1);
       P_tp=P_cal(index3);
       P_yr(ii)=sum(P_tp);
       for jj=1:1:12
           index4=find(month(index3)==jj);
           P_tpm=P_tp(index4);
           P_ym(ii,jj)=sum(P_tpm);
       end
   end
 %save  yearly and monthly Pricipitation out to D:\matlabpractise\dataset\
 dlmwrite('D:\matlabpractise\dataset\luoch53942P_yr.txt',P_yr,'delimiter','\t','newline','pc');
 xlswrite('D:\matlabpractise\dataset\luoch53942ET_P_Aridity.xls',P_yr,'sheet1','A1');
 dlmwrite('D:\matlabpractise\dataset\luoch53942P_ym.txt',P_ym,'delimiter','\t','newline','pc');
 xlswrite('D:\matlabpractise\dataset\luoch53942ET_P_Aridity.xls',P_ym,'sheet3');
% final step:calculate the aridity
 Aridity_yr=ET_yr./P_yr;
 % save the yearly aridity to D:\matlabpractise\dataset\
 xlswrite('D:\matlabpractise\dataset\luoch53942ET_P_Aridity.xls',Aridity_yr,'sheet1','C1');