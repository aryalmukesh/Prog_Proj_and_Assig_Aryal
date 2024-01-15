%Name: Mukesh Aryal
%Student ID: 268456

function mustSumTo1(input)
% MUSTSUMTO1 The function checks whether the elements add up to one or not

%   Throws an error if the sum of the elements of the array is not equal 
%   to one;
    result = sum(input);
    n = length(input);
    err = abs(result-1);
    allowed = n * eps;
    if (err > allowed)
        error(['The sum of elements must be 1.']);
    end
end

