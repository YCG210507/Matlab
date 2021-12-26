function [ ET0 ] = fpm(Td,Td_1,n,fi,J,Tmin,Tmax,RHmin,RHmax,Z,uh )
%   UNTITLED 应用彭曼公式计算日蒸散量matlab程序
%   所需要的参数可从气象数据共享服务网下载
%   写作：julming
%   邮件：julming@163.com
%% 输入参数定义 
%T=15  %平均温度
%n=10.5  %实际日照时数
%fi=46.5*3.14/180  %地理纬度
%J=101.0  %J伽利略日
%Tmin=10.0  %Tmin日最低气温
%Tmax=20.0  %Tmax日最高气温
%RHmin=0.20  %日最小相对湿度
%RHmax=0.50  %日最大相对湿度
%Td=T  %计算日期的平均温度
%Td_1=12  %计算日期前一日的平均温度
%Z=200.0  %海拔高度
%uh=1.25  %实际平均风速
%% drt计算
T=Td
ea=exp(17.27*T/(T+237.3))
drt=4098*ea/(T+237.3)^2
%% Rn计算
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
%% G计算
G=0.38*(Td-Td_1)
%% grm计算
P=101.3*((293-0.0065*Z)/293.0)^5.26
lmd=2.501-(2.361*10^(-3))*T
grm=0.00163*P/lmd
clc
grm
%% u2计算
h=10  %风标高度，高内一般取10
u2=4.87*uh/log(67.8*h-5.42)
%% ET0计算
ET0=(0.408*drt*(Rn-G)+grm*900.0*u2*(ea-ed)/(237.0+T))/(drt+grm*(1+0.34*u2))
end