function plot_vertical_line_profiles(reshapedMatrix, x0, y0, y_end, incr_step, width_line)
    % Function to plot vertical line profiles from a 3D image
    % Inputs:
    % reshapedMatrix: the matrix representing the 3D image
    % x0: starting x-coordinate of the line
    % y0: starting y-coordinate of the line
    % y_end: ending y-coordinate of the line
    % incr_step: distance between two lines
    % width_line: number of lines 
    % All the inputs should be positive integers with 
    % 1 unit coordinate = 1 pixel
    % Example usage:
    % reshapedMatrix = your_matrix_data; % Replace with your actual matrix data
    % x0 = 30;
    % y0 = 5;
    % y_end = 60;
    % incr_step = 1;
    % width_line = 5;
    % 
    % plot_vertical_line_profiles(reshapedMatrix, x0, y0, y_end, incr_step, width_line);

    % Validate the inputs
    if nargin < 6
        error('All input arguments must be provided');
    end

    % Define the vertical line coordinates
    coord_y = y0:incr_step:(y0 + width_line - 1); % Vertical line coordinates
    
    % Extracting the line profile of the region of interest 
    Z = reshapedMatrix';
    
    % Display the 3D image
    figure;
    surfc(Z, 'FaceAlpha', 0.8, 'AlphaData', 0.5, 'FaceColor', ...
        'interp', 'EdgeColor', 'interp');
    view([0, 90]);
    colormap jet;
    colorbar;
    set(gca, 'FontName', 'Times', 'FontSize', 15);
    xlabel('x (pixel)');
    ylabel('y (pixel)');
    zlabel('z (pixel)');
    hold on

    % Initialize LineData for storing intensity values
    LineData = [];
    y_start = y0;

    % Extract and plot vertical line profiles
    for jj = 1:length(coord_y)
        
        
        x_start = x0 + coord_y(jj); x_end = x0 + coord_y(jj);
        x_new = x_start + coord_y(jj); % Start x-coordinate
        y_new = y_start; % Start y-coordinate
        
        % Extract intensity values along the line
        zData = improfile(Z, [x_new, x_end], [y_new, y_end]); 
        % Extract the line profile
        
        % Plot the line on the 3D surface
        line([x_start, x_end], [y_new, y_end], [max(Z(:)), max(Z(:))], ...
            'Color', 'k', 'LineWidth', 2);

        % Store the extracted line data
        if isempty(LineData)
            LineData = zeros(length(zData), length(coord_y));
        end
        LineData(:, jj) = zData;
    end
    hold off

    % Calculate the mean of LineData along the second dimension
    yline = mean(LineData, 2);

    V_data = [(1:length(yline))', yline];
    writematrix(V_data, "vertical_lines.txt");

    % Plot the line profile
    figure;
    plot(1:length(yline), yline, 'r-', 'LineWidth', 2);
    xlabel('y (pixel)');
    ylabel('Intensity');
    xlim([0, length(yline)]);
    set(gca, 'FontName', 'Times', 'FontSize', 18);
   
end
