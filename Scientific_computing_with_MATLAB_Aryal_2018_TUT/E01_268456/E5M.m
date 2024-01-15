% Name = Mukesh Aryal
% Student No.= 268456

A=rosser
B=A(:);
i1=find(B>0);
P=B(i1);
t5pos=median(P)

i2=find(B<0);
N=B(i2);
t5neg=median(N)