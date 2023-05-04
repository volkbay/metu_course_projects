% StereoSnakes Main Function (for METU-EE 584: Machine Vision Term Project)
% V.Okbay, B.Baydar (2016)
% Originated by Ju_StereoSnakes_Contour_Based_ICCV_2015_paper
% See parameters section, original paper, report and presentation included 
% for detail.
%
% TO RUN, store stereo images with 'name0.*' and 'name1.*' namings. Use
% defined segmentation methods OR also create a user-defined binary mask 
% with the appropriate name 'namem.*'. Adjust parameters for a better result.

function varargout = StereoSnake_GUI(varargin)
% STEREOSNAKE_GUI MATLAB code for StereoSnake_GUI.fig
%      STEREOSNAKE_GUI, by itself, creates a new STEREOSNAKE_GUI or raises the existing
%      singleton*.
%
%      H = STEREOSNAKE_GUI returns the handle to a new STEREOSNAKE_GUI or the handle to
%      the existing singleton*.
%
%      STEREOSNAKE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STEREOSNAKE_GUI.M with the given input arguments.
%
%      STEREOSNAKE_GUI('Property','Value',...) creates a new STEREOSNAKE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before StereoSnake_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to StereoSnake_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help StereoSnake_GUI

% Last Modified by GUIDE v2.5 14-Jun-2016 22:47:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @StereoSnake_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @StereoSnake_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before StereoSnake_GUI is made visible.
function StereoSnake_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to StereoSnake_GUI (see VARARGIN)

[proj_path,~,~] = fileparts(which('StereoSnake_GUI.m'));
addpath([proj_path '\Mask'],[proj_path '\Images'],[proj_path '\Quantum Cuts'],[proj_path],[proj_path '\Quantum Cuts\EQCUT-Matlab-Code-master']); % Adding relevant paths
handles.proj_path = proj_path;
% Choose default command line output for StereoSnake_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes StereoSnake_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = StereoSnake_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function image_name_Callback(hObject, eventdata, handles)
% hObject    handle to image_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of image_name as text
%        str2double(get(hObject,'String')) returns contents of image_name as a double
handles.image_name_val = get(hObject,'Value');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function image_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to image_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.image_name_val = 1;
handles.image_name_var = get(hObject,'String');
guidata(hObject,handles);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Parameters
tau_d = str2num(get(handles.edit2,'String')); % Relative disparity range (def: 1)
w = str2num(get(handles.edit3,'String')); % Spatial window for Co and Cs energies (def: 13, 13x13 window)
lambda_o = str2num(get(handles.edit4,'String')); % Co coefficient, makes Co effect more significant (def: 0.6, typ: 0.5 - 3)
lambda_s = str2num(get(handles.edit5,'String')); % Dynamic optimization coefficient. When high, input shape is more conserved. (def:30)  
image_name = handles.image_name_var(handles.image_name_val); % Processed image (typ: 'bin', 'bag', 'child', 'lion' and 'shelf') or user defined image.
image_ext = handles.image_ext; % Image file extension (def: '.png')
% Disparity range calculation
dmin = handles.dmin;
dmax = handles.dmax;
handles.d = handles.dmin : handles.dmax;
handles.D = numel(handles.d);
d = handles.d; % Disparity range
D = handles.D; % # of disparity units
shift_amount = round(str2double(get(handles.edit8,'String'))*handles.L / 100);
p = circshift(handles.p_init,-shift_amount); % Shift start point of the contour
L = handles.L;
global I_mask I_left I_right w prob_map
I_mask = handles.I_mask;
I_left = handles.I_left;
I_right = handles.I_right;
prob_map = handles.prob_map;

% State transition matrix calculation
tic
M = zeros(L,D);
tau_str = linspace(-tau_d,tau_d,2*tau_d+1); % All relative disparities string
for i = 1:L
    for j = 1:D
        M(i,j) = lambda_o*Co(p(i,:),d(j)) + Cs(p(i,:),d(j))/(3*255); % Calculate Co and Cs energy contributions
    end
end

for i = 2:L
    for j = 1:D  % State energy functions are calculated by adding dynamic optimization energies. (lambda_s * N)
            [~,idx_str] = find((D+1>j+tau_str)& (j+tau_str>0));
            M(i,j) = min([ M(i-1,j+tau_str(idx_str)) + lambda_s*abs(tau_str(idx_str))]) + M(i,j);
    end
end
% Minimum energy path traceback
p_out = zeros(size(p)); % Holds the estimated positions in the second stereo image (output contour)
disp_val = zeros(L,1); % Holds final disparity for each contour point
[~, idx] = min([M(L,1:D)]); % Tracing back starting from the last contour point
disp_val(L) = d(idx); % Find minimum energy disparity and calculate the new point in the second stereo image
p_out(L,2) = p(L,2) - disp_val(L);
p_out(L,1) = p(L,1);
for counter = 1:L-1 % Calculate minimum energy disparities and assign output coordinates for the rest of the contour
    i = L - counter;
    d_idx = find(d == disp_val(i+1));
    [~,idx_str] = find((D+1>d_idx+tau_str)& (d_idx+tau_str>0));
    [~, idx] = min([ M(i,d_idx+tau_str(idx_str)) ]);
    dummy_str = d_idx+tau_str(idx_str);
    disp_val(i) = d(dummy_str(idx));

    p_out(i,2) = p(i,2) - disp_val(i);
    p_out(i,1) = p(i,1);
end
handles.time = toc;
handles.disp_val = disp_val;
axes(handles.axes6);
handles.hleft = imshow(I_left);
hold on
   plot(p(:,2), p(:,1), 'w', 'LineWidth', 2)
   plot(p(1,2), p(1,1), 'square', 'MarkerSize',10,'MarkerEdgeColor','white','MarkerFaceColor','red')
hold off
title(['Input Stereo Image of a ' image_name]);
handles.p = p;
set(handles.hleft,'ButtonDownFcn',@LeftButtonFcn);
guidata(handles.hleft,handles);
children_list = get(get(handles.hleft,'Parent'),'Children');
children_list(1).HitTest = 'off';
children_list(2).HitTest = 'off';
children_list(1).PickableParts = 'none';
children_list(2).PickableParts = 'none';
axes(handles.axes7);
handles.hright = imshow(I_right);
hold on
   plot(p_out(:,2), p_out(:,1), 'w', 'LineWidth', 2)
   line([p_out(L,2) p_out(1,2)],[p_out(L,1) p_out(1,1)], 'LineWidth', 2, 'Color', 'w')
   plot(p_out(1,2), p_out(1,1), 'square', 'MarkerSize',10,'MarkerEdgeColor','white','MarkerFaceColor','red')
hold off
title(['Estimated Output Stereo Contour with \tau_{d} = ' num2str(tau_d) ' ,\lambda_{o}= ' num2str(lambda_o) ' ,\lambda_{s}= ' num2str(lambda_s) ' ,d = ' num2str(dmin) ':' num2str(dmax)]);
handles.p_out = p_out;
set(handles.hright,'ButtonDownFcn',@RightButtonFcn);
children_list = get(get(handles.hright,'Parent'),'Children');
children_list(1).HitTest = 'off';
children_list(2).HitTest = 'off';
children_list(3).HitTest = 'off';
children_list(1).PickableParts = 'none';
children_list(2).PickableParts = 'none';
children_list(3).PickableParts = 'none';
handles.result = getframe;
set(handles.text19,'String',['DONE in ' num2str(handles.time) ' seconds.']);
guidata(hObject,handles);

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
if get(hObject,'Value') == 1
    I_mask = handles.I_mask;
    prob_map = handles.prob_map;
    input_x_center = sum(sum( I_mask.*repmat(1:size(I_mask,2),size(I_mask,1),1))) / sum(sum(I_mask));
    predict_thr = 0.8;
    predict_mask = imopen(imfill(prob_map>predict_thr,'holes'),strel('disk',10));
    output_x_center = sum(sum( predict_mask.*repmat(1:size(I_mask,2),size(I_mask,1),1))) / sum(sum(predict_mask));
    disp_predict = round(input_x_center - output_x_center);
    disp_range = str2num(get(handles.edit9,'String'));
    handles.dmin = round(disp_predict - disp_range/2);
    handles.dmax = round(disp_predict + disp_range/2);
    set(handles.edit6,'String',num2str(handles.dmin));
    set(handles.edit6,'ForegroundColor','red');
    set(handles.edit7,'String',num2str(handles.dmax));
    set(handles.edit7,'ForegroundColor','red');
else
    set(handles.edit6,'String',num2str(handles.dmin_entered));
    set(handles.edit6,'ForegroundColor','black');
    set(handles.edit7,'String',num2str(handles.dmax_entered));
    set(handles.edit7,'ForegroundColor','black');
    handles.dmin = handles.dmin_entered;
    handles.dmax = handles.dmax_entered;
end
guidata(hObject,handles);

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
handles.dmin = str2num(get(hObject,'String'));
handles.dmin_entered = handles.dmin;
handles.dmax = str2num(get(handles.edit7,'String'));
handles.dmax_entered = handles.dmax;
set(hObject,'ForegroundColor','black');
set(handles.edit7,'ForegroundColor','black');
set(handles.checkbox1,'Value',0);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.dmin = str2num(get(hObject,'String'));
handles.dmin_entered = handles.dmin;
guidata(hObject,handles);



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
handles.dmax = str2num(get(hObject,'String'));
handles.dmax_entered = handles.dmax;
handles.dmin = str2num(get(handles.edit6,'String'));
handles.dmin_entered = handles.dmin;
set(hObject,'ForegroundColor','black');
set(handles.edit6,'ForegroundColor','black');
set(handles.checkbox1,'Value',0);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.dmax = str2num(get(hObject,'String'));
handles.dmax_entered = handles.dmax;
guidata(hObject,handles);



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double
if get(handles.checkbox1,'Value') == 1
    I_mask = handles.I_mask;
    prob_map = handles.prob_map;
    input_x_center = sum(sum( I_mask.*repmat(1:size(I_mask,2),size(I_mask,1),1))) / sum(sum(I_mask));
    predict_thr = 0.8;
    predict_mask = imopen(imfill(prob_map>predict_thr,'holes'),strel('disk',10));
    output_x_center = sum(sum( predict_mask.*repmat(1:size(I_mask,2),size(I_mask,1),1))) / sum(sum(predict_mask));
    disp_predict = round(input_x_center - output_x_center);
    disp_range = str2num(get(hObject,'String'));
    handles.dmin = round(disp_predict - disp_range/2);
    handles.dmax = round(disp_predict + disp_range/2);
    set(handles.edit6,'String',num2str(round(disp_predict - disp_range/2)));
    set(handles.edit6,'ForegroundColor','red');
    set(handles.edit7,'String',num2str(round(disp_predict + disp_range/2)));
    set(handles.edit7,'ForegroundColor','red');
end
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.radiobutton1,'Value') == 1
    %Define Ground Truth (GT) and Image (IM) Paths
    path_IM= [handles.proj_path '\Images\'];
    %Define Output Folder (OUT) Path
    path_OUT = [handles.proj_path '\Quantum Cuts\'];
    %Change the extension accordingly
    contents=dir([path_IM handles.image_comp_name]);
   
    for i=1:length(contents)
        name=contents(i).name;
        name=name(1:end-4);
        imname=strcat(path_IM,name,'.png');
        image_now=(imread(imname));
        
        %if image is gray-level convert it to RGB by repeating the gray level
        %image for each channel
        if length(size(image_now))==2;
            image_now=repmat(image_now,[1 1 3]);
        end
        
        %Check if the image contains any frames and exclude them
        [image_now,w]=removeframe(image_now);
        
        %Run EQCUT for several resolutions (Original square-root of expected
        %superpixel areas: 10,15,20 and regularizer 20 is kept, for images
        %around 300x400) For larger/smaller images, please consider changing
        %these prameters.
        [SalMapRes1]=EQCUT(image_now,10,20,1,1);
        [SalMapRes2]=EQCUT(image_now,15,20,1,1);
        [SalMapRes3]=EQCUT(image_now,20,20,1,1);
        
        %Average Over Resolutions
        SalMap=mat2gray(SalMapRes1)+mat2gray(SalMapRes2)+mat2gray(SalMapRes3);
        
        %Map Back to the Original Image (if frames were excluded)
        SalMapOrig=zeros(w(1),w(2));
        SalMapOrig(w(3):w(4),w(5):w(6))=SalMap;
        
        %Discretize the Saliency Map to uint8 format
        SalMapFinal=uint8(mat2gray(SalMapOrig)*255);
        handles.quantum_out = SalMapFinal;
        handles.I_mask = SalMapFinal > str2num(get(handles.edit11,'String'));
    end
elseif get(handles.radiobutton2,'Value') == 1
    file_strm = sprintf(['%sm%s'],handles.image_name_root, handles.image_ext);
    handles.I_mask = imread(file_strm); % Input image mask (must be logical formatted)
elseif get(handles.radiobutton3,'Value') == 1
    h = imfreehand(handles.axes6);
    wait(h);
    handles.I_mask = createMask(h);
end
I_contour = bwboundaries(handles.I_mask,'noholes'); % Contour extraction 
p = I_contour{1};
handles.p_init = flipdim(p,1); % Sort contour pixels in ccw direction
handles.L = numel(p)/2; % # of contour pixels
handles.prob_map = histprobmap(handles.I_left, handles.I_right, handles.I_mask); % Calculate Pr(O|py), to be used in Co
imshow(handles.I_mask,'parent',handles.axes8);
set(handles.text19,'String','The mask is created.');
guidata(hObject,handles);
    

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.image_name_val == 6
    [~,name_str,handles.image_ext] = fileparts(get(handles.edit10,'String'));
    handles.image_name_root = name_str(1:end-1);
    if name_str(end) == '0'
        file_str0 = sprintf(['%s0%s'],handles.image_name_root, handles.image_ext);
        file_str1 = sprintf(['%s1%s'],handles.image_name_root, handles.image_ext);
    elseif name_str(end) == '1'
        file_str0 = sprintf(['%s1%s'],handles.image_name_root, handles.image_ext);
        file_str1 = sprintf(['%s0%s'],handles.image_name_root, handles.image_ext);
    end
else
    handles.image_ext = get(handles.edit10,'String');
    dummy_cell = handles.image_name_var(handles.image_name_val);
    file_str0 = sprintf(['%s0%s'],dummy_cell{1}, handles.image_ext);
    file_str1 = sprintf(['%s1%s'],dummy_cell{1}, handles.image_ext);
    handles.image_name_root = dummy_cell{1};
end
    handles.image_comp_name = file_str0;
    handles.I_left = imread(file_str0); % Input image (may be right image, too. Do not rely on naming.)
    handles.I_right = imread(file_str1); % Second stereo image
    axes(handles.axes6);
    imshow(handles.I_left);
    axes(handles.axes7);
    imshow(handles.I_right);
    set(handles.edit2,'String',1);
    set(handles.edit3,'String',13);
    set(handles.edit4,'String',0.6);
    set(handles.edit5,'String',30);
    set(handles.edit6,'String',10);
    handles.dmin = 10;
    handles.dmin_entered = 10;
    set(handles.edit7,'String',70);
    handles.dmax = 70;
    handles.dmax_entered = 70;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes_title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_title
imshow(imread('eye.png'));


% --- Executes during object creation, after setting all properties.
function axes6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes6
imshow(zeros(100,100),'parent',hObject);

% --- Executes during object creation, after setting all properties.
function axes7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes7
imshow(zeros(100,100),'parent',hObject);


% --- Executes during object creation, after setting all properties.
function axes8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes8
imshow(zeros(100,100));


% --------------------------------------------------------------------
function uipushtool2_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imwrite(handles.result.cdata,'result.png');


% --- Executes during object creation, after setting all properties.
function text17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'String', 'Click on a segmentation method to see info text!');

% --- Executes when selected object is changed in uipanel5.
function uipanel5_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel5 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if get(handles.radiobutton1,'Value') == 1
    set(handles.uipanel9,'Visible','on');
    set(handles.text17,'String', 'Use QuantumCut Segmentation to create a mask of first image (on the left). Hit "Create Mask", wait for approx 30 sec. Then adjust threshold to capture desired object.');
elseif get(handles.radiobutton2,'Value') == 1
    set(handles.uipanel9,'Visible','off');
    set(handles.text17,'String', 'Load mask from disk. Make sure that mask image is in binary form, has the same extension with input images and named "*m.*" form.');
elseif get(handles.radiobutton3,'Value') == 1
    set(handles.uipanel9,'Visible','off');
    set(handles.text17,'String', 'Use MATLAB free hand tool to draw a draggable contour on the first image (on the left). Releasing mouse button will automatically close the contour. When finished double-click on the screen.');
end;
guidata(hObject, handles);
    
% --- Executes during object creation, after setting all properties.
function text19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'String',[{'1-) Specify image group name.'};{'2-) Load images.'};{'3-) Specify masking method, create mask.'};{'4-) Adjust parameters (use auto-disparity and/or contour start point shift features).'};{'5-) Hit RUN STEREOSNAKES.'}]); 



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.I_mask = handles.quantum_out> str2num(get(handles.edit11,'String'));
I_contour = bwboundaries(handles.I_mask,'noholes'); % Contour extraction 
p = I_contour{1};
handles.p_init = flipdim(p,1); % Sort contour pixels in ccw direction
handles.L = numel(p)/2; % # of contour pixels
handles.prob_map = histprobmap(handles.I_left, handles.I_right, handles.I_mask); % Calculate Pr(O|py), to be used in Co
imshow(handles.I_mask,'parent',handles.axes8);
guidata(hObject,handles);

function LeftButtonFcn(hObject,eventdata, handles)
pos = get(get(hObject,'Parent'),'CurrentPoint');
pos = round(pos(1,1:2));
pos = flipdim(pos,2);
handles = guidata(get(hObject,'Parent'));
index = find(ismember(handles.p,pos,'rows')==1);
index = min(index);
set(handles.text21,'String',[{num2str(handles.p(index,:))};{num2str(handles.p_out(index,:))};{num2str(handles.disp_val(index))}]);

function RightButtonFcn(hObject, eventdata, handles)
pos = get(get(hObject,'Parent'),'CurrentPoint');
pos = round(pos(1,1:2));
pos = flipdim(pos,2);
handles = guidata(get(hObject,'Parent'));
index = find(ismember(handles.p_out,pos,'rows')==1);
index = min(index);
set(handles.text21,'String',[{num2str(handles.p(index,:))};{num2str(handles.p_out(index,:))};{num2str(handles.disp_val(index))}]);


% --- Executes during object creation, after setting all properties.
function axes10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
imshow(imread('eye.png'));


% --- Executes during object creation, after setting all properties.
function radiobutton1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
hObject.Value = 0;
guidata(hObject,handles);
