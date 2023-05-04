function result = retrieve_path(s,t)

% Retrieve resulting path in case of success. This is easily done as
% current tree edges are directed.
%
% Volkan OKBAY, 2018. MATLAB 2016a Student Edition
    global cur_tree_dir_edge
    
    current_node = t;
    path = t; % Start from target node
    while(current_node ~= s) % Try to reach start by going backwards
        current_node = cur_tree_dir_edge(cur_tree_dir_edge(:,2)==current_node,1);
        path = [path current_node];
    end
    
    result = path;
    return
end