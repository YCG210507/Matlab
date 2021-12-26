function ET1=ET_compute(latitude,height,st,RHU,WIN,SSD,TEM_ave,TEM_max,TEM_min)
%latitude 表示纬度；height 表示海拔；RHU相对湿度；WIN平均风速；SSD日照时数；TEM_ave平均温度；TEM_max日最大温度；TEM_min日最低温度
%导入数据为元胞数组形式。采用元胞数组的好处，可以存入多年数据，其中每一年有365d-366d数据。
%st表示开始时间，因为存在数据缺测情况，最好直接写1
%海拔除以10，纬度转成弧度
for t=1:length(height)
    height{t,1}=height{t,1}/10;   %海拔除以10
    temp1=num2str(latitude{t,1});
    for m=1:length(temp1)   %纬度从度分转成弧度
        a=str2num(temp1(m,1:2));
        b=str2num(temp1(m,3:end));
        latitude{t,1}(m,1)=deg2rad(a+b/60);
    end
end
fb=10;  %风标高度10m
%ET0计算
T=length(RHU);  %序列长度
for t=st:T
    for J=1:length(RHU{t,1})
        delta{t,1}(J,1)=0.409*sin(2*pi/365*J-1.39);    %日倾角
        Ws{t,1}(J,1)=acos(-tan(latitude{t,1}(J,1))*tan(delta{t,1}(J,1)));  %日照对数角
        dr{t,1}(J,1)=1+0.033*cos(2*pi/365*J);   %日地相对距离
        Ra{t,1}(J,1)=37.6*dr{t,1}(J,1)*(Ws{t,1}(J,1)*sin(latitude{t,1}(J,1))*sin(delta{t,1}(J,1))+cos(latitude{t,1}(J,1))*cos(delta{t,1}(J,1))*sin(Ws{t,1}(J,1))); %大气边缘太阳辐射Ra
        N{t,1}(J,1)=24/pi*Ws{t,1}(J,1);   %最大可能日照数
        Rs{t,1}(J,1)=(0.25+0.5*SSD{t,1}(J,1)/N{t,1}(J,1))*Ra{t,1}(J,1); %地表太阳辐射通量Rs
        Rns{t,1}(J,1)=0.77*Rs{t,1}(J,1); %净短波辐射
        Rso{t,1}(J,1)=(0.75+2/10^5*height{t,1}(J,1))*Ra{t,1}(J,1);    %晴空短波辐射
        eTmax{t,1}(J,1)=0.6108*exp(17.27*TEM_max{t,1}(J,1)/(237.3+TEM_max{t,1}(J,1))); %最高温度饱和水汽压
        eTmin{t,1}(J,1)=0.6108*exp(17.27*TEM_min{t,1}(J,1)/(237.3+TEM_min{t,1}(J,1))); %最低温度饱和水汽压
        es{t,1}(J,1)=0.5*(eTmax{t,1}(J,1)+eTmin{t,1}(J,1));    %平均饱和水汽压
        ea{t,1}(J,1)=RHU{t,1}(J,1)/100*es{t,1}(J,1); %实际水汽压
        Rnl{t,1}(J,1)=4.903*10^(-9)*((273.16+TEM_max{t,1}(J,1))^4+(273.16+TEM_min{t,1}(J,1))^4)/2*(0.34-0.14*sqrt(ea{t,1}(J,1)))*(1.35*Rs{t,1}(J,1)/Rso{t,1}(J,1)-0.35);  %净长波辐射
        Rn{t,1}(J,1)=Rns{t,1}(J,1)-Rnl{t,1}(J,1);  %净辐射通量
        P{t,1}(J,1)=101.3*((293-0.0065*height{t,1}(J,1))/293)^5.26;    %当地大气压
        lamda{t,1}(J,1)=2.501-(2.361*10^(-3))*TEM_ave{t,1}(J,1);    %水的汽化潜热
        gama{t,1}(J,1)=0.00163*P{t,1}(J,1)/lamda{t,1}(J,1);   %干湿温度计常数γ
        Delta{t,1}(J,1)=4098*(0.6108*exp(17.27*TEM_ave{t,1}(J,1)/(237.3+TEM_ave{t,1}(J,1))))/(TEM_ave{t,1}(J,1)+237.3)^2; %Δ
        u{t,1}(J,1)=WIN{t,1}(J,1)*(4.87/log(67.8*fb-5.42));  %2m风速
        G{t,1}(J,1)=0;  %土壤热通量取0
        ET{t,1}(J,1)=(0.408*Delta{t,1}(J,1)*( Rn{t,1}(J,1)- G{t,1}(J,1))+gama{t,1}(J,1)*900/(TEM_ave{t,1}(J,1)+273)*u{t,1}(J,1)*(es{t,1}(J,1)-ea{t,1}(J,1)))/(Delta{t,1}(J,1)+gama{t,1}(J,1)*(1+0.34*u{t,1}(J,1)));
    end
end
for t=st:T
    ET1(t,1)=nansum(ET{t,1});
    if (ET1(t,1)==0)
        ET1(t,1)=NaN;
    else
        ET1(t,1)=nanmean(ET{t,1})*length(ET{t,1});
    end
end