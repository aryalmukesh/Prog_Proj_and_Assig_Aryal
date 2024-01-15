%% 
% Name: Mukesh Aryal
% 
% Student ID: 268456

[X,Y]=meshgrid(-3.5:0.1:3.5);
R1=2.*X.^2+Y.^2+2;
R2=X.^2+3*Y.^2+3;
Z=sin(R1)+cos(R2);
hf=surf(X,Y,Z,'FaceColor','interp');
colormap('cool'), title('Surf Plot');
camlight;
lightangle(45,0)
material shiny;
view([90,-45])
xlabel('x'),ylabel('y'),zlabel('z');

contour(X,Y,Z);
colormap('parula'), title('Contour Plot');
camlight;
lightangle(40,90)
material shiny;
view([90,90])
xlabel('x'),ylabel('y');