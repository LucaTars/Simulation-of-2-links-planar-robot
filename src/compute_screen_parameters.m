% In ONLINE mode, computes screen and figure parameters used for coordinate
% transformation during simulation.

% Inputs: f, the figure

% Outputs: 
% 1,2. screen_width and screen_height: self-explanatory
% 3,4,5,6. dist_left/lower/right/upper/X = distance between the X border of
% the drawing area and the X border of screen

function [screen_width, screen_height, dist_left, dist_lower,...
    dist_right, dist_upper] = compute_screen_parameters(f)

    % Extract figure information.
    try
        f.Units = 'pixels';
        f_pos = f.Position;
    catch err
        
        % If user has closed the figure.
        if (strcmp('MATLAB:class:InvalidHandle',err.identifier))
            exit_with_error('DELETED_FIGURE_ERROR',...
                'The figure (drawing area) must not be closed manually before the end of the running process.');
        end
        
        % Otherwise, it is an unhandled exceptions.
        rethrow(err);
    end

    % Save axes information.
    ax = gca;
    ax.Units = 'pixels';
    ax_pos = ax.Position;

    % Get screen dimensions.
    screen_size = get(0,'screensize');
    screen_width = screen_size(3);
    screen_height = screen_size(4);

    % Compute parameters.
    dist_left = f_pos(1) + ax_pos(1); % distance from left edge of screen and left edge of figure
    dist_lower = f_pos(2) + ax_pos(2); % distance from lower edge of screen and lower edge of figure
    dist_right = screen_width - dist_left - ax_pos(3); % distance from right edge of screen and right edge of figure
    dist_upper = screen_height - dist_lower - ax_pos(4); % distance from upper edge of screen and upper edge of figure

end