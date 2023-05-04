function main_project_ceng786(varargin) %(case_number, number_of_vertices for PRM)

% This function is main function of project coded by Volkan OKBAY for
% CENG786: Robot Motion Control & Planning course, at METU. The algorithm
% majorly based on the article "Finding a needle in the haystack: Discrete
% RRT for exploration of implicit roadmaps in multi-robot motion planning" 
% by Solovey et. al.(2016).
%
% The aim is to find a set of path s for multi-robots in a 2D environment
% with obstacles each having a start and target points. The robots are
% holonomic and circular with 2DOF. Obstacles are convex or concave 
% polyhedral 2D objects in a 10x10 meters map.
%
% Function may be called with two parameters namely case_number and
% number_of_vertices. First one determines which case of arena, robot
% points and number of robots, while the latter is for PRM calculation for
% each.
%
% The output is PRM plotting for individual robots and an animated
% multi-robot motion.
%
% Volkan OKBAY, 2018. MATLAB 2016a Student Edition (robotics toolbox needed).

clearvars -global
close all
% Global Variables
global imp_tree             % Implicit composite tree (vertices)
global imp_tree_edge        % Implicit composite tree (edges)
global cur_tree             % Current RRT tree (vertices)
global cur_tree_dir_edge    % Current RRT tree (edges, directed)
global number_of_robots     % Number of robots
global PRMs                 % PRM structure of each robot
global arena_map            % Arena obstacle map in world coordinates
global arena_inflated       % Arena with dilated obstacles (for collision calculation)

% Checking number of input parameters and assigning defaults
switch nargin
    case 0
        number_of_vertices = 5;
        case_number = 1;
    case 1
        number_of_vertices = 5;
        case_number = varargin;
    case 2
        number_of_vertices = varargin{2};
        case_number = varargin{1};
    otherwise
        error('myfuns:main_project_ceng786:TooManyInputs', ...
        'requires at most 3 optional inputs');        
end

% Initialize some global variables
imp_tree_edge = [];
cur_tree = [];
cur_tree_dir_edge = [];
arena_map = [];
arena_inflated = [];

% Initialize a 10x10 arena with 2D obstacles
init_arena(case_number);

% Initialize robots regarding individual start and target points, assign a
% color each.
[robot_color, start_pts, target_pts] = init_robots(case_number);

% Calculate individual PRMs depending on the arena map and start-target points
PRM_time = tic; % Measure time for PRM calculation
for r = 1:number_of_robots
    [node, edge] = find_PRMs(50,number_of_vertices,start_pts(r,:),target_pts(r,:),0.1);
    PRMs{r}.vertex(:,:) = node';
    PRMs{r}.edge(:,:) = edge';
end
disp('PRM Time:')
toc(PRM_time)

% Calculate composite graph considering obstacle and robot-robot collisions
COMPOSITE_time = tic; % Measure time for composite tree generation
[start_node, target_node] = composite_map(number_of_vertices);
disp('Composite PRM Build Time:')
toc(COMPOSITE_time)

% Actual MRdRRT algorithm takes place to find a path if exists
DRRT_time = tic; % Measure time for MRdRRT calculation
path = dRRT(start_node, target_node);
path = flip(path,2);
disp('MRdRRT Algorithm Time:')
toc(DRRT_time)

% Plotting PRM graphs for each robot showing arena, start/target points
% with PRM nodes/edges.
for r = 1:number_of_robots
    figure;
    draw_arena;
    hold on
    if  ~isempty(PRMs{r}.edge)
        % Plot edges
        i = 1;
        v1 = zeros(2, 3*size(PRMs{r}.edge,1));
        for e=PRMs{r}.edge(:,:)'
            v1(:, i) = PRMs{r}.vertex(e(1),:);
            v1(:, i+1) = PRMs{r}.vertex(e(2),:);
            v1(:, i+2) = [NaN;NaN];
            i = i+3;
        end
        plot(v1(1, :), v1(2, :), 'LineStyle', '-.', 'LineWidth', 0.1,...
            'Color', 'black');
    end
    % Plot nodes
    nodeList = PRMs{r}.vertex';
    scatter(nodeList(1, 1:end-2),nodeList(2, 1:end-2), 15, 'Marker', 'o', ...
        'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r');
    scatter(nodeList(1, end-1),nodeList(2, end-1), 100, 'Marker', 'o', ...
        'MarkerFaceColor', robot_color(r), 'MarkerEdgeColor', robot_color(r));
    scatter(nodeList(1, end),nodeList(2, end), 100, 'Marker', 'o', ...
        'MarkerFaceColor', 'black', 'MarkerEdgeColor', robot_color(r));
    xlabel('X position [m]')
    ylabel('Y position [m]')
    title(['Individual PRM of Robot ',num2str(r)])
end

% Plotting an animated resulting behavior of multi-robot case
figure(number_of_robots+1);
x_coor = zeros(number_of_robots,10);
y_coor = zeros(number_of_robots,10);
for i = 1:length(path)-1
    for r = 1:number_of_robots
        x_coor(r,:) = linspace(PRMs{r}.vertex(imp_tree(path(i),r),1),PRMs{r}.vertex(imp_tree(path(i+1),r),1),10);
        y_coor(r,:) = linspace(PRMs{r}.vertex(imp_tree(path(i),r),2),PRMs{r}.vertex(imp_tree(path(i+1),r),2),10);
    end
    for step = 1:10
        clf;
        xlabel('X position [m]')
        ylabel('Y position [m]')
        title('Solution Animation of All Robots')
        draw_arena;
        hold on 
        for r = 1:number_of_robots
            rectangle('Position',[PRMs{r}.vertex(imp_tree(target_node,r),1)-0.1 PRMs{r}.vertex(imp_tree(target_node,r),2)-0.1 0.2 0.2],...
                'Curvature',[1 1],'FaceColor','none','EdgeColor',robot_color(r),'LineWidth',2); % Target points
            rectangle('Position',[x_coor(r,step)-0.1 y_coor(r,step)-0.1 0.2 0.2],...
                'Curvature',[1 1],'FaceColor',robot_color(r),'EdgeColor',robot_color(r)); % Current locations
        end
        pause(0.2)
        hold off
    end
end


end