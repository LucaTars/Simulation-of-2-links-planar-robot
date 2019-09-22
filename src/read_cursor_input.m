
function out = read_cursor_input (in)

    % Ouput: out := [xstar ystar q1i q2i RESET STOP], where:
    % q1i, q2i are the current initial angles in online mode;
    % reset is a signal that goes to 1 as the user starts drawing in online
    % mode;
    % STOP is the stop signal for the simulation;

    persistent reset;
    persistent q1i;
    persistent q2i;
    persistent simulation_has_ended;
    persistent timer;
    
    out = [0; 0; 0; 4; 0; 0; 0]; % for first pass or offline mode

    sw = in(9);
    clock = in(10);
    
    if (sw > 0) % if not offline mode
        out = [0; 0; 0; 0; 0; 0; 0]; % arbitrary values: they are not used
        return;
    end
    
    % First pass in ONLINE mode.
    if (clock == 0)
        reset = 0;
        q1i = 0; q2i = 4; % arbitrary with q1i ~= q2i + k*pi, k integer
        simulation_has_ended = 0;
        real_step = 0;
    else
        real_step = toc(timer);
    end
    
    % The following assignments allow to edit the program easily in the
    % case of new/removed input parameters.
    l1 = in(1); l2 = in(2); screen_width = in(3); screen_height = in(4);
    dist_left = in(5); dist_lower = in(6); dist_right = in(7);
    dist_upper = in(8); tot_length = l1 + l2;
    timer = tic;
    if (calllib('user32','GetAsyncKeyState',int32(1)))
        
        % If key is pressed, xstar and ystar will be assigned
        Q = get(0, 'PointerLocation'); % get coordinate w.r. to screen coordinates
        if (Q(1,2) < screen_height - dist_upper && Q(1,2) > dist_lower && Q(1,1) > dist_left && Q(1,1) < screen_width - dist_right)
                      
            % If it is the drawing area, convert to figure coordinate.
            xstar = 2*tot_length / (screen_width - dist_right - dist_left) * (- dist_left + Q(1,1)) - tot_length;
            
            ystar = 2*tot_length / (screen_height - dist_upper - dist_lower) * (- dist_lower + Q(1,2)) - tot_length;
        
            plot(xstar,ystar,'.-','Color','red');
        
            if (reset == 0)
                % User has started drawing => set reset to 1.
                reset = 1;
                
                % Check if starting point is reachable.
                mod = sqrt(xstar^2 + ystar^2);
                if (mod >= l1 + l2 || mod <= abs(l1 - l2))
                    exit_with_error('FIRST_POINT_NOT_REACHABLE_ERROR',...
                        'First point of the reference signal is not reachable.');
                else
                    % Compute initial angles (from problem geometry).
                    [q1i, q2i] = pos2angle(xstar, ystar, l1, l2);
                end
            end
        else
            xstar = 0; ystar = 0;
        end
        
    % If mouse is released:
    else
        xstar = 0; ystar = 0; % arbitrary values: will not be used
        if (reset > 0)
            
            % Display choice box.
            simulation_has_ended = 1;
            answer = questdlg('New input?', 'Continue', 'Yes', 'No', 'Yes');
            
            % If answer is yes, increase n
            if (strcmp(answer,'Yes'))
                calllib('user32','GetAsyncKeyState',int32(1));
            else
                close all;
                assignin('caller', 'no_more_simulations_needed', 1);
            end
        end
    end
    
    out(1) = xstar; out(2) = ystar;
    out(3) = q1i; out(4) = q2i; out(5) = reset;
    out(6) = simulation_has_ended; out(7) = real_step;
end