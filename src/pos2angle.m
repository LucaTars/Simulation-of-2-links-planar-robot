% Returns manipulator angles given the position of actuator.
% Inputs, outputs: as written.

function [q1, q2] = pos2angle (x, y, l1, l2)
    
    % Geometric formulae (actuator position -> angles).
    q1 = 2*atan((2*l1*y + (- l1^4 + 2*l1^2*l2^2 + 2*l1^2*x^2 +...
        2*l1^2*y^2 - l2^4 + 2*l2^2*x^2 + 2*l2^2*y^2 - x^4 - 2*x^2*y^2 -...
        y^4)^(1/2))/(l1^2 + 2*l1*x - l2^2 + x^2 + y^2));
    
    q2 = -2*atan(((- l1^2 + 2*l1*l2 - l2^2 + x^2 + y^2)*(l1^2 +...
        2*l1*l2 + l2^2 - x^2 - y^2))^(1/2)/...
        (- l1^2 + 2*l1*l2 - l2^2 + x^2 + y^2));
            
end