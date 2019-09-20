function plot_robot_position(in)
    
    clock = in(1); ended = in(2);
    l1 = in(3); l2 = in(4);
    plot_mode = in(5);
    sw = in(11);
    
    % If plot_mode is zero, don't plot.
    if not (plot_mode)
        return;
        
    elseif (not (ishandle(1)))
        % If must plot but figure has been deleted.
        if not (ended)
            
            if (not (clock == 0)) % if the figure wasn't deleted
                                  % between preparation and simulation
                warning('It is recommended not to close the figure during the simulation.');
            end
            
            % Re-open figure.
            open_figure(sw, l1, l2);
        end
    end

    % Store inputs in meaningfully named variables.
    q1 = in(6); q2 = in(7);
    q1i = in(8); q2i = in(9);
    starting_time = in(10);
    x = in(12); y = in(13);
    
    persistent xprev;
    persistent yprev;
    persistent plotted;
    
    % At first pass of valid simulation, store initial position in xprev and
    % yprev.
    if (plot_mode == 1 && clock == starting_time)
        xprev = l1 * cos(q1i) + l2 * cos(q1i + q2i);
        yprev = l1 * sin(q1i) + l2 * sin(q1i + q2i);
    end
    
    % If user has started drawing, plot the robot's position.
    if (not (ended) && sw == -1 && starting_time >= 0 || sw > 0)
        
        % When drawing arm, delete the previously drawn one.
        if not (isempty(plotted))
           delete(plotted);
        end
        
        if (plot_mode == 1) % don't plot arm
            if (clock == starting_time || xprev == x && yprev == y)
                % If previous point and current point are equal, draw a dot.
                plot(x,y,'.-','Color','b');
            else
                % If previous point and current point are different, draw a
                % line between them.
                line([xprev x],[yprev y],'Color','b','LineWidth',3);
            end
        else % plot_mode == 2, i.e. draw the arm
            px1 = l1 * cos(q1);
            px2 = px1 + l2 * cos(q1 + q2);
            py1 = l1 * sin(q1);
            py2 = py1 + l2 * sin(q1 + q2);
            plotted = plot([0,px1,px2],[0,py1,py2],'Color','blue');
        end
    end
    
    % Assign current values to xprev and yprev, as they will be used as
    % previous values in the next call.
    if (plot_mode == 1)
        xprev = x;
        yprev = y;
    end
end
