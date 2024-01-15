%% 
% Name: Mukesh Aryal
% 
% Student ID: 268456

u=linspace(0,2*pi,50);
v=linspace(-1,1,40);
[U,V]=meshgrid(u,v);

X=(1+0.5.*V.*cos(U./2)).*cos(U);
Y=(1+0.5.*V.*cos(U./2)).*sin(U);
Z=0.5.*V.*sin(U./2);

surf(X,Y,Z,'EdgeColor','none');
colormap('colorcube'), title('Möbius Strip');
camlight;
lightangle(45,75)
material metal;
view([90,75]);