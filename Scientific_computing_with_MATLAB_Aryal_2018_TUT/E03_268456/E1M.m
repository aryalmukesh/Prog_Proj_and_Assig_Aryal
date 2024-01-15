% Name: Mukesh Aryal
% Student No: 268456
%E01
n=1:50;
y=cos((-1).^n.*n)+sin(n.^2); 
plot(n,y), xlabel('n'), ylabel('x_n'), title('General Plot');
stem(n,y), xlabel('n'), ylabel('x_n'), title('Stem plot');
stairs(n,y), xlabel('n'), ylabel('x_n'), title('Stairs Plot');
bar(n,y), xlabel('n'), ylabel('x_n'), title('Bar Plot');