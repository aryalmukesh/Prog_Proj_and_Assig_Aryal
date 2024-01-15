% Mukesh Aryal 268456
% Ujjwal Aryal 268447

function y=sqrt_square(x,n)
%SQRT_SQUARE finds performs squareroots and squares on input x. 
%
% y=sqrt_square(x,n) first takes the square root of x n successive
% times and then again squares the result n successive times. 
assert(all(x>=0), 'Elements cannot be negative.');
assert(round(n)==n,'n must an integer greater than Zero.');

y=x;
for i= 1:n
    y=sqrt(y);
end
for i=1:n
    y=y.^2;
end

    