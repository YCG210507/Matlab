function [ ET0 ] = fpm(Td,Td_1,n,fi,J,Tmin,Tmax,RHmin,RHmax,Z,uh )
%   UNTITLED Ӧ��������ʽ��������ɢ��matlab����
%   ����Ҫ�Ĳ����ɴ��������ݹ������������
%   д����julming
%   �ʼ���julming@163.com
%% ����������� 
%T=15  %ƽ���¶�
%n=10.5  %ʵ������ʱ��
%fi=46.5*3.14/180  %����γ��
%J=101.0  %J٤������
%Tmin=10.0  %Tmin���������
%Tmax=20.0  %Tmax���������
%RHmin=0.20  %����С���ʪ��
%RHmax=0.50  %��������ʪ��
%Td=T  %�������ڵ�ƽ���¶�
%Td_1=12  %��������ǰһ�յ�ƽ���¶�
%Z=200.0  %���θ߶�
%uh=1.25  %ʵ��ƽ������
%% drt����
T=Td
ea=exp(17.27*T/(T+237.3))
drt=4098*ea/(T+237.3)^2
%% Rn����
sit=0.409*sin(0.0172*J-1.39)
Ws=acos(-tan(fi)*tan(sit))
N=7.46*Ws
clc
ed=0.5*exp(17.27*Tmin/(Tmin+237.3))*RHmin+0.5*exp(17.27*Tmax/(Tmax+237.3))*RHmax
Tkx=Tmax+273.0
Tkn=Tmin+273.0
dr=1+0.033*cos(0.0172*J)
Ra=37.6*dr*(Ws*sin(fi)*sin(sit)+cos(fi)*cos(sit)*Ws)
Rnl=2.45*10^(-9)*(0.9*n/N+0.1)*(0.34-0.14*sqrt(ed))*(Tkx^4+Tkn^4)
Rns=0.77*(0.25+0.5*n/N)*Ra
Rn=Rns-Rnl
%% G����
G=0.38*(Td-Td_1)
%% grm����
P=101.3*((293-0.0065*Z)/293.0)^5.26
lmd=2.501-(2.361*10^(-3))*T
grm=0.00163*P/lmd
clc
grm
%% u2����
h=10  %���߶ȣ�����һ��ȡ10
u2=4.87*uh/log(67.8*h-5.42)
%% ET0����
ET0=(0.408*drt*(Rn-G)+grm*900.0*u2*(ea-ed)/(237.0+T))/(drt+grm*(1+0.34*u2))
end