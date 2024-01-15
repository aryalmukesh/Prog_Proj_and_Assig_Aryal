%% 
% Name: Mukesh Aryal
% 
% Student ID: 268456

[X,Y]=meshgrid(-2:0.1:2);
Z=X+1i*Y;
f1=(Z-2)./(Z.^2+Z+2);
f=log(abs(f1));
c=angle(f1);
surf(X,Y,f,c);