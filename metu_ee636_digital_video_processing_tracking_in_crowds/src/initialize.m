% This script is designed for METU EE636: Digital Video Processing course
% Design Engineer: Volkan OKBAY
% Date           : 04/06/2016 - 15:45
% referencing Trackin in High Density Crowds (ECC2008, M.Shah, S.Ali)
% on MATLAB 2015b
% for details see paper, manual and report.
%--------------------------------------------------------------------------
clear 
close all
tic
%% Parameters
%----------% Main parameter
video_file = 'maraton.mov'; % Full name of the video file located in either project folder or in \Vid subfolder
%----------% SFF: Optical Flow
frameCount = 20; % First N frames to consider in SFF calculation (def: 20)
frameNumber_average = 5; % To eliminate first N frames due to camera calibration distortions in the beginning (def: 5)
SFF_factor = 16; % Optical flow gain (def: frameCount-frameNumber_average+1)
%----------% SFF: Sink-seek
block_y = 10; % Grid size in y (for faster implementation) (def: 10)
block_x = 10; % Grid size in x (for faster implementation) (def: 10)
bwarea_para = 3000; % Area threshold (to get edge map masking) (def: 3000 pixels, pixels in a frame/100)
h = 10; % Default value for h (see paper, Kernel Density formula) (def: 10)
window_size = 3; % Kernel density window size (see paper, Kernel Density formula) (def: 3)
sink_step_limit = 500; % Maximum step size (prevent infinite sink steps) (def: 500 steps)
%----------% BFF
bwarea_para_BFF = 3000; % Thresholding optical flow field to find boundaries and barriers (def:3000 pixels, typically same with bwarea_para)
% Note that, for further adjustments, two strels under BFF section can be
% changed in order to debug BFF or to test BFF in different cases.
%% Add Project Paths and Create Video File Reader
[proj_path,~,~] = fileparts(which('initialize'));
addpath([proj_path '\Vid'],[proj_path '\Aux_func']); % Adding relevant path
maraton = VideoReader(video_file); % Create video reader
%% Point Flow Vector
% Here, frameCount frames are read and consequent optical flow vectors are calculated.
opticFlow = opticalFlowFarneback;
frameNumber = 1;
maraton.CurrentTime = 0;
flow = opticalFlow;

while frameNumber < frameCount
    frameRGB = readFrame(maraton);
    frameGray = rgb2gray(frameRGB);
    flow(frameNumber) = estimateFlow(opticFlow,frameGray);
    frameNumber=frameNumber+1;
end

video_size = [size(frameGray,1) size(frameGray,2)]; % Video frame size of the video
%% Average PFV (Point Flow Field, Optical Flow Field)
% Here, stacked optical flow layers are averaged.
count = 1;
resultFlow = struct('Vx',flow(2).Vx,'Vy',flow(2).Vy);

for frameNumber = frameNumber_average:(frameCount-1)
    resultFlow.Vx = resultFlow.Vx + flow(frameNumber).Vx; 
    resultFlow.Vy = resultFlow.Vy + flow(frameNumber).Vy; 
    frameNumber = frameNumber + 1;
    count = count + 1;
end
resultFlow.Vx = resultFlow.Vx / count * SFF_factor;
resultFlow.Vx = resultFlow.Vx / count * SFF_factor;
resultPlotFlow = opticalFlow(resultFlow.Vx, resultFlow.Vy);
%% VISUALIZE (Average Flow Field for SFF)
% imshow(frameRGB)
% hold on
% plot(resultPlotFlow,'ScaleFactor',10)
% hold off
%% Gridding Image (for faster implementation of SFF)
threshold = graythresh(sqrt(resultFlow.Vx.^2+resultFlow.Vy.^2)); % Intensity threshold (to get edge map masking)
I = double(sqrt(resultFlow.Vx.^2+resultFlow.Vy.^2)>threshold);
I = bwareaopen(I,bwarea_para); % Binary mask for grids
%% VISUALIZE(Grid centers, SFF points to be considered)
% imshow(zeros(size(frameGray)))
% hold on
% for hor = 1:ceil(size(frameGray,2)/block_x)-1
%     for ver = 1:ceil(size(frameGray,1)/block_y)-1
%         center = [(hor-1/2)*block_x (ver-1/2)*block_y];
%         if(any(I(center(2)-block_y/2+1:center(2)+block_y/2+1,center(1)-block_x/2+1:center(1)+block_x/2+1)))
%         plot(center(1),center(2),'o','Color','yellow','MarkerSize',1,'MarkerFaceColor','yellow');
%         end
%     end
% end
% hold off
%% Sink-Seeking by Gridding
% Using average optical flow field information, we will find SFF (Statical
% Floor Field.
W = zeros(2*window_size+1,2*window_size+1); % Kernel Density window
Z(200) = struct('Pos',[0 0],'Vel',[0 0]); % Sink-seeking steps
SFF = zeros(size(frameGray)); % SFF pre-allocation

for hor = 1:ceil(size(SFF,2)/block_x)-1 % Sink-seeking for each grid center point
    for ver = 1:ceil(size(SFF,1)/block_y)-1
        center = [(hor-1/2)*block_x (ver-1/2)*block_y]; % Grid center point
        if(any(I(center(2)-block_y/2+1:center(2)+block_y/2+1,center(1)-block_x/2+1:center(1)+block_x/2+1)))
        initial_point = [center(1) center(2)];
        Z(1).Pos = initial_point; % First sink step
        Z(1).Vel = [resultFlow.Vx(initial_point(2),initial_point(1)) resultFlow.Vy(initial_point(2),initial_point(1))];
        sink_step = 1;
        distance = 0;
        while(1)
            sum1 = [0 0];
            sum2 = 0;
            Z(sink_step+1).Pos = ceil(Z(sink_step).Pos + Z(sink_step).Vel); % Next sink position 
            distance = norm(Z(sink_step).Vel) + distance; % Distance so far
            y = Z(sink_step+1).Pos(2);
            x = Z(sink_step+1).Pos(1);
            % Kernel Density Formulation
            if (y+window_size<=size(frameGray,1))&&(x+window_size<=size(frameGray,2))&&(y-window_size>=1)&&(x-window_size>=1)
                h = norm([std2(resultFlow.Vx(y-window_size:y+window_size,x-window_size:x+window_size)) std2(resultFlow.Vy(y-window_size:y+window_size,x-window_size:x+window_size))]);
            end
            for m = -window_size:window_size
                for n = -window_size:window_size
                    if (y+m<=size(frameGray,1))&&(x+n<=size(frameGray,2))&&(y+m>=1)&&(x+n>=1)&&~(m==0&&n==0)    
                    W(m+window_size+1,n+window_size+1) = max(exp(-norm((Z(sink_step).Vel - [resultFlow.Vx(y+m,x+n) resultFlow.Vy(y+m,x+n)])/h)^2) , 0.1);
                    sum1 = sum1 + [resultFlow.Vx(y+m,x+n) resultFlow.Vy(y+m,x+n)]*W(m+window_size+1,n+window_size+1);
                    sum2 = sum2 + W(m+window_size+1,n+window_size+1);
                    end
                end
            end
            Z(sink_step+1).Vel = sum1 ./ sum2; % Next sink velocity
            % Sink-seeking termination conditions
            if ((sink_step > 2)&&(isequal(Z(sink_step-1:sink_step).Pos)))||(any(isnan(Z(sink_step+1).Vel)))||(sink_step>sink_step_limit)
                break;
            end
            sink_step = sink_step + 1; % Otherwise move to next step
        end
        SFF(center(2)-block_y/2+1:center(2)+block_y/2+1,center(1)-block_x/2+1:center(1)+block_x/2+1) = distance; % Assign total sink distance to SFF
        end
    end
end
SFF = SFF/ max(SFF(:)); % Normalize SFF
%% VISUALIZE(SFF, Static Floor Field)
% surf_handle = surf(SFF);
% set(surf_handle,'LineStyle','none');
% set(gca,'Xdir','reverse')
% figure
% imshowpair(frameRGB,SFF)
%% BFF
I = double(sqrt(resultFlow.Vx.^2+resultFlow.Vy.^2)>threshold);
I1 = imopen(I,strel('diamond',20));
I2 = imerode(I1,strel('disk',15));
I3 = bwareaopen(I2,bwarea_para_BFF);
I4 = bwdist(bwperim(I3));
I5 = I4/10;
I5(I5>5) = max(I5(:));
BFF = I5;
BFF = BFF/ max(BFF(:)); % Normalize BFF
%% VISUALIZE(BFF, Boundary Floor Field)
% figure
% surf_handle = surf(I5);
% shading interp
%% End of initialization
init_time = toc
fprintf('DONE!\n');