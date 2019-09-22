% Prepares simulation in OFFLINE_MANUAL mode.
% Inputs and outputs as prepare_simulation.

function [n, q1_initial, q2_initial, tmin, tmax, xstar, xstardot, sw] = prepare_offline_manual(l1, l2)

    % Assign sw (used for switching in Simulink).
    sw = 2;
      
    % Initialize variables.
    finish = 0;
    n = 0;
            
    % If everything is correct, open the figure.
    open_figure(sw,l1,l2);
            
    % Pre-condition: finish = false.
    while not (finish)
        
        % At each loop increment the number of simulations.
        n = n + 1;
        
        % Get points from cursor and store the associated structure
        % in xstarIFH.
        xstarIFH = drawfreehand('Closed',false,'Color','red');
        
        try
            
            % Store points in variable.
            xspos = xstarIFH.Position;
        
        catch err
            
            % If user closed the figure.
            if (strcmp('MATLAB:class:InvalidHandle',err.identifier))
                exit_with_error('DELETED_FIGURE_ERROR',...
                    'The figure (drawing area) must not be closed manually before the end of the running process.');
            end
            
            % Otherwise, it is an unhandled exceptions.
            rethrow(err);
        end
        
        h_step2 = 0.1;
        
        % Assign time variables for the latest drawn signal.
        ts = max(size(xspos(:,1)));
        tmin(n) = 0;
        tmax(n) = (ts - 1)*h_step2;
        
        % Get well-formatted signals and initial angles.
        [xstar{n}, xstardot{n}, q1_initial(n,1), q2_initial(n,1)] = get_signals(h_step2, 0, tmax(n), (xspos(:,1))', (xspos(:,2))', l1, l2, sw);
        
        % After drawing has ended, ask the user if he/she wants to
        % draw a new signal.
        answer = questdlg('New input?', 'Continue', 'Yes', 'No', 'No');
        if (strcmp(answer, 'No') ==1)
            
            % If the user does not want to input a new signal, then
            % end the loop by setting the loop guard to false,
            % and close the window.
            finish = true;
        end
    end
    % Post-condition: finish = true.
end