function output = connect_to_target(parameter_K, target_node)

% This is the simple local connector, which checks whether anyone of the K 
% number of recent RRT tree nodes can be connected easily to the target
% node. This is done by simple line drawing and looking for intersection
% with obstacles.
%
% Volkan OKBAY, 2018. MATLAB 2016a Student Edition

    global cur_tree PRMs imp_tree number_of_robots arena_inflated
    
    output = [];
    target_nodes = imp_tree(target_node,:);
    for i = 1:parameter_K % For K number of nodes
        crash = 0;
        index = max(length(cur_tree) - i + 1,1);
        nodes = imp_tree(cur_tree(index),:);
        for r = 1:number_of_robots % Check every robot
            pos = PRMs{r}.vertex(nodes(r),:);
            target_pos = PRMs{r}.vertex(target_nodes(r),:);
            x_line = floor(50*linspace(pos(1),target_pos(1),50))+1;
            y_line = floor(50*linspace(pos(2),target_pos(2),50))+1;
            for n = 1:50
                if arena_inflated(500-y_line(n),x_line(n)) %  Check if there is a line/obstacle collision 
                    crash = 1;
                    break;
                end
            end
            if crash == 1 % If so local connector fails
                break;
            elseif r == number_of_robots % Otherwise, solution is obtained
                output = cur_tree(index);
                return
            end
        end
    end
end