% Name: Mukesh Aryal
% Student No: 268456
% E04

x=@(t) sin(t).*(exp(cos(t))-2*cos(4*t)-(sin(t/12)).^5);
y=@(t) cos(t).*(exp(cos(t))-2*cos(4*t)-(sin(t/12)).^5);

fplot(x,y,[0,2*pi]);
xlabel('x(t)'); ylabel('y(t)'); title('Parametric Curve for t \in [0,2\pi]');