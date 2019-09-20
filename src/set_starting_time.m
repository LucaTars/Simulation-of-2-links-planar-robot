function starting_time = set_starting_time(in)
    
    q1 = in(1);
    q2 = in(2);
    q1i = in(3);
    q2i = in(4);
    sw = in(5);
    clock = in(6);
    RESET = in(7);
    tmin = in(8);
    persistent starting_time_value;
    
    if (sw < 0 && isempty(starting_time_value)) % ONLINE mode before user starts drawing
        starting_time_value = -1;
    elseif (sw > 0) % OFFLINE modes
        starting_time_value = tmin;
        if (clock == 0)
            tic; % start timer
        end
    end
    
    if (sw < 0 && q1 == q1i && q2 == q2i && RESET > 0 && starting_time_value == -1)
        
        % In ONLINE mode.
        % The arm has catched up to the initial conditions; nothing has
        % been drawn yet.
        starting_time_value = clock; % clock is non-negative
        tic; % start timer
    end
	
    starting_time = starting_time_value;
end
