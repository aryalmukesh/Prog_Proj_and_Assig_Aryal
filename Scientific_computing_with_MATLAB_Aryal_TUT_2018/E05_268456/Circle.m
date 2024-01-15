%Name: Mukesh Aryal
%Student ID: 268456

classdef Circle
    % Circle Class for center point [x,y] and positive radius.
    % A circle class with two methods and a constructor. 
    properties
        center(1,2) double {mustBeReal, mustBeFinite}= [0 0];
        radius(1,1) double {mustBePositive, mustBeFinite,...
            mustBeReal} = 1;
    end
    
    methods
        % Constructor. Constructs a new Circle object.
        % The first argument is for ceter point and second for radius
        % Default center point is [0,0] and default radius is '1' if they
        % are not given. 
        function obj = Circle(varargin)
            narginchk(0,2)
            if (nargin == 0)
                obj.center = [0 0];
                obj.radius = 1;
            elseif (nargin == 1)                
                obj.center=varargin{1};                
            elseif (nargin == 2)
                obj.center = varargin{1};
                obj.radius = varargin{2};
            end
        end
        
        function h = plot(obj, varargin)
            c=obj.center; r=obj.radius;
            rectangle('Position',[c(1)-r c(2)-r 2*r 2*r],'Curvature',...
                [1 1],varargin{:});
            axis equal;
        end
        
        function obj=plus(obj_1,obj_2)
            obj = Circle(obj_1.center+obj_2.center, obj_1.radius + obj_2.radius);
        end
                
    end
end
