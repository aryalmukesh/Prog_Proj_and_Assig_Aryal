% Name: Mukesh Aryal
% Student No: 268456

%6.1
x=0:0.05:2*pi;
h=plot(x,tan(x),x,cot(x))
h(1).YData(abs(h(1).YData)>8)=nan;
h(2).YData(abs(h(2).YData)>8)=nan;

%6.2
hax=gca;
hax.XTick=[0 1/2 3/2 2]*pi;
hax.XTickLabel={'0','\pi/2','3\pi/2','2\pi'};
%6.3
xlabel('x');
ylabel({'$\tan(x)$';'$\cot(x)$'},'Interpreter','latex','FontSize',12,'Rotation',0);
%6.4
set(h(1),'Marker','diamond','MarkerFaceColor','m','MarkerSize',6);
set(h(2),'Marker','>','MarkerFaceColor','c','MarkerSize',7);