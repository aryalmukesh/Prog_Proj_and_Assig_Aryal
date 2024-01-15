classdef DiscreteDistribution
    %
    %
    properties
        P double {mustBeGreaterThanOrEqual(P,0),...
            mustBeLessThanOrEqual(P,1),mustSumTo1(P)}=1       
    end   
  
    
    methods
        % Constructor
        function obj = DiscreteDistribution(p)
            obj.P = p;
        end
        
        function A = random(obj,varargin)
            A = zeros(varargin{:});
            p_sums = cumsum(obj.P);
            for k = 1: numel(A)
                u = rand;
                A(k) = find(u<p_sums,1); 
            end
        end
    end
    
end