function path = dRRT(start_node, target_node)

% Actual algorithm flow is here. See the algorith pseudo-codes in report.
% Basically, tree is initiated. And at every iteration tree is expanded for
% a few times of trials. Local connector is run afterwards, if target node
% is reached, path is retrieved by current tree edges.
%
% Volkan OKBAY, 2018. MATLAB 2016a Student Edition

    global cur_tree cur_tree_dir_edge imp_tree_edge
    
    % Initializing tree with starting point of all robots
    cur_tree = [];
    cur_tree_dir_edge = [];
    cur_tree(1) = start_node;
    
    % Main loop
    iteration_number = 1;
    while(1)
        if expand(iteration_number,target_node) % Expansion
            path = []; % If fails return an empty path
            return
        end
        local_connector = connect_to_target(iteration_number,target_node); % Try local connector
        if ~isempty(local_connector) && local_connector ~= target_node % If succeeds, expand tree
            disp('Local connector was successful!');
            cur_tree = [cur_tree ; target_node];
            cur_tree_dir_edge = [cur_tree_dir_edge ; local_connector target_node];
        end    
        A = ismember(cur_tree,target_node);
        if any(A(:)) % Check if target node is in the tree
            disp('MRdRRT successfully found a solution!');
            path = retrieve_path(start_node, target_node); % If so, retrieve path
            return
        else
            iteration_number = iteration_number + 1; % Else, next iteration
        end
        
        if nnz(imp_tree_edge) == 0
            disp('No solution is found!');
            return
        end
    end
end