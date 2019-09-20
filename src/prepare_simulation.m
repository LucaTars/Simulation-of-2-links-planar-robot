% Prepares simulation parameters; accepts cursor-drawn signals in mode 2.

% Inputs:
% 1. mode = simulation mode string. 2. plot_mode = plot mode string.
% 3. vmax = maximum speed of any component of the actuator's position.
% 4.5. l1, l2 = link lengths. 6. h_step = simulation step.
% 7. tmin, tmax = initial / final simulation times.
% 8. xs, ys = reference signal components, given as column vectors.

function sim_struct = prepare_simulation (mode, plot_mode, vmax, l1, l2, h_step, tmin, tmax, xs, ys)

    % Check the supposedly non-negative values.
    if (vmax <= 0)
        exit_with_error('ARG_ERROR',...
        'Maximum speed must be a positive real number.');
    end
    if (h_step <= 0)
        exit_with_error('ARG_ERROR',...
        'Simulation step must be a positive real number.');
    end
    if (l1 <= 0 || l2 <= 0)
        exit_with_error('ARG_ERROR',...
        'Link lengths must be positive real numbers.');
    end
    
    plot_mode = plot_mode_str2int(plot_mode);
    
    switch mode
        
        case 'OFFLINE_GIVEN'
            [n,q1_initial,q2_initial,xstar,xstardot,sw] = ...
                prepare_offline_given(l1,l2,h_step,tmin,tmax,xs,ys,plot_mode);
            
        case 'OFFLINE_MANUAL'
            [n,q1_initial,q2_initial,tmin,tmax,xstar,xstardot,sw] = ...
                prepare_offline_manual(l1,l2);
            
      case 'ONLINE'
            % Load dll file for mouse position.
            if (plot_mode == 0)
                exit_with_error('MODE_ERROR','Mode and plot mode are not compatible.');
            end
            
            if not (libisloaded('user32'))
                 loadlibrary('user32.dll','user32.h');
            end
            
            % The following call is necessary because otherwise for some
            % reasons some click is still lying around after the simulation
            % starts and ruins the hand drawing process.
            calllib('user32','GetAsyncKeyState',int32(1));
            
            n = 0; sw = -1;
            
        otherwise
            exit_with_error('MODE_ERROR','Given mode is not valid.');
    end
    
    for ii = 1:n
        % Check if first point is unreachable.
        mod = sqrt(xstar{ii}(1,2)^2 + xstar{ii}(1,3)^2);
        
        if not (mod <= l1+l2 && mod >= abs(l1-l2))
            str_not_reach_error = ['First point of reference signal ',num2str(ii),' is not reachable.'];
            exit_with_error('FIRST_POINT_NOT_REACHABLE_ERROR', str_not_reach_error);
        end
        
        % Check if reference signal is not finite (would cause error in
        % the simulation).
        if (min(size(find(abs(xstar{ii}) == inf))) > 0 || min(size...
                (find(isnan(xstar{ii})))) > 0)
            exit_with_error('INFINITE_SIGNAL_ERROR',...
                ['Reference signal ',num2str(ii),' is not finite.']);
        end
    end
    
    % Step too high.
    if (h_step > 0.01)
        h_step = 0.01;
        warning('Proposed step was too high, will be reduced to 0.01.');
    end
    
    % Store data in the output structure.
    if (sw > 0)
        sim_struct = struct('h_step',h_step,'l1',l1,'l2',l2,'n',n,...
        'plot_mode_num',plot_mode,'q1_initial',q1_initial,'q2_initial',...
        q2_initial,'sw',sw,'vmax',vmax,'tmin',tmin,'tmax',tmax,'xstar',...
        xstar,'xstardot',xstardot);
    else
        sim_struct = struct('h_step',h_step,'l1',l1,'l2',l2,...
        'plot_mode_num',plot_mode,'sw',sw,'vmax',vmax);
    end
    
end