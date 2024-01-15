%% 
% Name: Mukesh Aryal
% 
% Student ID: 268456

A=[1 -2 3 1; -2 1 -2 -1; 3 -2 1 5; 1 -1 5 3]
b=[10 -10 22 26]'
x1=A\b
[L, U, P]= lu(A)
b_1=P*b
cond_1.LT=true;
y=linsolve(L,b_1,cond_1)
cond_2.UT=true;
x2=linsolve(U,y,cond_2)