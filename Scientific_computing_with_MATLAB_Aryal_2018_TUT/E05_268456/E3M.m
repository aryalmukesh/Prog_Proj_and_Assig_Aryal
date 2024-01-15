%% 
% Name: Mukesh Aryal
% 
% Student ID: 268456

c1 = Circle

c2 = Circle([1 1])
c3 = Circle([5 4],4)
c4 = Circle([5 7],11)
c5 = c3 + c4

try
    Circle([3 2 8], 3)
catch me
    getReport(me,'basic')
end

try
    Circle([1 2],-1)
catch me
    getReport(me,'basic')
end