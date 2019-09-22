% Converts the plot mode string input by user into an integer (throws error
% if string is not valid).
% Input: the plot mode string.
% Output: 0 if no plot is wanted, 1 if no links are wanted in the plot,
% 2 otherwise.

function plot_mode = plot_mode_str2int(plot_mode)

    switch plot_mode
        
        case 'NO_PLOT'
            plot_mode = 0;
        case 'PLOT_NO_LINKS'
            plot_mode = 1;
        case 'PLOT_WITH_LINKS'
            plot_mode = 2;
        otherwise
            exit_with_error('PLOT_MODE_ERROR',...
                'Given plot mode is not valid.');
            
    end
end