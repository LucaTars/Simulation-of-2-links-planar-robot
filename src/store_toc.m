% Returns toc in modes 2 and 3 (the latter only if user has started to
% draw), 0 in mode 1.

function [t] = store_toc (in)

    starting_time = in(1);
    sw = in(2);
    
    if (sw == 1)
        t = 0;
    elseif (sw == 2)
        t = 0;
    elseif (starting_time >= 0)
        t = toc;
    else
        t = 0;
    end
end