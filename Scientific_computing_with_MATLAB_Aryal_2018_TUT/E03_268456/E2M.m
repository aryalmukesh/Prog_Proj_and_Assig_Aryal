% Name: Mukesh Aryal
% Student No: 268456
% E02

x=0:0.01:25;
v=0.5:0.5:3;
J=[];
for i=v
    J=[J; besselj(i,x)];    
end
plot(x,J);
xlabel('x'), ylabel('J_{\nu}(x)'), title('Bessel Function');
legend('J_{0.5}','J_1','J_{1.5}','J_2','J_{2.5}','J_{3}','location','best');