% Opens figure, sets size and properties, and plots the delimiting circles.
% Inputs: sw (switching parameter), l1, l2 (link lengths).
% Outputs: f = the opened figure.

function f = open_figure(sw, l1, l2)

    % Close previously opened figures if any.
    close all;
    
    % Open new figure.
    f = figure('units','normalized','outerposition',[0 0 1 1]); % full screen
    
    hold on;
    grid on;
    
    axis((l1 + l2) * [-1 1 -1 1]); % all workspace is included in
    
    if (sw > 0)
        axis square;
    end
    
    ax = gca;
    ax.Units = 'pixels';
    
    % Plot delimiting external circle.
    rectangle('Position',(l1 + l2)*[-1,-1,2,2],'Curvature',[1, 1],'EdgeColor','black');
    
    % Plot delimiting internal circle, only if links have different
    % lengths.
    if (l1 ~= l2)
        rectangle('Position',abs(l1 - l2)*[-1,-1,2,2],'Curvature',[1, 1],'EdgeColor','black');
    end
end