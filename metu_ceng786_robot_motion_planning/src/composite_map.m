function [str_node, tgt_node] = composite_map(v)

% This block generates implicit composite map for multi-robots depending on
% the individual PRMs. This is the computationally heavier part. Only
% parameter is the number of vertices.
%
% Volkan OKBAY, 2018. MATLAB 2016a Student Edition

    global imp_tree imp_tree_edge number_of_robots
    % Initialize node array
    imp_tree = zeros(v^number_of_robots,number_of_robots,'uint8');
    % Create nodes of implicit tree (all configurations)
    for col = 1:number_of_robots
        array = zeros(v^col,1,'uint8');
        for i = 1:v
            index = (v^(col-1))*(i-1)+1;
            array(index:index+v^(col-1)-1) = i;
        end
        imp_tree(:,col) = repmat(array,v^(number_of_robots-col),1);
    end
    % Recursive function to generate edges of implicit map (computational
    % burden is here)
    len = length(imp_tree);
    imp_tree_edge = zeros(len,len,'logical');    
    imp_tree_edge_generator(number_of_robots,[],[]);
    % Find starting (S) and target (T) nodes of composite graph
    s_node = (v-1)*ones(1,number_of_robots);
    t_node = v*ones(1,number_of_robots);
    
    str_node = find(ismember(imp_tree,s_node,'rows'));
    tgt_node = find(ismember(imp_tree,t_node,'rows'));
end