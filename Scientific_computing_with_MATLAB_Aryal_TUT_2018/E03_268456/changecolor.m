% Name: Mukesh Aryal
% Student No: 268456

function changecolor(~,~,code)
%CHANGECOLOR changes the color of the plot.
%   The arguement given specifies the color of the plot to be changed into. 
h=gco;
if code == 1
    h.Color='red';
elseif code==2
    h.Color='green';
elseif code==3
    h.Color='k';
elseif code==4
    h.Color='b';
end

