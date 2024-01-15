%% 
% Name: Mukesh Aryal
% 
% Student ID: 268456

p = [0.3,0.1,0.2,0.1,0.3];
try
    obj=DiscreteDistribution(p)
catch me
    getReport(me,'basic')
end
rand_1 = random(obj,5)
rand_2 = random(obj,5,11)
rand_3 = random(obj,[11 34])
rand_4 = random(obj,[1,200]);
histogram(rand_4)