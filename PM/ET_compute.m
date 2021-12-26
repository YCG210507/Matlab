function ET1=ET_compute(latitude,height,st,RHU,WIN,SSD,TEM_ave,TEM_max,TEM_min)
%latitude ��ʾγ�ȣ�height ��ʾ���Σ�RHU���ʪ�ȣ�WINƽ�����٣�SSD����ʱ����TEM_aveƽ���¶ȣ�TEM_max������¶ȣ�TEM_min������¶�
%��������ΪԪ��������ʽ������Ԫ������ĺô������Դ���������ݣ�����ÿһ����365d-366d���ݡ�
%st��ʾ��ʼʱ�䣬��Ϊ��������ȱ����������ֱ��д1
%���γ���10��γ��ת�ɻ���
for t=1:length(height)
    height{t,1}=height{t,1}/10;   %���γ���10
    temp1=num2str(latitude{t,1});
    for m=1:length(temp1)   %γ�ȴӶȷ�ת�ɻ���
        a=str2num(temp1(m,1:2));
        b=str2num(temp1(m,3:end));
        latitude{t,1}(m,1)=deg2rad(a+b/60);
    end
end
fb=10;  %���߶�10m
%ET0����
T=length(RHU);  %���г���
for t=st:T
    for J=1:length(RHU{t,1})
        delta{t,1}(J,1)=0.409*sin(2*pi/365*J-1.39);    %�����
        Ws{t,1}(J,1)=acos(-tan(latitude{t,1}(J,1))*tan(delta{t,1}(J,1)));  %���ն�����
        dr{t,1}(J,1)=1+0.033*cos(2*pi/365*J);   %�յ���Ծ���
        Ra{t,1}(J,1)=37.6*dr{t,1}(J,1)*(Ws{t,1}(J,1)*sin(latitude{t,1}(J,1))*sin(delta{t,1}(J,1))+cos(latitude{t,1}(J,1))*cos(delta{t,1}(J,1))*sin(Ws{t,1}(J,1))); %������Ե̫������Ra
        N{t,1}(J,1)=24/pi*Ws{t,1}(J,1);   %������������
        Rs{t,1}(J,1)=(0.25+0.5*SSD{t,1}(J,1)/N{t,1}(J,1))*Ra{t,1}(J,1); %�ر�̫������ͨ��Rs
        Rns{t,1}(J,1)=0.77*Rs{t,1}(J,1); %���̲�����
        Rso{t,1}(J,1)=(0.75+2/10^5*height{t,1}(J,1))*Ra{t,1}(J,1);    %��ն̲�����
        eTmax{t,1}(J,1)=0.6108*exp(17.27*TEM_max{t,1}(J,1)/(237.3+TEM_max{t,1}(J,1))); %����¶ȱ���ˮ��ѹ
        eTmin{t,1}(J,1)=0.6108*exp(17.27*TEM_min{t,1}(J,1)/(237.3+TEM_min{t,1}(J,1))); %����¶ȱ���ˮ��ѹ
        es{t,1}(J,1)=0.5*(eTmax{t,1}(J,1)+eTmin{t,1}(J,1));    %ƽ������ˮ��ѹ
        ea{t,1}(J,1)=RHU{t,1}(J,1)/100*es{t,1}(J,1); %ʵ��ˮ��ѹ
        Rnl{t,1}(J,1)=4.903*10^(-9)*((273.16+TEM_max{t,1}(J,1))^4+(273.16+TEM_min{t,1}(J,1))^4)/2*(0.34-0.14*sqrt(ea{t,1}(J,1)))*(1.35*Rs{t,1}(J,1)/Rso{t,1}(J,1)-0.35);  %����������
        Rn{t,1}(J,1)=Rns{t,1}(J,1)-Rnl{t,1}(J,1);  %������ͨ��
        P{t,1}(J,1)=101.3*((293-0.0065*height{t,1}(J,1))/293)^5.26;    %���ش���ѹ
        lamda{t,1}(J,1)=2.501-(2.361*10^(-3))*TEM_ave{t,1}(J,1);    %ˮ������Ǳ��
        gama{t,1}(J,1)=0.00163*P{t,1}(J,1)/lamda{t,1}(J,1);   %��ʪ�¶ȼƳ�����
        Delta{t,1}(J,1)=4098*(0.6108*exp(17.27*TEM_ave{t,1}(J,1)/(237.3+TEM_ave{t,1}(J,1))))/(TEM_ave{t,1}(J,1)+237.3)^2; %��
        u{t,1}(J,1)=WIN{t,1}(J,1)*(4.87/log(67.8*fb-5.42));  %2m����
        G{t,1}(J,1)=0;  %������ͨ��ȡ0
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