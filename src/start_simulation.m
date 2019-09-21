function [sim_time, q1out, q2out, xout, yout, deltax, deltay] =...
    start_simulation (sim_struct)
    
    % Extract data from sim_struct.
    try
        sw = sim_struct.sw; l1 = sim_struct.l1; l2 = sim_struct.l2;
        vmax = sim_struct.vmax; h_step = sim_struct.h_step;
        plot_mode = sim_struct.plot_mode_num;
        if (sw > 0)
            N = sim_struct.n; tmin = sim_struct.tmin; tmax = sim_struct.tmax;
            q1i_array = sim_struct.q1_initial; q2i_array = sim_struct.q2_initial;
            xstar = {sim_struct.xstar}; xstardot = {sim_struct.xstardot};
        end
    catch err % if sim_struct has wrong type
        if (strcmp(err.identifier,'MATLAB:nonExistentField') || strcmp(err.identifier,'MATLAB:structRefFromNonStruct'))
           exit_with_error('INVALID_STRUCT_ERROR',...
           'The argument sim_struct lacks at least one requested field.');
        end
    end

    % Protect against unmistakenly wrong inputs.
    if ((abs(sw) ~= 1 && sw ~= 2) || l1 <= 0 || l2 <= 0 || h_step <= 0)
        exit_with_error('ARG_ERROR',...
        'At least one invalid simulation parameter.');
    end
    
    if (sw > 0) % Check parameters defined only if sw > 0
        if (N < 0 | tmax < tmin | ~isreal(q1i_array) | ~isreal(q2i_array)) %#ok<*OR2>
            exit_with_error('ARG_ERROR',...
                'At least one invalid simulation parameter.');
        end
    end
            
    
    no_more_simulations_needed = 0;
    
    BIG_CONST = 922337203685477572; % around the maximum number of loops
                                    % possible for MATLAB
    
    if (sw > 0 && ~ishandle(1) && plot_mode)
        % If offline mode AND figure has been deleted AND must plot,
        % re-open the figure.
        open_figure(sw,l1,l2);
    end
    
    if (sw < 0)
        
        % In online mode the number of simulations is not known before
        % the simulation => the for loop should act like a WHILE loop
        % with a BREAK condition on no_more_simulations_needed becoming 1.
        % Should be N = inf, but that issuas a MATLAB:warn_truncate_for_loop_index
        % warning.
        N = BIG_CONST;
    end
    
    for n = 1:N
        
        if (sw > 0)
            
            % Assign values for n-th simulation.
            current_tmax = tmax(n); current_tmin = tmin(n); %#ok<*NASGU>
            q1iws = q1i_array(n,1); q2iws = q2i_array(n,1);
            screen_height = nan; screen_width = nan; dist_left = nan;
            dist_lower = nan; dist_right = nan; dist_upper = nan;
            
        else
            
            % Default values.
            current_tmax = inf;
            current_tmin = 0;
            
            q1iws = 0; q2iws = 0;  xstar{n} = [0 0 0]; xstardot{n} = [0 0 0];
            % ^ not used in ONLINE mode, but the Simulink model still
            % requires them to be defined
            
            if (n == 1)
                % Compute screen parameters.
                [screen_width, screen_height, dist_left, dist_lower,...
                    dist_right, dist_upper] =...
                    compute_screen_parameters(open_figure(sw,l1,l2)); %#ok<*ASGLU>
            end
        end
        
        % Run simulation.
        SO = sim('schema','StartTime','current_tmin','StopTime',...
            'current_tmax','SaveState','on','SaveOutput','on',...
            'OutputSaveName','yout','SrcWorkspace', 'current',...
            'FixedStep','h_step');
        
        clear read_cursor_input set_starting_time;
        
        % Get the simulation results in an handy format.
        [sim_time{n}, q1out{n}, q2out{n}, xout{n}, yout{n}, deltax{n}, deltay{n}] = ...
            get_simulation_results(sw, SO.get('xout'), SO.get('yout'));
        
        if (no_more_simulations_needed == 1)
            break;
        end
    end
    
    if (sw < 0)
            calllib('user32','GetAsyncKeyState',int32(1));
    end
    
    clear plot_robot_position;
    msgbox('The simulation has ended successfully.');
end