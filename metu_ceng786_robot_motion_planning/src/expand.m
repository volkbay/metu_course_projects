function fail = expand(parameter_N,target_node)

% One of the most important function in the algorithmic flow. It tries to
% expand current RRT tree for 2^N times. See report for explanation.
%
% Volkan OKBAY, 2018. MATLAB 2016a Student Edition

	global imp_tree imp_tree_edge cur_tree cur_tree_dir_edge number_of_robots PRMs
    
    fail = 0;
    C_new = zeros(1,number_of_robots); % New node initialization
    
    % Run expansion for 2^N samples
    for i = 1:2^parameter_N
        % Choose a random vertex of current tree
        candidates = intersect(find(any(imp_tree_edge')),cur_tree); % Take only expandable vertices
        if numel(candidates) == 0 % There is no current tree node with not expanded (no implicit neighbor)
            disp('MRdRRT failed to find a solution!');
            fail = 1;
            return
        else
            C_near = candidates(randi([1 numel(candidates)])); % Uniform random selection
        end
        
        for n = 1:number_of_robots % For each robot find a next location by direction oracle and random point selection
            c_i = imp_tree(C_near,n);
            neighbors =  unique([PRMs{n}.edge(PRMs{n}.edge(:,1) == c_i,2);PRMs{n}.edge(PRMs{n}.edge(:,2) == c_i,1)]);
            if numel(neighbors) == 1
                C_new(n) = neighbors; % If there is onyl one neighbors no need for randomness
            else
                C_new(n) = direction_oracle(c_i,PRMs{n}.vertex(:,:), neighbors'); % Direction oracle
            end
        end
        
        C_new_index = find(ismember(imp_tree, C_new,'rows')); % Find new node
        if ~any(ismember(cur_tree,C_new_index,'rows')) && imp_tree_edge(C_near,C_new_index) % Not in the RRT tree, implicit edge is valid
            imp_tree_edge(:,C_new_index) = false;
            imp_tree_edge(C_new_index,C_near) = false;
            cur_tree = [cur_tree; C_new_index]; % Add new node to tree 
            cur_tree_dir_edge = [cur_tree_dir_edge; C_near C_new_index];
            if C_new_index == target_node % Target node reached no need for other expansions
                return
            end
        elseif any(ismember(cur_tree,C_new_index,'rows')) && imp_tree_edge(C_near,C_new_index) % In the RRT tree already, neglect new node
            imp_tree_edge(C_near,C_new_index) = false;
            imp_tree_edge(C_new_index,C_near) = false;
        end   
    end
end