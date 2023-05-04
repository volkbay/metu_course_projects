function [colors, start, target] = init_robots(case_number)

% Here for each case, number of robots, colors and start/goal locations are
% determined.
%
% Volkan OKBAY, 2018. MATLAB 2016a Student Edition

    global number_of_robots
    switch case_number
        case 1
            number_of_robots = 3;
            start(1,:) = [1 1];
            target(1,:) = [9 9];
            start(2,:) = [2 1];
            target(2,:) = [7 3];            
            start(3,:) = [3 1];
            target(3,:) = [9 8];
        case 2
            number_of_robots = 4;
            start(1,:) = [3 3];
            target(1,:) = [7 8];
            start(2,:) = [2 6];
            target(2,:) = [8.6 3];            
            start(3,:) = [5 3];
            target(3,:) = [4.5 8.7];
            start(4,:) = [6 5];
            target(4,:) = [2 4];
        case 3
            number_of_robots = 3;
            start(1,:) = [3.5 2];
            target(1,:) = [8.5 1];
            start(2,:) = [8.5 1];
            target(2,:) = [3.5 2];            
            start(3,:) = [1.5 5.2];
            target(3,:) = [7 4];
        case 4
            number_of_robots = 4;
            start(1,:) = [1 2];
            target(1,:) = [4.5 3];
            start(2,:) = [1 3];
            target(2,:) = [4.5 5];            
            start(3,:) = [1 4];
            target(3,:) = [7.5 3];
            start(4,:) = [1 5];
            target(4,:) = [7.5 5];
        case 5
            number_of_robots = 4;
            start(1,:) = [1.5 2];
            target(1,:) = [8.5 8];
            start(2,:) = [4.5 2];
            target(2,:) = [7 8];            
            start(3,:) = [1.5 5];
            target(3,:) = [1.5 7];
            start(4,:) = [8 1.5];
            target(4,:) = [3 7.5];
        case 6
            number_of_robots = 4;
            start(1,:) = [3.7 2.6];
            target(1,:) = [3.7 6.5];
            start(2,:) = [3.7 6.5];
            target(2,:) = [3.7 2.6];            
            start(3,:) = [6.5 2.6];
            target(3,:) = [6.5 6.5];
            start(4,:) = [6.5 6.5];
            target(4,:) = [6.5 2.6];
        case 7
            number_of_robots = 3;
            start(1,:) = [1.9 1.1];
            target(1,:) = [7.9 1.1];
            start(2,:) = [2.1 1.1];
            target(2,:) = [6.9 1.1];            
            start(3,:) = [3.1 1.1];
            target(3,:) = [5.9 1.1]; 
        case 8
            number_of_robots = 3;
            start(1,:) = [3 5];
            target(1,:) = [8 8];
            start(2,:) = [4 1];
            target(2,:) = [3 8];            
            start(3,:) = [8 2];
            target(3,:) = [1.5 4];
        otherwise
            number_of_robots = 2;
            start(1,:) = [4 4];
            target(1,:) = [6 6.5];
            start(2,:) = [1 1];
            target(2,:) = [9 9];  
    end
    
    colors = char(1,number_of_robots);
    color_chart = ['r' 'g' 'b' 'y' 'm' 'c' 'k'];
    for i = 1:number_of_robots
        colors(i) = color_chart(mod(i-1,7)+1);
    end
end
