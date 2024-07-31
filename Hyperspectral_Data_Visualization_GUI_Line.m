function Hyperspectral_Data_Visualization_GUI_Line()
 
    % Main figure window
    fig = uifigure('Name', 'FTIR analysis', 'Position', [100, 100, 700, 900]);

    % Button to load data
    btnLoadData = uibutton(fig, 'push', 'Text', 'Load data (.*mat)', 'Position', [20, 850, 110, 30], ...
                           'ButtonPushedFcn', @(btnLoadData, event) loadDataCallback());

    % Button to plot intensity wavelength
    btnPlotIntensity = uibutton(fig, 'push', 'Text', 'Intensity profile', 'Position', [140, 850, 100, 30], ...
                                'ButtonPushedFcn', @(btnPlotIntensity, event) plotIntensityCallback());

    % Button to visualize colormap
    btnVisualize = uibutton(fig, 'push', 'Text', 'Color map', 'Position', [420, 850, 100, 30], ...
                            'ButtonPushedFcn', @(btnVisualize, event) visualizeCallback());

    % Input fields for target wavelengths
    lblWavelength = uilabel(fig, 'Position', [20, 750, 150, 30], 'Text', '$\lambda$ = wavelength (in nm)', 'Interpreter','latex');

    lblTargetL = uilabel(fig, 'Position', [250,850, 100, 30], 'Text', 'low-$\lambda$:', 'Interpreter','latex');
    edtTargetL = uieditfield(fig, 'numeric', 'Position', [300, 850, 100, 30], 'Value', 1680);
    lblTargetR = uilabel(fig, 'Position', [250, 810, 100, 30], 'Text', 'high-$\lambda$:', 'Interpreter','latex');
    edtTargetR = uieditfield(fig, 'numeric', 'Position', [300, 810, 100, 30], 'Value', 1790);

    % Input fields for colorbar limits
    lblColorMin = uilabel(fig, 'Position', [580, 850, 100, 30], 'Text', 'Color Min:');
    edtColorMin = uieditfield(fig, 'numeric', 'Position', [640, 850, 50, 30], 'Value', 1);
    lblColorMax = uilabel(fig, 'Position', [580, 810, 100, 30], 'Text', 'Color Max:');
    edtColorMax = uieditfield(fig, 'numeric', 'Position', [640, 810, 50, 30], 'Value', 7);

    % Button to update the color limits
    btnUpdateColor = uibutton(fig, 'push', 'Text', 'Update Color Limits', 'Position', [560, 750, 130, 30], ...
                              'ButtonPushedFcn', @(btnUpdateColor, event) updateColorLimits());

    % Axes to display the intensity profile
    axIntensity = uiaxes(fig, 'Position', [50, 450, 650, 250]);

    % Axes to display the colormap visualization
    axColormap = uiaxes(fig, 'Position', [50, 50, 650, 400]);

    % Buttons for horizontal and vertical line profiles
    btnHorizontalProfile = uibutton(fig, 'push', 'Text', 'Horizontal Profile', 'Position', [160, 750, 130, 30], ...
                                    'ButtonPushedFcn', @(btnHorizontalProfile, event) horizontalProfileCallback());
    btnVerticalProfile = uibutton(fig, 'push', 'Text', 'Vertical Profile', 'Position', [300, 750, 130, 30], ...
                                  'ButtonPushedFcn', @(btnVerticalProfile, event) verticalProfileCallback());
    btnSaveFig = uibutton(fig, 'push', 'Text', 'Save Fig.', 'Position', [550, 10, 130, 30], ...
                                  'ButtonPushedFcn', @(btnSaveFig, event) SaveFigCallback()); 
    
    % Input fields for line profile parameters
    lblX0 = uilabel(fig, 'Position', [20, 715, 50, 30], 'Text', 'x0:');
    edtX0 = uieditfield(fig, 'numeric', 'Position', [60, 715, 50, 30], 'Value', 30);
    lblXEnd = uilabel(fig, 'Position',[120, 715, 50, 30], 'Text', 'xEnd:');
    edtXEnd = uieditfield(fig, 'numeric', 'Position',[160, 715, 50, 30], 'Value', 64);
    lblY0 = uilabel(fig, 'Position', [220, 715, 50, 30], 'Text', 'y0:');
    edtY0 = uieditfield(fig, 'numeric', 'Position',  [270, 715, 50, 30], 'Value', 5);
    lblYEnd = uilabel(fig, 'Position', [330, 715, 50, 30], 'Text', 'yEnd:');
    edtYEnd = uieditfield(fig, 'numeric', 'Position', [380, 715, 50, 30], 'Value', 60);
    lblIncrStep = uilabel(fig, 'Position', [440, 715, 70, 30], 'Text', 'Incr Step:');
    edtIncrStep = uieditfield(fig, 'numeric', 'Position', [510, 715, 50, 30], 'Value', 1);
    lblWidthLine = uilabel(fig, 'Position', [570, 715, 70, 30], 'Text', 'No. of Line:');
    edtWidthLine = uieditfield(fig, 'numeric', 'Position', [640, 715, 50, 30], 'Value', 5);

    % Data variables
    data = struct();
    data.wavelength = [];
    data.intensity = [];
    reshapedMatrix = [];

    % Nested callback function to load data
    function loadDataCallback()
        [file, path] = uigetfile('*.mat', 'Select the MAT-file');
        if isequal(file, 0)
            return;
        end
        loadedData = load(fullfile(path, file));
        data.wavelength = flip(loadedData.AB(:, 1), 1);
        data.intensity = flip(loadedData.AB(:, 2:end), 1);
        uialert(fig, 'Data loaded successfully', 'Success');
        
        % Update the intensity profile plot automatically
        plotIntensityCallback();
    end

    % Nested callback function to plot intensity
    function plotIntensityCallback()
        if isempty(data.wavelength) || isempty(data.intensity)
            uialert(fig, 'Please load data first', 'Error');
            return;
        end
        plot(axIntensity, data.wavelength, data.intensity(:, 1), 'b-', 'LineWidth', 2);
        xlabel(axIntensity, 'Wavelength [nm]', 'Interpreter', 'latex');
        ylabel(axIntensity, 'Intensity [a.u]', 'Interpreter', 'latex');
        set(axIntensity, 'FontName', 'Times');
    end

    % Nested callback function to visualize reshaped matrix (color spectrogram)
    function visualizeCallback()
        if isempty(data.wavelength) || isempty(data.intensity)
            uialert(fig, 'Please load data first', 'Error');
            return;
        end

        target_l = edtTargetL.Value;
        target_r = edtTargetR.Value;

        [~, l_index] = min(abs(data.wavelength - target_l));
        [~, r_index] = min(abs(data.wavelength - target_r));
        
        % Integration over the given range
        area_under_curve = zeros(1, size(data.intensity, 2));
        for i = 1:size(data.intensity, 2)
            w = data.wavelength(l_index:r_index);
            slope = (data.intensity(r_index, i) - data.intensity(l_index, i)) / (w(end) - w(1));
            dely = slope .* (w - w(1));
            I_act = data.intensity(l_index:r_index, i) - (data.intensity(l_index, i) + dely);
            area_under_curve(i) = trapz(w, I_act);
        end

        reshapedMatrix = reshape(area_under_curve, [64, 64]);

        surfc(axColormap, reshapedMatrix', 'EdgeColor', 'none');
        colormap(axColormap, 'jet');
        clim(axColormap, [edtColorMin.Value, edtColorMax.Value]);
        colorbar(axColormap);
        grid(axColormap, 'off');
        view(axColormap, [0, 90]);
        xlim(axColormap, [0, 64]);
        ylim(axColormap, [0, 64]);
        xlabel(axColormap, 'x [pixel]', 'Interpreter', 'latex');
        ylabel(axColormap, 'y [pixel]', 'Interpreter', 'latex');
        set(axColormap, 'FontName', 'Times', 'FontSize', 13);
    end

    % Nested callback function to update color limits
    function updateColorLimits()
        clim(axColormap, [edtColorMin.Value, edtColorMax.Value]);
    end

    function SaveFigCallback()

        if isempty(reshapedMatrix)
            uialert(fig, 'Please visualize the colormap first', 'Error');
            return;
        end
        
        plotSpectra(reshapedMatrix)
    end

    % Nested callback function to plot horizontal line profile
    function horizontalProfileCallback()
        if isempty(reshapedMatrix)
            uialert(fig, 'Please visualize the colormap first', 'Error');
            return;
        end

        x0 = edtX0.Value;
        y0 = edtY0.Value;
        x_end = edtXEnd.Value;
        incr_step = edtIncrStep.Value;
        width_line = edtWidthLine.Value;

        plot_horizontal_line_profiles(reshapedMatrix, x0, y0, x_end, incr_step, width_line);
    end

    % Nested callback function to plot vertical line profile
    function verticalProfileCallback()
        if isempty(reshapedMatrix)
            uialert(fig, 'Please visualize the colormap first', 'Error');
            return;
        end

        x0 = edtX0.Value;
        y0 = edtY0.Value;
        y_end = edtYEnd.Value;
        incr_step = edtIncrStep.Value;
        width_line = edtWidthLine.Value;

        plot_vertical_line_profiles(reshapedMatrix, x0, y0, y_end, incr_step, width_line);
    end

    saveas(fig, "Hyperspectral_Viewer.fig")
end
