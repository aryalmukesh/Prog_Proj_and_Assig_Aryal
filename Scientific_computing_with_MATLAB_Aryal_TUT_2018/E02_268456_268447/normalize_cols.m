% Mukesh Aryal 268456
% Ujjwal Aryal 268447

function A=normalize_cols(A,p)
% NORMALIZE_COLS normalizes a vector or a columns of vetor.
% 
% A=normalize_cols(A,p) normalizes the vector or matrixes and returns a normalized result A.
% p is an optional argument that has a default value 2. 

narginchk(1,2);
if nargin==1
    p=2;
end

B=[];
for i=A
    b=i/(sum(i.^2))^(1/p);
    B=[B b];
end
A=B;
end