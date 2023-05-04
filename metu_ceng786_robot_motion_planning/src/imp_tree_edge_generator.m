function imp_tree_edge_generator(robot_number, vertex_array1, vertex_array2)

% Recursive function to generate implicit tree edges. This operation is the
% burden on the computation as its complexity is O(v^2r), where v is number
% of vertices for each robot and r is the number of the robots.
%
% Volkan OKBAY, 2018. MATLAB 2016a Student Edition

    global PRMs imp_tree imp_tree_edge number_of_robots
    
    skip = false;
    for prm_edge = unique([PRMs{robot_number}.edge' flip(PRMs{robot_number}.edge',1)]','rows')' % List all PRM edges for a sinle robot
        if robot_number ~= number_of_robots % Here we check if there is an intersection of paths of the current robot and recursively upper level robots 
            for r = number_of_robots:(number_of_robots-robot_number+1)
                pt1 = PRMs{robot_number}.vertex(prm_edge(1),:);
                pt2 = PRMs{robot_number}.vertex(prm_edge(2),:);
                pt3 = PRMs{r}.vertex(vertex_array1(number_of_robots-r+1),:);
                pt4 = PRMs{r}.vertex(vertex_array2(number_of_robots-r+1),:);
                if intersect_check(pt1,pt2,pt3,pt4) % Actual intersection checking dependin on the simple linear determinant operation
                    skip = true;
                    break; % If so, give skip command
                end
            end
        end
        
        if skip % If skip is issued, there is an intersection, implicit tree path is invalid
            skip = false;
            continue;
        end
        
        if robot_number == 1 % Termination condition (last robot)
            ind1 = find(ismember(imp_tree, flip([vertex_array1 prm_edge(1)],2),'rows'));
            ind2 = find(ismember(imp_tree, flip([vertex_array2 prm_edge(2)],2),'rows'));
            if ind1 ~= ind2 % If any robot moves, update implicit tree edge matrix
                imp_tree_edge(ind1,ind2) = true;
                imp_tree_edge(ind2,ind1) = true;
            end
        else
            imp_tree_edge_generator(robot_number-1,[vertex_array1 prm_edge(1)],[vertex_array2 prm_edge(2)]); % If not the last robot, recursion
        end
    end
end