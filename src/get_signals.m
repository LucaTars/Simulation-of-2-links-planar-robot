% In ONLINE modes, converts the signal given by the user / extracted from
% gathered data in a form that is acceptable for the simulator. This format
% is: [column of time instants, column of x values, column of y values].

% Inputs:
% 1. h_step = simulation step.
% 2. tmax = final time of simulation.
% 3. xs, ys = components of signal, in a time-value row format.
% 4. l1, l2 = length of the robot's arms. Needed to compute q1_initial,
% q2_initial.

% Outputs:
% 1. xstar = the two components of the reference signal, in a
% time-value column format.
% 2. xstardot = the two components of the derivative of the reference.
% 3. signal, same format as xstar.
% 4. q1_initial, q2_initial = initial robot angles for the signal,
% scalars.

function [xstar, xstardot, q1_initial, q2_initial]...
    = get_signals(h_step, tmin, tmax, xs, ys, l1, l2, sw)
    
    % Store sample time values in t.
    t = tmin:h_step:tmax;          % row
    
    % Store number of samples in ts.
    ts = max(size(t));
    
    % Signal in final format.
    try
       xstar = [t', xs', ys'];     % columns
    catch err
       if (sw == 1 && strcmp(err.identifier,'MATLAB:catenate:dimensionMismatch'))
           exit_with_error('INVALID_INPUT_SIZE_ERROR',...
           'At least one component of the given reference signal has invalid dimension. Each component must be a row vector with floor((tmax-tmin)/h)+1 columns.');
       end
    end
    
    % Differentiation.
    xsd = diff(xs)/h_step;      % rows
    ysd = diff(ys)/h_step;      % rows
    
    % Compute derivatives in tmax with a backward formula.
    if (ts > 1)
        xsd(1,ts) = (xs(1,ts)-xs(1,ts-1))/h_step;
        ysd(1,ts) = (ys(1,ts)-ys(1,ts-1))/h_step;
    else % it is a single point
        xsd(1,ts) = 0;
        ysd(1,ts) = 0;
    end
    
    % Signal's derivative in final format.
    xstardot = [t', xsd', ysd']; % columns
    
    % Compute initial angles.
    [q1_initial, q2_initial] = pos2angle(xs(1), ys(1), l1, l2);
end
