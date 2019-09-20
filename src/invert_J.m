% If (inputs) xstar and ystar are reachable, returns the inverse of the
% Jacobian matrix. Otherwise, it stops the simulation with error.

% Input: as written after function declaration.

function [Jinv] = invert_J (in)
    
    xstar = in(1); ystar = in(2); l1 = in(3); l2 = in(4); q1 = in(5);
    q2 = in(6); xstardot = in(7); ystardot = in(8); vmax = in(9);
    starting_time = in(10); sw = in(11); ended = in(12);
    
    mod = sqrt(xstar^2 + ystar^2);
        
    % Point not reachable.
    if (~ended && ((sw < 0 && starting_time >= 0) || sw > 0) && (mod >= l1 + l2 || mod <= abs(l1 - l2)))
        exit_with_error('POINT_NOT_REACHABLE_ERROR','Point is not reachable.');
        
    % Desired speed too high.
    elseif (abs(xstardot) > vmax || abs(ystardot) > vmax)
        exit_with_error('MAX_SPEED_EXCEEDED_ERROR','Maximum speed exceeded.');
    end
    
    % If there is no error, J is invertible.
    % Store much used values.
    s1 = sin(q1); s12 = sin(q1 + q2); c1 = cos(q1); c12 = cos(q1 + q2);
    
    % Compute Jacobian matrix.
    J = [(-l1 * s1 - l2 * s12), -l2*s12; (l1*c1 + l2*c12), l2*c12];
    Jinv = inv(J);

end