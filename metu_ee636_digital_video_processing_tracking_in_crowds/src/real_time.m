% This script is designed for METU EE636: Digital Video Processing course
% Design Engineer: Volkan OKBAY
% Date           : 04/06/2016 - 15:45
% referencing Trackin in High Density Crowds (ECC2008, M.Shah, S.Ali)
% on MATLAB 2015b
% for details see paper, manual and report.
%--------------------------------------------------------------------------
close all
%% Parameters
real_time_duration = maraton.Duration*maraton.FrameRate; % Total frame count in the video file (def: maraton.Duration*maraton.FrameRate, video duration)
%----------% DFF
frameCountDFF = 10; % Time window for DFF (def: 10)
osize = [5 10]; % Object size (def:3 7 - 6x15 window)
window_size = 8; % Search window for next position (def:8 - 17x17 window)
DFF_factor = 5; % Gain of effect of DFF on the next position vector (def: 5)
%----------% Main probabilistic equation (see the main equation in the paper)
Ks = 0.2; % Weight of SFF (def: 0.2)
Kb = 0.2; % Weight of BFF (def: 0.2)
Kd = 0.5; % Weight of DFF (def: 0.2)
Kr = 10; % Weight of R (def: 1, not mentioned in the paper)
%% Implementation
videoPlayer = vision.VideoPlayer('Position', [0 0 [video_size(1), video_size(2)]+600],'Name', 'EE636 Project: Real-time representation');
videoFileReader = vision.VideoFileReader(video_file);
flowDFF = opticalFlow; % Preallocate optical flow
opticFlowDFF = opticalFlowLK;
% Point select GUI
maraton.CurrentTime = 0;
handle = imshow(readFrame(maraton)); % Show first frame and wait for user to pick an object
h = impoint(gca,195,350);
wait(h); % Wait for user
initial = round(getPosition(h)); % Get object point
p = zeros(2*window_size+1); % Preallocate probability map
xyPoints = [ ]; % Tracked point history
%Read first $frameCountDFF frames 
maraton.CurrentTime = 0;
frame = zeros(video_size(1),video_size(2),frameCountDFF+1);
for frameNumberDFF = 1:frameCountDFF
    frame(:,:,frameNumberDFF) = rgb2gray(readFrame(maraton));
end
%% Real-time part
frameNumber = 1;
while frameNumber < real_time_duration
    startTime = tic;
    if frameNumber == 1 % Assign center point
        center = initial;
    else
        center = next_center; % Update center
    end
    frame(:,:,frameCountDFF+1) = rgb2gray(readFrame(maraton)); % Read one more frame for DFF calculation
%% DFF
    frameNumberDFF = 1;
    DFFx = zeros(window_size*6+1,window_size*6+1);
    DFFy = zeros(window_size*6+1,window_size*6+1);
    while frameNumberDFF <= frameCountDFF+1
        full_frameDFF = padarray(frame(:,:,frameNumberDFF),[window_size*3 window_size*3],'symmetric','both');
        frameDFF = full_frameDFF(center(2):center(2)+6*window_size,center(1):center(1)+6*window_size);
        flowDFF(frameNumberDFF) = estimateFlow(opticFlowDFF,frameDFF);
        if frameNumberDFF ~= 1 % Do not take first optical flow
            DFFx = flowDFF(frameNumberDFF).Vx + DFFx;
            DFFy = flowDFF(frameNumberDFF).Vy + DFFy;
        end
        frameNumberDFF = frameNumberDFF+1;
    end
    DFF_next_x = sum(sum(DFFx(ceil(end/2)-osize(2):ceil(end/2)+osize(2),ceil(end/2)-osize(1):ceil(end/2)+osize(1)),'omitnan'))/(frameCountDFF*(osize(1)*2+1)*(osize(2)*2+1));
    DFF_next_y = sum(sum(DFFy(ceil(end/2)-osize(2):ceil(end/2)+osize(2),ceil(end/2)-osize(1):ceil(end/2)+osize(1)),'omitnan'))/(frameCountDFF*(osize(1)*2+1)*(osize(2)*2+1));
    DFF_next_point = round(DFF_factor*[DFF_next_x DFF_next_y]); % Most probable next point vector resulted by DFF
    DFF = zeros(window_size*2+1,window_size*2+1);
    if window_size < abs(DFF_next_point(2)) % If next DFF point exceeds limit
        DFF_next_point(2) = sign(DFF_next_point(2))*window_size;
    end
    if window_size < abs(DFF_next_point(1)) % If next DFF point exceeds limit
        DFF_next_point(1) = sign(DFF_next_point(1))*window_size;
    end
    DFF(ceil(end/2)+DFF_next_point(2),ceil(end/2)+DFF_next_point(1)) = 1; % Mark DFF_next_point in neighborhood matrix
    DFF = imfilter(DFF,fspecial('gaussian',[10 10],5)); % Place a 3-D Gaussian on the most probable point (suggested by DFF)
    DFF = DFF / max(DFF(:)); % Normalize
    DFF = 1 - DFF; % Take reverse because minimum value is higher probability
%% VISUALIZE(DFF, Dynamic Floor Field)
% Note that, to visualize DFF, please set real_time_duration parameter to
% 2 or somehow step real time 'while loop' (e.g. with breakpoints).
%     resultFlowDFF = opticalFlow( DFFx/frameCountDFF, DFFy/frameCountDFF);
%     imshow(frameDFF,[])
%     hold on
%     plot(resultFlowDFF,'ScaleFactor',1)
%     hold off
%% VISUALIZE(DFF, Gaussian placed on the most probable point)
%     surf(1-DFF);
%     title('Dynamic Floor Field in local neighborhood')
%% Similarity Parameter (R)
    if frameNumber ~= 1 % Template of object in the previous frame
        template = frameGray(center(2)+window_size:center(2)+2*osize(2)+window_size,center(1)+window_size:center(1)+2*osize(1)+window_size);
    end 
    frameRGB = step(videoFileReader); % Read current frame
    frameGray = rgb2gray(frameRGB);
    frameGray = padarray(frameGray,[window_size+osize(2) window_size+osize(1)],'symmetric','both');       
    if frameNumber == 1 % If it is first frame under process, there is no previous frame template
        template = frameGray(center(2)+window_size:center(2)+2*osize(2)+window_size,center(1)+window_size:center(1)+2*osize(1)+window_size);
    end    
    window = frameGray(center(2):center(2)+2*window_size+2*osize(2),center(1):center(1)+2*window_size+2*osize(1));
    H = normxcorr2(template,window); % Template matching in each step
    H = (H - min(H(:)))./(max(H(:)) - min(H(:))); % Normalize
    R = H(osize(2)*2+1:size(H,1)-osize(2)*2,osize(1)*2+1:size(H,2)-osize(1)*2);
    R = 1 - R; % Take reverse
%% VISUALIZE(R, similarity template)
%     surf(1-R);
%     title('Normalized Phase Correlation for Template Matching')    
%% Final Probability Equation
    for a = -window_size:window_size
        for b = -window_size:window_size
            % Combine local SFF, BFF, DFF and R information
            p(b+window_size+1,a+window_size+1) = exp(Ks*SFF(b+center(2),a+center(1)))*exp(Kb*BFF(b+center(2),a+center(1)))*exp(Kd*DFF(b+window_size+1,a+window_size+1))*exp(Kr*R(b+window_size+1,a+window_size+1));
        end
    end
    [min_prob, next_index] = min(p(:)); % Find most likely next point
    [next_center(2), next_center(1)] = ind2sub(size(p),next_index);
    next_center = next_center - [window_size+1 window_size+1] + center;  
%% GUI Printing Result
% Create visual representation for current bounding box and visited
% points on the RGB frame. Then print it on the screen.
    bboxPoints = bbox2points([center(1)-osize(1) center(2)-osize(2) osize(1)*2 osize(2)*2]);
    bboxPolygon = reshape(bboxPoints', 1, []); % Bounding box
    videoFrame = insertShape(frameRGB, 'Polygon', bboxPolygon, 'LineWidth', 1);
    xyPoints = cat(1,xyPoints,center); % Visited points
    videoFrame = insertMarker(videoFrame, xyPoints, '+', 'Color', 'white');
    step(videoPlayer, videoFrame); % Print on the screen
    frameNumber = frameNumber + 1; % Next frame
    frame = circshift(frame,-1,3); % Shift queue of frames
toc(startTime)
end