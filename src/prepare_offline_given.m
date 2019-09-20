% Prepares simulation in OFFLINE_GIVEN mode.
% Inputs and outputs as prepare_simulation.

function [n, q1_initial, q2_initial, xstar, xstardot, sw] =...
    prepare_offline_given(l1, l2, h_step, tmin, tmax, xs, ys, plot_mode)

    % Check for inconsistent input in mode 1-only parameters.
    if (tmin > tmax)
        exit_with_error('ARG_ERROR','tmin cannot be greater than tmax.');
    end

    % Assign sw (used for switching in Simulink).
    sw = 1;

    % There is only one signal, so set n to 1.
    n = 1;

    % Get well-formatted signals and initial angles.
    [xstar{1}, xstardot{1}, q1_initial, q2_initial] = get_signals(h_step, tmin, tmax, xs, ys, l1, l2, sw);

    if (plot_mode > 0)
        % If everything is correct and user wants plots, open the figure.
        open_figure(sw,l1,l2);
        
        % Plot the desired trajectory in red.
        plot(xs,ys,'Color','red');
        
    end
end