%% 
% Name: Mukesh Aryal
% 
% Student ID: 268456

ff = @(x1,x2) -cos(x1).*cos(x2).*exp(-(x1-pi).^2-(x2-pi).^2);

[xmin2,fmin2,flag,output] = fminsearch(@(x) ff(x(1),x(2)),[0 0])
[xx1,xx2] = meshgrid(-1:0.1:7);
zz = ff(xx1,xx2);

surf(xx1,xx2,zz);
hold on;
plot3(xmin2(1),xmin2(2),fmin2,'o','MarkerFaceColor','r');
hold off;
contour(xx1,xx2,zz);
hold on;
plot(xmin2(1),xmin2(2),'o','MarkerFaceColor','r');
hold off;

[xmin_21,fmin_21,flag,output] = fminsearch(@(x) ff(x(1),x(2)),[1 -1])
% Not global minimum
[xmin_22,fmin_22,flag,output] = fminsearch(@(x) ff(x(1),x(2)), [4,1])
% Not global minimum