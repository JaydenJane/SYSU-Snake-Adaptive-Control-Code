joint_num = 8;
max_angle = 90;
min_angle = -90;

stop_state = [0,49,0,-90,0,90,-90,-90 ];
steady_state = zeros(1, joint_num);
num_work_states = 5;
% work_states = [];
% for i = 1:num_work_states
%     work_states = [work_states; randi(181,1,joint_num)-91];
% end

work_states = [-10    26    38    46   -41    33    28   -61
   -69     0   -60   -29    15   -50    45   -44
     1    36    71    83     9   -65   -63   -44
    62   -44    57   -46    78   -27   -55   -45
    21    -5   -27    60    15     9    76   -39];

duration_in_minutes = 6 * 60;
time_for_each_action = 2;
num_actions = duration_in_minutes / time_for_each_action;

action_table = zeros(1 + num_actions*2, joint_num+1);

action_table(1, :) = [steady_state, 30*10];

for i = 1 : num_actions
    work_state_id = randi(num_work_states);
    temp = [work_states(work_state_id, :), 90*10;
            steady_state, 30*10];
    action_table(2*i:2*i+1,:) = temp;
    
end

csvwrite('tt.csv', action_table);