% Name: Mukesh Aryal
% Student No: 268456
% E05

func=@(x,y) (x.^4-x.^2.*y + y.^3);
hf=figure('Visible','on');
cmh=uicontextmenu;
uimenu(cmh,'Text','Red','MenuSelectedFcn',{@changecolor,1});
uimenu(cmh,'Text','Green','MenuSelectedFcn',{@changecolor,2});
uimenu(cmh,'Text','Black','MenuSelectedFcn',{@changecolor,3});
uimenu(cmh,'Text','Blue','MenuSelectedFcn',{@changecolor,4});
h=fimplicit(func,[-1 1 -1 0.4],'UIContextMenu',cmh)
xlabel('x'), ylabel('y'), title('Bow Curve')