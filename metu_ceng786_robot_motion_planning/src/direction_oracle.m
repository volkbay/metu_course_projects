function output = direction_oracle(q_near_index, tree, neighbors)

% This is the so-called direction oracle. See report and article for a
% better explanation.
%
% Volkan OKBAY, 2018. MATLAB 2016a Student Edition

q_near = tree(q_near_index,:); % Coordinates of origin node
q_rand = 10*rand([1 2]); % Coordinates of random point

% Quadrant tangent value of random point with respect to origin node
angle_random_near = atan2(q_rand(2)-q_near(2),q_rand(1)-q_near(1));

neighbors(neighbors==q_near_index) = [];
min_diff = 1.5708; % 180' degrees angle difference
node_number = q_near_index;
for n = neighbors % Check all neighbors
    q_neigh = tree(n,:); % Coordinates of current neighbor
    angle_neigh_near = atan2(q_neigh(2)-q_near(2),q_neigh(1)-q_near(1));
    current_diff = abs(angdiff(angle_random_near,angle_neigh_near));
    if min_diff > current_diff 
        min_diff = current_diff;
        node_number = n;
    end
end

output = node_number;
return

end