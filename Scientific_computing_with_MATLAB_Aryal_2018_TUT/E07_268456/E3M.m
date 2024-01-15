%% 
% Name: Mukesh Aryal
% 
% Student ID: 268456

A = [0 1; -1 -0.03];
f = @(t,y) A*[y(1)^3; y(2)] + [0; 5.5*sin(t)];

[t,y] = ode45(f,[0,200],[2.5, 0]);
plot3(y(:,1),y(:,2),t);
xlabel('y_1'); ylabel('y_2'), zlabel('t');
title('Ueda Oscillator');
subplot(2,1,1);
plot(t,y(:,1));
ylabel('y_1');
title('y_1 against time')
subplot(2,1,2);
plot(t,y(:,2));
ylabel('y_2')
title('y_2 against time');
xlabel('t');
suptitle('Duffing Equation Components');