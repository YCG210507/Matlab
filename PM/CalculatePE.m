%   �������������ʽ��
%   tasmax�����������
%   tasmin�����������
%   rhs���������ʪ��
%   wind0�����ط���
%   rsds���̲�����
%   lat��γ��
%   alt������
%   time��ʱ��
function PE = CalculatePE(tasmax, tasmin, rhs, wind, rsds, lat, alt, time)
    % inputs and units changing
    %Tav=tas-273.16;  % tas (surface air temp,K) (1K = (��C) + 273.16)
    Tmax=tasmax-273.16; % tasmax
    Tmin=tasmin-273.16; % tasmin
    rh=rhs/100;      % rhs (near-surface relative humidity, %)
    %prec=pr*86400;  % pr (precipitation, kg/m2/s) (*86400=mm/day)
    wind0=wind;        %  wind(near-sruface wind speed at 10m,m/s) 
    Rs=rsds * 0.0864;    % rsds (shortwave downwelling, w/m2) (0.0864,convert from W/m2 to MJ/m2/day);
    %Rlds=rlds * 0.0864;  % rlds (longwave downwelling, w/m2) (0.0864,convert from W/m2 to MJ/m2/day);
    %alt=0;  %altitude (m)
    %lat=0;  %latitude (degree)
    %DOY=1;  %  DOY 1 to 365(366)
    %time=2013-3-2;  % time convert to DOY  by the followed:
    % time to DOY: matlab time vector (midpoint) (HAS TO BE A COLUMN VECTOR!)
    %dt = median(diff(time));
    %time_vec = datevec(time);   
    %tmean 
    T=(Tmax+Tmin)/2.0;       
    %es,ea  ����ˮ��ѹ��ʵ��ˮ��ѹ�ļ���
    etx=0.6108*exp((17.27*Tmax)./(Tmax+237.3));
    etn=0.6108*exp((17.27*Tmin)./(Tmin+237.3));
    es=(etx+etn)/2.0;
    ea=es.*rh;    
    %slope����ˮ��ѹ����б�ʼ���
    slope=(4098*0.6108*exp((17.27*T)./(T+237.3)))./((T+237.3).^2);
    %Rn���������
    % Ra: extraterrestrial radiation
    % dr = inverse relative distance Earth-Sun (correction for eccentricity of Earth's orbit around the sun) 
    % delta = Declination of the sun above the celestial equator (radians)    
    %����DOY
    DOY = ceil( datenum(time,'yyyy/mm/dd') - datenum(year(time),1,1) )+1;
    %�յ�ƽ������dr
    dr=1+0.033*cos(2*pi/365*DOY);
    %̫����ƫ��delta
    delta=0.408*sin(2*pi/365*DOY-1.39);
    %�ճ�ʱ��ws
    lat1=lat*pi/180.0; % degree to rad
    ws=acos(-tan(lat1).*tan(delta));
    %�յ��������Ra
    Ra=(24*60*0.082/pi)*dr.*(ws.*sin(lat1).*sin(delta)+cos(lat1).*cos(delta).*sin(ws)); %FAO daily; 0.082 ̫������
    %���̫������Rso
    Rso=(0.75+2e-5*alt).*Ra; % alt: station altitude above sea level [m]
    %̫���������̲�������Rns
    Rns=(1-0.23)*Rs;%Rs������
    %����������Rnl
    Rnl =(4.903e-9/2)* (0.34-0.14*sqrt(ea)).*(1.35*Rs./Rso - 0.35).*((Tmax+273.16).^4+(Tmin+273.16).^4) ;  %4.903e-9  Stefan-Boltzmann���� 
    %������Rn
    Rn=Rns-Rnl;
    %������ͨ��
    G=0;  % assume daily G=0
    %U2�Ļ���
    U2=4.87/log(67.8*10-5.42)*wind0;
    %psy��ʪ��������j
    %psy=0.000665*pa;
    %pa����ѹǿ
    pa=101.3*(((293-0.0065*alt)/293).^5.26);
    psy=0.000665*pa;
    %lamda=2.501-0.002361.*T; %����Ǳ�� MJ/kg
    %psy=0.00101305.*pa/0.622./lamda;
    %  PET     
    PE=(0.408*slope.*(Rn-G)+900*psy.*U2.*(es-ea)./(T+273))./(slope+psy.*(1+0.34*U2));
    PE(PE<0)=1e-6;  %daily_ETo��С����ĸ�ֵΪ��Сֵ
end