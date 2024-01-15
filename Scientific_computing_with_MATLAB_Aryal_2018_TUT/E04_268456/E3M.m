%% 
% Name: Mukesh Aryal
% 
% Student ID: 268456

f=@(x,y,z) exp(z).*cos(x)-cos(y);
fimplicit3(f,[-5,5],'EdgeColor','none')
colormap('autumn'), title('fimplicit3 plot');
camlight;
lightangle(45,75)
material metal;
view([-30,30]);