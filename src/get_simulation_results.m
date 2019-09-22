% Takes the simulation time, states and outputs and returns them in a column
% vector form.

% Inputs:
% 1. sw = switching parameter returned by call to prepare_simulation.
% 2. q1q2 = states of the simulation, stored in a Simulink structure.
% 3. outs = outputs of the simulation, stored in a Simulink structure
% (index->signal) = (1->x,2->y,3->deltax,4->deltay,5->starting_time,6->
% real_time)

% Outputs: as names say.

function [sim_time, q1out, q2out, xout, yout, deltax, deltay] = ...
    get_simulation_results(sw, q1q2, outs)

    q1q2_elem1 = q1q2.getElement(1); % used more than once
    
    if (sw > 0)
        only_in_online = 0;
    else
        only_in_online = 1; % last point is the click on message box
    end
    
    nsamples = max(size(q1q2_elem1.Values.Time)) - only_in_online;

    sim_time = q1q2_elem1.Values.Time(1:nsamples); % time column array of the simulation

    if (sw < 0)
        
        % In online mode, the signal is to be considered after initial conditions are reached
        starting_time = max(outs.getElement(5).Values.Data);
        first_time_index = find(sim_time >= starting_time, 1);
    else
        
        % In other modes, consider all elements
        first_time_index = 1;
    end

    % Store signals computed during simulation in a decent format.
    if (sw > 0)
        sim_time = sim_time(first_time_index:nsamples);
    else
        sim_time = outs.getElement(6).Values.Data(first_time_index:nsamples);
    end
    
    q1out = q1q2_elem1.Values.Data(first_time_index:nsamples);
    q2out = q1q2.getElement(2).Values.Data(first_time_index:nsamples);
    xout = outs.getElement(1).Values.Data(first_time_index:nsamples);
    yout = outs.getElement(2).Values.Data(first_time_index:nsamples);
    deltax = outs.getElement(3).Values.Data(first_time_index:nsamples);
    deltay = outs.getElement(4).Values.Data(first_time_index:nsamples);

end