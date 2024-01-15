% Mukesh Aryal 268456
% Ujjwal Aryal 268447
% E3

fun1=@(x) log(x)./(x-ones(size(x)));

y3=[];
tol=[];
for k = 1:18
    d=10^(-k);
    tol=[tol;d];
    val=integral(fun1,0,1,'AbsTol',d,'RelTol',d);
    y3=[y3; val];
end

err3=pi^2/6-y3

loglog(tol,abs(err3))