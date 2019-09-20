% Examples

function [t,q1,q2,x,y,deltax,deltay] = example_program (mode,plot_mode,vmax,l1,l2,h_step,tmin,tmax,xstar_in,ystar_in)
    close all hidden;
    switch mode
        
        case 'OFFLINE_GIVEN'
            
            sim_struct = prepare_simulation(mode,plot_mode,vmax,l1,l2,h_step,tmin,tmax,xstar_in,ystar_in);
            
            [t,q1,q2,x,y,deltax,deltay] = start_simulation(sim_struct);
            
        otherwise
            
            sim_struct = prepare_simulation(mode,plot_mode,vmax,l1,l2,h_step);
            
            [t,q1,q2,x,y,deltax,deltay] = start_simulation(sim_struct);
    end    
end