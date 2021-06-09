function [ decoded_bits ] = viterbi_Decoding(encoded_bits)

%% as our encoder with rate 1/3 so the output will be 1/3 of the input length
num_decoded=length(encoded_bits)/3; %

decoded_bits = zeros(1,num_decoded); % number of decoded bits intilized to be zero 

survivor_branches = zeros(4,num_decoded); % number of survivors paths

cumulation_branches = zeros(4,num_decoded+1); % number of  cumulative metrics
cumulation_branches(1,1) = 0; 
cumulation_branches(2:4,1) = Inf; % first state  which is (0,0) is intilized to be 0 and all other are inf

transition_branchs = zeros(8,num_decoded); % number of branch metrics between two states
for i=2:3:num_decoded
    % we will loop on the length of sequence and take two bits
    % and calculate the hamming distance between the output transtion between states and the input   
transition_branchs(1,i) = biterr([0 0 0], [encoded_bits(i-1) encoded_bits(i) encoded_bits(i+1)]); % 000 colud result from transition between 00 to 00 
transition_branchs(2,i) = biterr([1 1 1], [encoded_bits(i-1) encoded_bits(i) encoded_bits(i+1)]); % 111 colud result from transition between 00 to 10 
transition_branchs(3,i) = biterr([1 0 1], [encoded_bits(i-1) encoded_bits(i) encoded_bits(i+1)]); % 101 colud result from transition between 10 to 01  
transition_branchs(4,i) = biterr([0 1 0], [encoded_bits(i-1) encoded_bits(i) encoded_bits(i+1)]); % 010 colud result from transition between 10 to 11
transition_branchs(5,i) = biterr([0 0 1], [encoded_bits(i-1) encoded_bits(i) encoded_bits(i+1)]); % 001 could result from transition between 01 to 10 
transition_branchs(6,i) = biterr([1 1 0], [encoded_bits(i-1) encoded_bits(i) encoded_bits(i+1)]); % 110 colud result from transition between 01 to 00 
transition_branchs(7,i) = biterr([1 0 0], [encoded_bits(i-1) encoded_bits(i) encoded_bits(i+1)]); % 100 colud result from transition between 11 to 11 
transition_branchs(8,i) = biterr([0 1 1], [encoded_bits(i-1) encoded_bits(i) encoded_bits(i+1)]); % 011 colud result from transition between 11 to 01
% so now we have the first row of branch matrix have the hamming distance
% between 00 and all bits input 
end

for i = 1:num_decoded
    %select wiich branch will survive based on the lowest hamming distance 
    if (cumulation_branches(1,i)+transition_branchs(1,i) <= cumulation_branches(3,i)+transition_branchs(6,i)) % minimum distance to reach state 00 at time i
        cumulation_branches(1,i+1) = cumulation_branches(1,i)+transition_branchs(1,i); %add the cumlative with the previous satge  
        survivor_branches(1,i) = true; %make the survivor_branch (1,i) ture if it survived else survivor_branch (1,i) keep it false or zero 
    else
        cumulation_branches(1,i+1) = cumulation_branches(3,i)+transition_branchs(6,i);  
    end
    
    if (cumulation_branches(1,i)+transition_branchs(2,i) <= cumulation_branches(3,i)+transition_branchs(5,i)) % minimum distance to reach state 10 at time i
        cumulation_branches(2,i+1) = cumulation_branches(1,i)+transition_branchs(2,i);%add the cumlative with the previous satge 
        survivor_branches(2,i) = true;%make the survivor_branch (2,i) ture if it survived else survivor_branch (2,i) keep it false or zero 
    else
        cumulation_branches(2,i+1) = cumulation_branches(3,i)+transition_branchs(5,i);
       
    end
    
    if (cumulation_branches(2,i)+transition_branchs(3,i) <= cumulation_branches(4,i)+transition_branchs(8,i))  % minimum distance to reach state 01 at time i
        cumulation_branches(3,i+1) = cumulation_branches(2,i)+transition_branchs(3,i);%add the cumlative with the previous satge 
        survivor_branches(3,i) = true;%make the survivor_branch (3,i) ture if it survived else survivor_branch (3,i) keep it false or zero 
    else
        cumulation_branches(3,i+1) = cumulation_branches(4,i)+transition_branchs(8,i);
       
    end
    
    if (cumulation_branches(2,i)+transition_branchs(4,i) <= cumulation_branches(4,i)+transition_branchs(7,i)) %   minimum distance to reach state 11 at time i
        cumulation_branches(4,i+1) = cumulation_branches(2,i)+transition_branchs(4,i);%add the cumlative with the previous satge 
        survivor_branches(4,i) = true;%make the survivor_branch (4,i) ture if it survived else survivor_branch (4,i) keep it false or zero 
    else
        cumulation_branches(4,i+1) = cumulation_branches(4,i)+transition_branchs(7,i);
    
    end   
    % then we will differeniate between the previous state based on if 
    % survivor_branch is true or false 
end
state = 1; %[0 0] state with zero termination, the final stage is always 00
% trace back the previous state and decode the corresponding bit
for j = num_decoded:-1:1
    [state, decoded_bits(j)] = trace_back(state, survivor_branches(:,j));
end

end