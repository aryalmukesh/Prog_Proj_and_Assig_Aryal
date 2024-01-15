classdef BasinsOfAttraction_GUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        Project01UIFigure        matlab.ui.Figure
        UITable                  matlab.ui.control.Table
        StatusEditFieldLabel     matlab.ui.control.Label
        StatusEditField          matlab.ui.control.EditField
        GridOnCheckBox           matlab.ui.control.CheckBox
        ResetButton              matlab.ui.control.Button
        SetRootColorButton       matlab.ui.control.Button
        PlotButton               matlab.ui.control.StateButton
        ShowRootsCheckBox        matlab.ui.control.CheckBox
        InputsPanel              matlab.ui.container.Panel
        XminEditFieldLabel       matlab.ui.control.Label
        XminEditField            matlab.ui.control.NumericEditField
        XmaxEditFieldLabel       matlab.ui.control.Label
        XmaxEditField            matlab.ui.control.NumericEditField
        YminEditFieldLabel       matlab.ui.control.Label
        YminEditField            matlab.ui.control.NumericEditField
        YmaxEditFieldLabel       matlab.ui.control.Label
        YmaxEditField            matlab.ui.control.NumericEditField
        mEditFieldLabel          matlab.ui.control.Label
        mEditField               matlab.ui.control.NumericEditField
        nEditFieldLabel          matlab.ui.control.Label
        nEditField               matlab.ui.control.NumericEditField
        ToleranceEditFieldLabel  matlab.ui.control.Label
        ToleranceEditField       matlab.ui.control.NumericEditField
        MEditFieldLabel          matlab.ui.control.Label
        MEditField               matlab.ui.control.NumericEditField
        InsertCoefficientforCorrespondingDegreeLabel  matlab.ui.control.Label
        UIAxes                   matlab.ui.control.UIAxes
    end

    
    properties (Access = private)     
        Coeff; % Stores the Coefficient of polynomials.        
        RootColor; % Stores the color of the roots.        
        Grid; % Integer to inform about grid status, 1 for 'on', 0 for 'off'.
        StopProgram; % Integer with values 1 and 0.
        PlotComplete; % Integer with values 1 and 0.       
        RootVisible % Integer with values 1 and 0.
        RootHandle; % Stores the handle to the root plot.      
        
    end
    %%
    % Student Name and ID
    % Mukesh Aryal, 268456
    % Muhammad Ali Gulzar, 268460
    % Jiaqi Guo, 268459
    % Ujjwal Aryal, 268447
    %%

    methods (Access = private)
        
        function plot_data(app)
        % The function plots the basin of attraction by reading values from 
        % the edit fields. 
            X_min = app.XminEditField.Value;
            X_max = app.XmaxEditField.Value;
            Y_min = app.YminEditField.Value;
            Y_max = app.YmaxEditField.Value;
            m = app.mEditField.Value;
            n = app.nEditField.Value;
            Tolerance = app.ToleranceEditField.Value;
            M = app.MEditField.Value;
            
            cla(app.UIAxes,'reset');
            app.UIAxes.Title.String = 'Basin of Attraction';
            if app.Grid == 1
                    app.UIAxes.XGrid = 'on';                
                    app.UIAxes.YGrid = 'on';
                    app.UIAxes.Layer = 'top';
            end
            axis(app.UIAxes,[X_min X_max Y_min Y_max]);
            
            np = length(app.Coeff)-1;
            dp = polyder(app.Coeff);
            r = roots(app.Coeff);
            
            x = linspace(X_min,X_max,m);
            y = linspace(Y_min,Y_max,n);
            C = zeros(length(y),length(x),'uint8');
            
            cmap = [1 1 1; 1 0 0; 0 1 0; 0 0 1; 0 0 0];
            [X, Y] = meshgrid(x, y);
            Z = X + 1i*Y;
            depth = 100;
            
            for j = 1:depth
                Z = Z - polyval(app.Coeff, Z)./(polyval(dp, Z) + eps);
                for k = 1:np
                    C(abs(Z - r(k)) < Tolerance) = k;
                    drawnow; % To enable the interruption of program by 'Stop' button.
                    if app.StopProgram == 1
                        app.StopProgram = 0;
                        return
                    end
                end
                C(abs(Z) > M) = np + 1;
            end                     
            image(app.UIAxes,x,y,C);
            colormap(app.UIAxes,cmap);
            app.PlotComplete = 1;
            hold(app.UIAxes);
            app.RootHandle = plot(app.UIAxes,r,'o','MarkerFaceColor',app.RootColor);
            if app.RootVisible == 1
                set(app.RootHandle,'Visible','on');
            else 
                set(app.RootHandle,'Visible','off');
            end                        
        end                

        function disable_buttons(app)
        % The function disables all other buttons and fields when plot button 
        % is pressed.       
            app.UITable.Enable = 'off';
            app.GridOnCheckBox.Enable = 'off';
            app.ResetButton.Enable = 'off';            
            app.ShowRootsCheckBox.Enable = 'off';
            app.XminEditField.Enable = 'off';
            app.XmaxEditField.Enable = 'off';
            app.YminEditField.Enable = 'off';
            app.YmaxEditField.Enable = 'off';
            app.mEditField.Enable = 'off';
            app.nEditField.Enable = 'off';
            app.ToleranceEditField.Enable = 'off';
            app.MEditField.Enable = 'off';
            if app.RootVisible == 1
                app.SetRootColorButton.Enable = 'off';
            end
        end
        
        function enable_buttons(app)
        % The function changes required disabled buttons back to enable state
        % once the plot is completed or stopped. 
            app.UITable.Enable = 'on';
            app.GridOnCheckBox.Enable = 'on';
            app.ResetButton.Enable = 'on';            
            app.ShowRootsCheckBox.Enable = 'on';
            app.XminEditField.Enable = 'on';
            app.XmaxEditField.Enable = 'on';
            app.YminEditField.Enable = 'on';
            app.YmaxEditField.Enable = 'on';
            app.mEditField.Enable = 'on';
            app.nEditField.Enable = 'on';
            app.ToleranceEditField.Enable = 'on';
            app.MEditField.Enable = 'on';
            if app.RootVisible == 1
                app.SetRootColorButton.Enable = 'on';
            end
        end
        
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
        % The function to initialize the values of the edit fields, button state
        % and check box. 
            cla(app.UIAxes,'reset');
            app.UIAxes.Title.String = 'Basin of Attraction';           
            app.Coeff = [1 0 0 -1];            
            
            app.StopProgram = 0;
            app.PlotComplete = 0;
            app.RootVisible = 1;           
            app.Grid = 0;         
            
            app.XminEditField.Value = -1.5; 
            app.XmaxEditField.Value = 1.5;
            app.YminEditField.Value = -1.5;
            app.YmaxEditField.Value = 1.5;
            app.ToleranceEditField.Value = 1e-1; 
            
            app.mEditField.Value = 1000;
            app.nEditField.Value = 1000;
            app.MEditField.Value = 1000;                        
           
            axis(app.UIAxes,[-1.5 1.5 -1.5 1.5]);
            
            app.UITable.ColumnName = {'5th','4th','3rd','2nd','1st','0th'};
            app.UITable.ColumnEditable = true;
            app.UITable.Data = [0 0 1 0 0 -1];
            
            app.PlotButton.Value = 0;
            app.GridOnCheckBox.Value = 0;
            app.ShowRootsCheckBox.Value = 1;
            app.RootHandle = 0;
            app.RootColor = 'y';
            
            app.PlotButton.Enable = 'on';
            app.SetRootColorButton.Enable = 'on';           
            
            
            
        end

        % Cell edit callback: UITable
        function UITableCellEdit(app, event)
            value = app.UITable.Data;
            for i = 1 : length(value)
                if value(i)~=0
                    break
                end
            end
            app.Coeff = value(i:end);
            if app.Coeff == 0
                app.PlotButton.Enable = 'off';
                app.StatusEditField.Value = 'Invalid Coefficient';
            else
                app.PlotButton.Enable = 'on';
                app.StatusEditField.Value = 'Coefficient Changed'
            end
            drawnow;                       
        end

        % Value changed function: GridOnCheckBox
        function GridOnCheckBoxValueChanged(app, event)
            app.Grid = app.GridOnCheckBox.Value;            
            if app.Grid == 1                
                app.UIAxes.XGrid = 'on';                
                app.UIAxes.YGrid = 'on';
                app.UIAxes.Layer = 'top';
            else
                app.UIAxes.XGrid = 'off';
                app.UIAxes.YGrid = 'off';
            end
        end

        % Button pushed function: ResetButton
        function ResetButtonPushed(app, event)
            app.Coeff = [0 0 0 0 0 0];
            startupFcn(app);
            app.StatusEditField.Value = '';
        end

        % Button pushed function: SetRootColorButton
        function SetRootColorButtonPushed(app, event)
            if app.RootHandle == 0
                app.RootColor = uisetcolor([1 1 0],'Select a Color');
            else
                app.RootHandle.MarkerFaceColor = uisetcolor([1 1 0],'Select a Color');
            end
        end

        % Value changed function: PlotButton
        function PlotButtonValueChanged(app, event)
            value = app.PlotButton.Value;            
            disable_buttons(app);
            if value == 1
                app.PlotComplete = 0;
                app.PlotButton.Text = 'Stop';
                app.StatusEditField.Value = 'Plot in Progress';
                drawnow;
                plot_data(app);              
                
            elseif value == 0
                app.StopProgram = 1;
                app.PlotButton.Text = 'Plot';                
            end
            if app.PlotComplete == 1
                app.StatusEditField.Value = 'Plot Ready';
                app.PlotButton.Text = 'Plot';                
            else
                app.StatusEditField.Value = 'Plotting Stopped';                
            end            
            app.PlotButton.Value = 0;           
            enable_buttons(app);
            drawnow;
        end

        % Value changed function: ShowRootsCheckBox
        function ShowRootsCheckBoxValueChanged(app, event)
            value = app.ShowRootsCheckBox.Value;
            if value == 1
                app.RootVisible = 1;
                app.SetRootColorButton.Enable = 'on';
                if app.RootHandle ~= 0
                    set(app.RootHandle,'Visible','on');
                end
            else
                app.RootVisible = 0;
                app.SetRootColorButton.Enable = 'off';
                if app.RootHandle ~= 0
                    set(app.RootHandle,'Visible','off');
                end                
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create Project01UIFigure and hide until all components are created
            app.Project01UIFigure = uifigure('Visible', 'off');
            app.Project01UIFigure.Position = [100 100 746 551];
            app.Project01UIFigure.Name = 'Project 01';

            % Create UITable
            app.UITable = uitable(app.Project01UIFigure);
            app.UITable.ColumnName = {'Column 1'; 'Column 2'; 'Column 3'; 'Column 4'};
            app.UITable.RowName = {};
            app.UITable.ColumnEditable = [false true false false];
            app.UITable.CellEditCallback = createCallbackFcn(app, @UITableCellEdit, true);
            app.UITable.Position = [11 58 398 63];

            % Create StatusEditFieldLabel
            app.StatusEditFieldLabel = uilabel(app.Project01UIFigure);
            app.StatusEditFieldLabel.HorizontalAlignment = 'right';
            app.StatusEditFieldLabel.Position = [441 58 40 22];
            app.StatusEditFieldLabel.Text = 'Status';

            % Create StatusEditField
            app.StatusEditField = uieditfield(app.Project01UIFigure, 'text');
            app.StatusEditField.Editable = 'off';
            app.StatusEditField.Position = [496 58 171 22];

            % Create GridOnCheckBox
            app.GridOnCheckBox = uicheckbox(app.Project01UIFigure);
            app.GridOnCheckBox.ValueChangedFcn = createCallbackFcn(app, @GridOnCheckBoxValueChanged, true);
            app.GridOnCheckBox.Text = 'Grid On';
            app.GridOnCheckBox.Position = [601 132 64 22];

            % Create ResetButton
            app.ResetButton = uibutton(app.Project01UIFigure, 'push');
            app.ResetButton.ButtonPushedFcn = createCallbackFcn(app, @ResetButtonPushed, true);
            app.ResetButton.Position = [441 90 100 22];
            app.ResetButton.Text = 'Reset';

            % Create SetRootColorButton
            app.SetRootColorButton = uibutton(app.Project01UIFigure, 'push');
            app.SetRootColorButton.ButtonPushedFcn = createCallbackFcn(app, @SetRootColorButtonPushed, true);
            app.SetRootColorButton.Position = [133 164 100 22];
            app.SetRootColorButton.Text = 'Set Root Color';

            % Create PlotButton
            app.PlotButton = uibutton(app.Project01UIFigure, 'state');
            app.PlotButton.ValueChangedFcn = createCallbackFcn(app, @PlotButtonValueChanged, true);
            app.PlotButton.Text = 'Plot';
            app.PlotButton.Position = [567 90 100 22];

            % Create ShowRootsCheckBox
            app.ShowRootsCheckBox = uicheckbox(app.Project01UIFigure);
            app.ShowRootsCheckBox.ValueChangedFcn = createCallbackFcn(app, @ShowRootsCheckBoxValueChanged, true);
            app.ShowRootsCheckBox.Text = 'Show Roots';
            app.ShowRootsCheckBox.Position = [18 164 87 22];

            % Create InputsPanel
            app.InputsPanel = uipanel(app.Project01UIFigure);
            app.InputsPanel.Title = 'Inputs';
            app.InputsPanel.BackgroundColor = [0.902 0.902 0.902];
            app.InputsPanel.Position = [11 252 234 255];

            % Create XminEditFieldLabel
            app.XminEditFieldLabel = uilabel(app.InputsPanel);
            app.XminEditFieldLabel.HorizontalAlignment = 'right';
            app.XminEditFieldLabel.Position = [17 191 33 22];
            app.XminEditFieldLabel.Text = 'Xmin';

            % Create XminEditField
            app.XminEditField = uieditfield(app.InputsPanel, 'numeric');
            app.XminEditField.Position = [65 191 42 22];
            app.XminEditField.Value = -1.5;

            % Create XmaxEditFieldLabel
            app.XmaxEditFieldLabel = uilabel(app.InputsPanel);
            app.XmaxEditFieldLabel.HorizontalAlignment = 'right';
            app.XmaxEditFieldLabel.Position = [136 191 36 22];
            app.XmaxEditFieldLabel.Text = 'Xmax';

            % Create XmaxEditField
            app.XmaxEditField = uieditfield(app.InputsPanel, 'numeric');
            app.XmaxEditField.Position = [187 191 38 22];
            app.XmaxEditField.Value = 1.5;

            % Create YminEditFieldLabel
            app.YminEditFieldLabel = uilabel(app.InputsPanel);
            app.YminEditFieldLabel.HorizontalAlignment = 'right';
            app.YminEditFieldLabel.Position = [17 154 33 22];
            app.YminEditFieldLabel.Text = 'Ymin';

            % Create YminEditField
            app.YminEditField = uieditfield(app.InputsPanel, 'numeric');
            app.YminEditField.Position = [65 154 42 22];
            app.YminEditField.Value = -1.5;

            % Create YmaxEditFieldLabel
            app.YmaxEditFieldLabel = uilabel(app.InputsPanel);
            app.YmaxEditFieldLabel.HorizontalAlignment = 'right';
            app.YmaxEditFieldLabel.Position = [136 154 36 22];
            app.YmaxEditFieldLabel.Text = 'Ymax';

            % Create YmaxEditField
            app.YmaxEditField = uieditfield(app.InputsPanel, 'numeric');
            app.YmaxEditField.Position = [187 154 38 22];
            app.YmaxEditField.Value = 1.5;

            % Create mEditFieldLabel
            app.mEditFieldLabel = uilabel(app.InputsPanel);
            app.mEditFieldLabel.HorizontalAlignment = 'right';
            app.mEditFieldLabel.Position = [22 116 25 22];
            app.mEditFieldLabel.Text = 'm';

            % Create mEditField
            app.mEditField = uieditfield(app.InputsPanel, 'numeric');
            app.mEditField.Limits = [100 Inf];
            app.mEditField.Position = [62 116 42 22];
            app.mEditField.Value = 1000;

            % Create nEditFieldLabel
            app.nEditFieldLabel = uilabel(app.InputsPanel);
            app.nEditFieldLabel.HorizontalAlignment = 'right';
            app.nEditFieldLabel.Position = [139 116 25 22];
            app.nEditFieldLabel.Text = 'n';

            % Create nEditField
            app.nEditField = uieditfield(app.InputsPanel, 'numeric');
            app.nEditField.Limits = [100 Inf];
            app.nEditField.Position = [179 116 43 22];
            app.nEditField.Value = 1000;

            % Create ToleranceEditFieldLabel
            app.ToleranceEditFieldLabel = uilabel(app.InputsPanel);
            app.ToleranceEditFieldLabel.HorizontalAlignment = 'right';
            app.ToleranceEditFieldLabel.Position = [16 71 58 22];
            app.ToleranceEditFieldLabel.Text = 'Tolerance';

            % Create ToleranceEditField
            app.ToleranceEditField = uieditfield(app.InputsPanel, 'numeric');
            app.ToleranceEditField.Limits = [1e-08 Inf];
            app.ToleranceEditField.Position = [89 71 67 22];
            app.ToleranceEditField.Value = 0.1;

            % Create MEditFieldLabel
            app.MEditFieldLabel = uilabel(app.InputsPanel);
            app.MEditFieldLabel.HorizontalAlignment = 'right';
            app.MEditFieldLabel.Position = [49 34 25 22];
            app.MEditFieldLabel.Text = 'M';

            % Create MEditField
            app.MEditField = uieditfield(app.InputsPanel, 'numeric');
            app.MEditField.Limits = [1 Inf];
            app.MEditField.Position = [89 34 67 22];
            app.MEditField.Value = 1000;

            % Create InsertCoefficientforCorrespondingDegreeLabel
            app.InsertCoefficientforCorrespondingDegreeLabel = uilabel(app.Project01UIFigure);
            app.InsertCoefficientforCorrespondingDegreeLabel.Position = [12 120 239 22];
            app.InsertCoefficientforCorrespondingDegreeLabel.Text = 'Insert Coefficient for Corresponding Degree';

            % Create UIAxes
            app.UIAxes = uiaxes(app.Project01UIFigure);
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            app.UIAxes.Position = [258 164 444 370];

            % Show the figure after all components are created
            app.Project01UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = BasinsOfAttraction_GUI

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.Project01UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.Project01UIFigure)
        end
    end
end