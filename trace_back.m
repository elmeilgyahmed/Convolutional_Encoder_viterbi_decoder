function [prev_state, decoded_bit] = trace_back(curr_state, survivor)
switch curr_state
    case 1 % 00 state 
        decoded_bit = 0; % the decoded bit is zero 
        if(survivor(1) == true) % if the survivior branch is true the previous state is [0 0] (1) else it is [0 1] (3)
            prev_state = 1;
        else
            prev_state = 3;
        end
    case 2% 10 state
        decoded_bit = 1; %the decoded bit is one 
        if(survivor(2) == true)% if the survivior branch is true the previous state is [0 0] (1) else it is [0 1] (3)
            prev_state = 1;
        else
            prev_state = 3;
        end
    case 3 % 01 state
        decoded_bit = 0;%the decoded bit is zero
        if(survivor(3) == true)% if the survivior branch is true the previous state is [1 0] (2) else it is [1 1] (4)
            prev_state = 2;
        else
            prev_state = 4;
        end
    otherwise %11 state 
        decoded_bit = 1;%the decoded bit is one 
        if(survivor(4) == true) % if the survivior branch is true the previous state is [1 0] (2) else it is [1 1] (4)
            prev_state = 2;
        else
            prev_state = 4;
        end
end
end