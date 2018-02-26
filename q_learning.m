close all;
clear all;
clc;

% '-1' indicates impossible state transitions
R = [-1,-1,-1,-1,0,-1;
     -1,-1,-1,0,-1,100;
     -1,-1,-1,0,-1,-1;
     -1,0,0,-1,0,-1;
     0,-1,-1,0,-1,100;
     -1,0,-1,-1,0,100;];

% '1' indicates possible actions, '0' indicates impossible actions
A = [0,0,0,0,1,0;
     0,0,0,1,0,1;
     0,0,0,1,0,0;
     0,1,1,0,1,0;
     1,0,0,1,0,1;
     0,1,0,0,1,1;];
 
Q = zeros(6,6);
final_Q = Q;
gamma = 0.8; % Discount factor
stop = 0; % End simulation flag
trial = 0;

while stop == 0
    
%   Initializes to a random state
    current_state = randi([1,6]);
    end_episode = 0;
    count = 0;
    while end_episode ~= 1
%       Fetches all possible actions for the current state
        actions = (find(A(current_state,:)));

%       Chooses a random action for the current state
        index = randperm(length(actions),1);
        action = actions(index);

%       Calculates the current, future rewards and Q table
        current_reward = R(current_state,action);
        future_reward = max(Q(action,:));
        Q(current_state,action) = current_reward + gamma*future_reward
        
%       To identify whether an episode has ended (satisfied when state 6 
%       is reached twice in the same episode)
        if current_state == 6
            count = count+1;
            if count == 2
                end_episode = 1;
            end
        end
        
%       Sets next state as current state
        current_state = action;
    end
    
%   Metric to end the Q learning algorithm
    diff = round(final_Q - Q,4);
    if diff == 0
        trial = trial + 1;
        
%       Q learning ends when no update is seen for 10 consecutive trials
        if trial == 10
            disp("Q learning completed");
            final_Q
            stop = 1;
        end
    else
        trial = 0;
        stop = 0;
    end
    final_Q = Q;
    pause(0.1);
    
end