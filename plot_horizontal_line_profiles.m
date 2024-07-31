function plot_horizontal_line_profiles(reshapedMatrix, x0, y0, x_end, incr_step, width_line)
    % Function to plot horizontal line profiles from a 3D image
    % Inputs:
    % reshapedMatrix: the matrix representing the 3D image
    % x0: starting x-coordinate of the line
    % y0: starting y-coordinate of the line
    % x_end: ending x-coordinate of the line
    % incr_step: distance between two lines
    % width_line: number of lines
    % All the inputs should be positive integer with 
    % 1 unit coordinates = 1 pixel
    % 
    % Example usage:
    % reshapedMatrix = your_matrix_data; % Replace with your actual matrix data
    % x0 = 1;
    % y0 = 30;
    % x_end = 64;
    % incr_step = 1;
    % width_line = 5;
    % 
    % plot_horizontal_line_profiles(reshapedMatrix, x0, y0, x_end, incr_step, width_line);


    % Validate the inputs
    if nargin < 6
        error('All input arguments must be provided');
    end

    % Coordinates for the horizontal lines
    coord_x = y0:incr_step:(y0 + width_line - 1); 

    % Extracting the line profile of the region of interest 
    Z = reshapedMatrix';
    
    % Display the 3D image
    figure;
    surfc(Z, 'FaceAlpha', 0.8, 'AlphaData', 0.5, 'FaceColor', 'interp', 'EdgeColor', 'interp');
    view([0, 90]); colormap jet; colorbar;
    set(gca, 'FontName', 'Times', 'FontSize', 15);
    xlabel('x(pixel)'); ylabel('y (pixel)'); zlabel('z (pixel)');
    hold on

    % Initialize LineData for storing intensity values
    LineData = [];
    % Extract horizontal line profiles
    for jj = 1:length(coord_x)
        x_start = x0; x_end = x_end; 
        y_start = coord_x(jj);  
        y_end = y_start;  

        % Extract intensity values along the line
        zData = improfile(Z, [x_start, x_end], [y_start, y_end]); % Extract the line profile

        % Plot the line on the 3D surface
        line([x_start, x_end], [y_start, y_end], [max(Z(:)), max(Z(:))], 'Color', 'k', 'LineWidth', 2);

        % Store the extracted line data
        if isempty(LineData)
            LineData = zeros(length(zData), length(coord_x));
        end
        LineData(:, jj) = zData;
    end

    hold off

    % Calculate the mean of LineData along the second dimension
    yline = mean(LineData, 2);

    % Plot the line profile
    figure;
    plot(1:length(yline), yline, 'r-', 'LineWidth', 2);
    xlabel('x (pixel)');
    ylabel('Intensity');
    xlim([0, length(yline)]);
    set(gca, 'FontName', 'Times', 'FontSize', 18);
   
end
