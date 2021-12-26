
syms x y;

a = int(int(x^0.5+y^0.5,y,0,(1-x^0.5)^2),x,0,1)

vpa(a)

