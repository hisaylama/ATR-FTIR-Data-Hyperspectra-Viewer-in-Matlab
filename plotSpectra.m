function plotSpectra(reshapedMatrix)
    % Function to visualize a 3D matrix as a surface plot
    % Inputs:
    % reshapedMatrix: The 3D matrix to be visualized. This function will
    % create a surface plot of the matrix with a color map.

    % Create a new figure window
    figure;

    % Create a surface plot of the transposed matrix with no edge color
    surfc(reshapedMatrix', 'EdgeColor', 'none');
    
    % Set the colormap to 'jet'
    colormap('jet');
    
    % Set color limits for the color map
    % (Assuming edtColorMin and edtColorMax are predefined variables for min and max color limits)
    clim([1, 7]); % Example values, adjust as necessary
    
    % Add a colorbar to indicate the color scale
    colorbar;
    
    % Turn off the grid
    grid off;
    
    % Set the view angle for the plot
    view([0, 90]);
    
    % Set the x and y limits
    xlim([0, 64]);
    ylim([0, 64]);
    
    % Label the x and y axes with LaTeX formatting
    xlabel('x [pixel]', 'Interpreter', 'latex');
    ylabel('y [pixel]', 'Interpreter', 'latex');
    
    % Set the font properties for the axes
    set(gca, 'FontName', 'Times', 'FontSize', 15);
end
