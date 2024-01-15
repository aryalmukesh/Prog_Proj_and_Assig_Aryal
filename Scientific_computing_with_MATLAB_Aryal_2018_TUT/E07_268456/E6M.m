%% 
% Name: Mukesh Aryal
% 
% Student ID: 268456

f = @(x,y) (x-2).^2 + (y-1).^2;

fcon = @(x) deal(x(1).^2-x(2), x(1)+x(2).^2);

options = optimset('Display','iter')

[xmin3,fmin3,flag,output] = fmincon(@(x) f(x(1),x(2)),[0 0],[],[],...
    [],[],[],[],fcon,options)
fsurf(f);
hold on;
plot3(xmin3(1),xmin3(2),fmin3,'o','MarkerFaceColor','r');
view(30,60);