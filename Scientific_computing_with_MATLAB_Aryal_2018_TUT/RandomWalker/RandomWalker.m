classdef RandomWalker < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        Exercise3UIFigure       matlab.ui.Figure
        CurrentXEditFieldLabel  matlab.ui.control.Label
        CurrentXEditField       matlab.ui.control.NumericEditField
        CurrentYEditFieldLabel  matlab.ui.control.Label
        CurrentYEditField       matlab.ui.control.NumericEditField
        StartButton             matlab.ui.control.Button
        MarkerSettingsPanel     matlab.ui.container.Panel
        MarkerDropDownLabel     matlab.ui.control.Label
        MarkerDropDown          matlab.ui.control.DropDown
        SizeSpinnerLabel        matlab.ui.control.Label
        SizeSpinner             matlab.ui.control.Spinner
        SetColorButton          matlab.ui.control.Button
        DeltaKnobLabel          matlab.ui.control.Label
        DeltaKnob               matlab.ui.control.Knob
        StepSizeEditFieldLabel  matlab.ui.control.Label
        StepSizeEditField       matlab.ui.control.NumericEditField
        NameMukeshAryalLabel    matlab.ui.control.Label
        ID268456Label           matlab.ui.control.Label
        UIAxes                  matlab.ui.control.UIAxes
    end


    properties (Access = private)        
        Running = 0; % Description, not running at first.
        Hplot;       % Handle to the plot;                
        Delta = 2;
        Step = 0.1;
    end

    methods (Access = private)
    
        function StartAnimation(app)
            x = [0 0];         
            
            ha = app.UIAxes; % Handle to current axes   
            
            app.CurrentXEditField.Value = x(1);
            app.CurrentYEditField.Value = x(2);           
            axis(ha,[-2 2 -2 2]);
                       
            while app.Running == 1
                step = app.Step;
                xx = app.Delta; yy = app.Delta;      % The amount to increase/decrease the axes limits
                
                theta = rand*2*pi; % Generate a random angle
                x = x + step*[cos(theta) sin(theta)]; % Update coordinates
                app.Hplot.XData = x(1); app.Hplot.YData = x(2); % Update plot
                
                % Print the coordinates of the point
                app.CurrentXEditField.Value = x(1);
                app.CurrentYEditField.Value = x(2);
                
                % Check axes limits. We can update XLim and YLim in place
                if x(1) < ha.XLim(1)
                    ha.XLim(1) = ha.XLim(1) - xx;
                elseif x(1) > ha.XLim(2)
                    ha.XLim(2) = ha.XLim(2) + xx;
                end
                
                if x(2) < ha.YLim(1)
                    ha.YLim(1) = ha.YLim(1) - yy;
                elseif x(2) > ha.YLim(2)
                    ha.YLim(2) = ha.YLim(2) + yy;
                end
                
                drawnow % Draw the new plot
            end
            
        end
        
    end



    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.Hplot = plot(app.UIAxes,0,0, 'o', 'MarkerSize', 2 ,...
	       'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k');
            axis(app.UIAxes,[-2 2 -2 2]);
            
            app.MarkerDropDown.Items = {'Circle','Plus','Asterisk','Point','Cross',...
                'Square','Diamond','Triangle','Pentagram','Hexagram'};
            app.MarkerDropDown.ItemsData = {'o','+','*','.','x','s','d','^',...
                'p','h'};
            app.DeltaKnob.MajorTicks = 2:2:20;
            app.DeltaKnob.MinorTicks = 0.5:0.5:20;
            
        end

        % Button pushed function: StartButton
        function StartButtonPushed(app, event)
           if app.Running == 0               
               app.StartButton.Text = 'Stop'; 
               app.Running = 1;
               StartAnimation(app);               
           else
               app.StartButton.Text = 'Start';
               app.Running = 0;               
           end
        end

        % Value changed function: DeltaKnob
        function DeltaKnobValueChanged(app, event)
            value = app.DeltaKnob.Value;
            app.Delta = value;            
        end

        % Value changed function: SizeSpinner
        function SizeSpinnerValueChanged(app, event)
            value = app.SizeSpinner.Value;
            app.Hplot.MarkerSize = value;            
        end

        % Value changed function: MarkerDropDown
        function MarkerDropDownValueChanged(app, event)
            value = app.MarkerDropDown.Value;
            app.Hplot.Marker = value;           
        end

        % Button pushed function: SetColorButton
        function SetColorButtonPushed(app, event)
            app.Hplot.MarkerFaceColor = uisetcolor;            
        end

        % Value changed function: StepSizeEditField
        function StepSizeEditFieldValueChanged(app, event)
            value = app.StepSizeEditField.Value;
            app.Step = value;            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create Exercise3UIFigure and hide until all components are created
            app.Exercise3UIFigure = uifigure('Visible', 'off');
            app.Exercise3UIFigure.Position = [100 100 679 485];
            app.Exercise3UIFigure.Name = 'Exercise 3';

            % Create CurrentXEditFieldLabel
            app.CurrentXEditFieldLabel = uilabel(app.Exercise3UIFigure);
            app.CurrentXEditFieldLabel.HorizontalAlignment = 'right';
            app.CurrentXEditFieldLabel.Position = [32 41 57 22];
            app.CurrentXEditFieldLabel.Text = 'Current X';

            % Create CurrentXEditField
            app.CurrentXEditField = uieditfield(app.Exercise3UIFigure, 'numeric');
            app.CurrentXEditField.Editable = 'off';
            app.CurrentXEditField.Position = [104 41 55 22];

            % Create CurrentYEditFieldLabel
            app.CurrentYEditFieldLabel = uilabel(app.Exercise3UIFigure);
            app.CurrentYEditFieldLabel.HorizontalAlignment = 'right';
            app.CurrentYEditFieldLabel.Position = [198 41 57 22];
            app.CurrentYEditFieldLabel.Text = 'Current Y';

            % Create CurrentYEditField
            app.CurrentYEditField = uieditfield(app.Exercise3UIFigure, 'numeric');
            app.CurrentYEditField.Editable = 'off';
            app.CurrentYEditField.Position = [270 41 57 22];

            % Create StartButton
            app.StartButton = uibutton(app.Exercise3UIFigure, 'push');
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @StartButtonPushed, true);
            app.StartButton.Position = [515 438 100 22];
            app.StartButton.Text = 'Start';

            % Create MarkerSettingsPanel
            app.MarkerSettingsPanel = uipanel(app.Exercise3UIFigure);
            app.MarkerSettingsPanel.TitlePosition = 'centertop';
            app.MarkerSettingsPanel.Title = 'Marker Settings';
            app.MarkerSettingsPanel.BackgroundColor = [0.902 0.902 0.902];
            app.MarkerSettingsPanel.Position = [460 234 178 175];

            % Create MarkerDropDownLabel
            app.MarkerDropDownLabel = uilabel(app.MarkerSettingsPanel);
            app.MarkerDropDownLabel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.MarkerDropDownLabel.HorizontalAlignment = 'right';
            app.MarkerDropDownLabel.Position = [7 119 43 22];
            app.MarkerDropDownLabel.Text = 'Marker';

            % Create MarkerDropDown
            app.MarkerDropDown = uidropdown(app.MarkerSettingsPanel);
            app.MarkerDropDown.ValueChangedFcn = createCallbackFcn(app, @MarkerDropDownValueChanged, true);
            app.MarkerDropDown.BackgroundColor = [1 1 1];
            app.MarkerDropDown.Position = [65 119 90 22];

            % Create SizeSpinnerLabel
            app.SizeSpinnerLabel = uilabel(app.MarkerSettingsPanel);
            app.SizeSpinnerLabel.HorizontalAlignment = 'right';
            app.SizeSpinnerLabel.Position = [25 69 29 22];
            app.SizeSpinnerLabel.Text = 'Size';

            % Create SizeSpinner
            app.SizeSpinner = uispinner(app.MarkerSettingsPanel);
            app.SizeSpinner.Limits = [2 50];
            app.SizeSpinner.ValueDisplayFormat = '%.0f';
            app.SizeSpinner.ValueChangedFcn = createCallbackFcn(app, @SizeSpinnerValueChanged, true);
            app.SizeSpinner.HorizontalAlignment = 'center';
            app.SizeSpinner.Position = [69 69 86 22];
            app.SizeSpinner.Value = 2;

            % Create SetColorButton
            app.SetColorButton = uibutton(app.MarkerSettingsPanel, 'push');
            app.SetColorButton.ButtonPushedFcn = createCallbackFcn(app, @SetColorButtonPushed, true);
            app.SetColorButton.BackgroundColor = [1 1 1];
            app.SetColorButton.Position = [69 22 86 22];
            app.SetColorButton.Text = 'Set Color';

            % Create DeltaKnobLabel
            app.DeltaKnobLabel = uilabel(app.Exercise3UIFigure);
            app.DeltaKnobLabel.HorizontalAlignment = 'center';
            app.DeltaKnobLabel.Position = [528 95 34 22];
            app.DeltaKnobLabel.Text = 'Delta';

            % Create DeltaKnob
            app.DeltaKnob = uiknob(app.Exercise3UIFigure, 'continuous');
            app.DeltaKnob.Limits = [2 20];
            app.DeltaKnob.MajorTicks = [2 4 6 8 10 12 14 16 18 20];
            app.DeltaKnob.ValueChangedFcn = createCallbackFcn(app, @DeltaKnobValueChanged, true);
            app.DeltaKnob.Position = [521 151 49 49];
            app.DeltaKnob.Value = 2;

            % Create StepSizeEditFieldLabel
            app.StepSizeEditFieldLabel = uilabel(app.Exercise3UIFigure);
            app.StepSizeEditFieldLabel.HorizontalAlignment = 'right';
            app.StepSizeEditFieldLabel.Position = [379 41 57 22];
            app.StepSizeEditFieldLabel.Text = 'Step Size';

            % Create StepSizeEditField
            app.StepSizeEditField = uieditfield(app.Exercise3UIFigure, 'numeric');
            app.StepSizeEditField.LowerLimitInclusive = 'off';
            app.StepSizeEditField.Limits = [0 10];
            app.StepSizeEditField.ValueChangedFcn = createCallbackFcn(app, @StepSizeEditFieldValueChanged, true);
            app.StepSizeEditField.HorizontalAlignment = 'center';
            app.StepSizeEditField.Position = [451 41 59 22];
            app.StepSizeEditField.Value = 0.1;

            % Create NameMukeshAryalLabel
            app.NameMukeshAryalLabel = uilabel(app.Exercise3UIFigure);
            app.NameMukeshAryalLabel.Position = [32 448 117 27];
            app.NameMukeshAryalLabel.Text = 'Name: Mukesh Aryal';

            % Create ID268456Label
            app.ID268456Label = uilabel(app.Exercise3UIFigure);
            app.ID268456Label.Position = [179 448 117 27];
            app.ID268456Label.Text = 'ID: 268456';

            % Create UIAxes
            app.UIAxes = uiaxes(app.Exercise3UIFigure);
            title(app.UIAxes, 'Random Walk')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            app.UIAxes.Position = [32 95 410 344];

            % Show the figure after all components are created
            app.Exercise3UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = RandomWalker

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.Exercise3UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.Exercise3UIFigure)
        end
    end
end