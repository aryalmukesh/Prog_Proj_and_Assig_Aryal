%% 
% Name: Mukesh Aryal
% 
% Student ID: 268456

f = @(x) sin(x).^3;
xmax1 = fminbnd(@(x) -f(x),0,2*pi)
fmax1 = f(xmax1)
fplot(f,[0,2*pi]);
hold on;
plot(xmax1,fmax1,'o','MarkerFaceColor','m');
hold off;