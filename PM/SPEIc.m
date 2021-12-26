
function SPEI=SPEIc(data,scale)
% data include two row,P,PET
pre=data(:,1);
pe=data(:,2);
X=pre-pe;
Dd=[];
for i=1:scale
    Dd=[Dd,X(i:length(X)-scale+i)];
end
D=sum(Dd,2);
D_s=sort(D);
n=length(D);
for i=1:3
    for j=1:n
        ww(j)=((1-(j-0.35)/n)^(i-1))*D_s(j);
    end
    w(i)=sum(ww)/n;
end
belta=(2*w(2)-w(1))/(6*w(2)-w(1)-6*w(3));
alpha=(w(1)-2*w(2))*belta/(gamma(1+1/belta)*gamma(1-1/belta));
gama=w(1)-alpha*gamma(1+1/belta)*gamma(1-1/belta);
for i=1:n
    F=(1+(alpha/(D(i)-gama))^belta)^(-1);
    P=1-F;
    if P<=0.5
        W=sqrt(-2*log(P));
        SPEI(i)=W-(2.515517+0.802853*W+0.010328*W^2)/(1+1.432788*W+0.189269*W^2+0.001308*W^3);
    else
        W=sqrt(-2*log(1-P));
        SPEI(i)=(2.515517+0.802853*W+0.010328*W^2)/(1+1.432788*W+0.189269*W^2+0.001308*W^3)-W;
    end
end
SPEI_k=zeros(1,scale-1);
SPEI=[SPEI_k,SPEI];%Ã¿ÔÂSPEI