function [NodeList, EdgeList] = find_PRMs(map_resolution, max_vertex_number, start_pt, target_pt, robot_radius)

% This is PRM calculator function for each robot with some parameters given
% above. Mainly, robotics.PRM functionality is used, but small changes are
% done on the PRM class that comes with original software.
%
% map_resolution = 50 (resolution between world coordinated arena and grid
% coordinates)
% max_vertex_number is the number of vertices comes from upper level
% robot_radius = 0.1 [m] for obstacle-robot collision calculations
%
% Volkan OKBAY, 2018. MATLAB 2016a Student Edition

    global arena_map arena_inflated
    
    P = zeros(10*map_resolution,'logical');
    for i = 1:length(arena_map) % Convert world coordinates to grid maps
        obstacle = arena_map{i};
        mask = poly2mask(obstacle(:,1)*map_resolution,obstacle(:,2)*map_resolution,10*map_resolution,10*map_resolution);
        mask = flip(mask,1);
        P(mask) = 1;
        P(1,:) = 1;
        P(end,:) = 1;
        P(:,1) = 1;
        P(:,end) = 1;
    end
    map = robotics.BinaryOccupancyGrid(P,map_resolution); % Create a grid object
    map.inflate(robot_radius); % Dilate obstacles for collision avoidance
    arena_inflated = imdilate(P,strel('disk',map_resolution*robot_radius));
    
    prm = PRM_updated(map, max_vertex_number-2); % Create custom PRM class
    prm.ConnectionDistance = 10; % Maximum connection distance in meters
    % PRM is generated at this point
    counter = uint8(0);
    prm_path = findpath(prm, start_pt, target_pt); % Try to find a path, check if PRM is valid (assumption)
    while isempty(prm_path)
        update(prm); % If not, re-calculate PRM
        % Search for a feasible path with the updated PRM
        prm_path = findpath(prm, start_pt, target_pt);
        counter = counter + 1;
        if counter == 255 % Try for 256 times, if not return an error message
            sprintf('PRM cannot be constructed between [%d %d] and [%d %d] !'...
                ,start_pt(1),start_pt(2),target_pt(1),target_pt(2))
            return
        end
    end
    % If successful, return nodes and edges
    num_of_nodes = numel(prm.getNodeList)/2;
    start_node_edge = find(ismember(prm.getNodeList', prm_path(2,:),'rows'));
    target_node_edge = find(ismember(prm.getNodeList', prm_path(end-1,:),'rows'));
    EdgeList = [prm.getEdgeList [num_of_nodes+1 start_node_edge]' [num_of_nodes+2 target_node_edge]' repmat(1:max_vertex_number,2,1)];
    NodeList = [prm.getNodeList start_pt' target_pt'];
    return
end