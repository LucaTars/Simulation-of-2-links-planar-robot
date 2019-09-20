% Exits throwing a specified error, after closing all open resources.

% Inputs:
% 1. id = error identifier.
% 2. errstr = string to be printed.

function exit_with_error(id, errstr)

    % Close open resources.
    close all hidden;
    clear read_cursor_input plot_robot_position set_starting_time;

    % Name of caller function.
    st = dbstack;
    namestr = st(2).name;
	
    id = [namestr, ':', id];
    
    % Create error structure.
    error_struct.identifier = [namestr, ':', id]; % Follows standard format for error identifier: 'str1:str2'.
    error_struct.message = errstr;
    
    % Print error in box.
    msgbox(errstr,id,'error');
    
    % Throw error and exit.
    error(error_struct);
end