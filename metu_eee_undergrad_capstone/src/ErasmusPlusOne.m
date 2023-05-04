function varargout = ErasmusPlusOne(varargin)
% ERASMUSPLUSONE MATLAB code for ErasmusPlusOne.fig
%      ERASMUSPLUSONE, by itself, creates a new ERASMUSPLUSONE or raises the existing
%      singleton*.
%
%      H = ERASMUSPLUSONE returns the handle to a new ERASMUSPLUSONE or the handle to
%      the existing singleton*.
%
%      ERASMUSPLUSONE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ERASMUSPLUSONE.M with the given input arguments.
%
%      ERASMUSPLUSONE('Property','Value',...) creates a new ERASMUSPLUSONE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ErasmusPlusOne_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ErasmusPlusOne_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ErasmusPlusOne

% Last Modified by GUIDE v2.5 17-Apr-2015 20:39:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ErasmusPlusOne_OpeningFcn, ...
                   'gui_OutputFcn',  @ErasmusPlusOne_OutputFcn, ...
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


% --- Executes just before ErasmusPlusOne is made visible.
function ErasmusPlusOne_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ErasmusPlusOne (see VARARGIN)

% Choose default command line output for ErasmusPlusOne
handles.output = hObject;

axes(handles.axes1);
imshow(ones(500,500));
axes(handles.axes2)
imshow(ones(500,500));
axes(handles.axes3)
imshow(ones(500,500));

set(handles.text1, 'String', 'Ready' );

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ErasmusPlusOne wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ErasmusPlusOne_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text1, 'String', 'Processing ...' );

% winopen('opencvtest.exe')
% pause(5);
x = imread('asdad.jpg');
dene = x;
axes(handles.axes1);
imshow(dene);

[centers, radii] = imfindcircles(x,[13 20], 'Sensitivity',0.98,'EdgeThreshold',0.008) ;     %Finding all circular objects.

imageSize = size(x);
croppedImage = uint8(zeros(imageSize));
kym = uint8(zeros(3,3));

for n = 1:3                                                                 %Creating mask and cropping image for each ball.
    
[xx,yy] = ndgrid((1:imageSize(1))-centers(n,2),(1:imageSize(2))-centers(n,1));
mask = uint8((xx.^2 + yy.^2)<=radii(n)^2);

croppedImage(:,:,1) = x(:,:,1).*mask;
croppedImage(:,:,2) = x(:,:,2).*mask;
croppedImage(:,:,3) = x(:,:,3).*mask;

kym(:,n) = sum(sum(croppedImage)) / sum(sum(mask));         % Save RGB values.

end

[renk_max,renk_index] = max( kym' ) ;                   % This part has been changed (color detection).

renk( renk_index(1) ) = 'r' ;
renk( renk_index(3) ) = 'b' ;
renk( 6 - ( renk_index(1) + renk_index(3) ) )  = 'g' ;

axes(handles.axes2);
imshow(x);                                                              %Showing the resultant location and color data.
radii(1) = 13.5;
viscircles(centers(1,:),radii(1),'EdgeColor',renk(1));
viscircles(centers(2,:),radii(1),'EdgeColor',renk(2));
viscircles(centers(3,:),radii(1),'EdgeColor',renk(3));

axes(handles.axes3);
new = zeros(500,500);
imshow(new);

if get(handles.red_button ,'Value')==1
   x1 = centers(  find( renk == 'r' ) ,1);
    y1 = centers(  find( renk == 'r' ) ,2);

    x2 = centers(  find( renk == 'g' ) ,1);
    y2 = centers(  find( renk == 'g' ) ,2);

    x3 = centers(  find( renk == 'b' ) ,1);
    y3 = centers(  find( renk == 'b' ) ,2); 
elseif get(handles.green_button ,'Value')==1
  x1 = centers(  find( renk == 'g' ) ,1);
    y1 = centers(  find( renk == 'g' ) ,2);

    x2 = centers(  find( renk == 'r' ) ,1);
    y2 = centers(  find( renk == 'r' ) ,2);

    x3 = centers(  find( renk == 'b' ) ,1);
    y3 = centers(  find( renk == 'b' ) ,2);
elseif get(handles.blue_button ,'Value')==1
   x1 = centers(  find( renk == 'b' ) ,1);
    y1 = centers(  find( renk == 'b' ) ,2);

    x2 = centers(  find( renk == 'g' ) ,1);
    y2 = centers(  find( renk == 'g' ) ,2);

    x3 = centers(  find( renk == 'r' ) ,1);
    y3 = centers(  find( renk == 'r' ) ,2);
else
   x1 = centers(  find( renk == 'r' ) ,1);
    y1 = centers(  find( renk == 'r' ) ,2);

    x2 = centers(  find( renk == 'g' ) ,1);
    y2 = centers(  find( renk == 'g' ) ,2);

    x3 = centers(  find( renk == 'b' ) ,1);
    y3 = centers(  find( renk == 'b' ) ,2);
end
    
x=[0 500];
y=[0 500];
y_line=[0 500];
bh_fraction=1/2;
radius=13.5;
k=1;

game_field=rectangle('Position',[0,0,500,500]);
c1=[x1,y1];
c2=[x2,y2];
c3=[x3,y3];
ball_1=viscircles(c1,radius,'EdgeColor','r');
ball_2=viscircles(c2,radius,'EdgeColor','g');
ball_3=viscircles(c3,radius,'EdgeColor','g');
hold on;
distance_2=sqrt((x2-x1)^2+(y2-y1)^2);
distance_3=sqrt((x3-x1)^2+(y3-y1)^2);

if distance_2> distance_3
    
    %ghost_ball=viscircles(c3,2*radius,'EdgeColor','c');
    second_ball_center=c3;
    third_ball_center=c2;
    distance=distance_3;
else
    %ghost_ball=viscircles(c2,2*radius,'EdgeColor','c');
    second_ball_center=c2;
    third_ball_center=c3;
    distance=distance_2;
   
end

limit_angle=90-asin(2*radius/distance)*180/pi; % angles limiting the spanning range
slope_b1_b2=atan((second_ball_center(2)-y1)/(second_ball_center(1)-x1))*180/pi;

    if slope_b1_b2 >0
        corrected_slope=slope_b1_b2;
        
    else
        corrected_slope=slope_b1_b2+180;
    end
    
start_slope=limit_angle+slope_b1_b2;


if second_ball_center(2)>y1
    limit1=180+corrected_slope-limit_angle;
    limit2=180+corrected_slope+limit_angle;
else if second_ball_center(2)<y1
    limit1=corrected_slope-limit_angle;
    limit2=corrected_slope+limit_angle;
    
   else if second_ball_center(2)==y1
       if x1>second_ball_center(1)
             limit1=180+corrected_slope-limit_angle;
            limit2=180+corrected_slope+limit_angle;
       else if x1<second_ball_center(1)
            limit1=corrected_slope-limit_angle;
            limit2=corrected_slope+limit_angle;
            end
         end
    end
    end
 end

          
    
    
    for i=limit1:1:limit2
    inx(k)=cos(i*pi/180)*radius*2+second_ball_center(1);
    iny(k)=sin(i*pi/180)*radius*2+second_ball_center(2);
    ghost_intercept=[inx(k),iny(k)];
    %y_plot(k)=plot([c1(1),ghost_intercept(1)],[c1(2),ghost_intercept(2)],':');
    hold on;
    k=k+1;
    max_k=k;
    end

    for k=1:1:max_k-1

        sl_aiming_line(k)=(atan((iny(k)-y1)/(inx(k)-x1)))*180/pi;
        if (sl_aiming_line(k)>0)
        corrected_sl_aiming_line(k)=sl_aiming_line(k);  %vector storing the slope info (corrected_sl_aiming_line)
        end
        if(sl_aiming_line(k)<0)
        corrected_sl_aiming_line(k)=sl_aiming_line(k)+180;
        end
        if sl_aiming_line(k)==0
            if inx(k) > x1
                corrected_sl_aiming_line(k)=0;
            else if inx(k) < x1
                     corrected_sl_aiming_line(k)=180;
                end
            end
        end
        
    end
    
    
    for k=1:1:max_k-1

         sl_impact_line(k)=atan((iny(k)-second_ball_center(2))/(inx(k)-second_ball_center(1)))*180/pi;
        if (sl_impact_line(k)>0)
        corrected_sl_impact_line(k)=sl_impact_line(k);  %vector storing the slope info (corrected_sl_aiming_line)
        end
        if(sl_impact_line(k)<0)
        corrected_sl_impact_line(k)=sl_impact_line(k)+180;
        end
        if sl_impact_line(k)==0
            if inx(k) > second_ball_center(1)
                corrected_sl_impact_line(k)=0;
            else if inx(k) < second_ball_center(1)
                     corrected_sl_impact_line(k)=180;
                end
            end
        end
        
    end
    
    
     for k=1:1:max_k-1

    a=[inx(k)-x1 iny(k)-y1 0];
    b=[inx(k)-second_ball_center(1) iny(k)-second_ball_center(2) 0];
    cut(k) = atan2(norm(cross(a,b)),dot(a,b))*180/pi;
    if cut(k)<=90
        cut_angle(k)=cut(k);
    else if cut(k)>90
            cut_angle(k)=180-cut(k);
        end
    end
     end
     
     
 for k=1:1:max_k-1
     
            deflected_angle(k)=atan((sin(cut_angle(k)*pi/180)*cos(cut_angle(k)*pi/180))/(sin(cut_angle(k)*pi/180)^2+(2/5)))*180/pi;
 end
  
for k=1:1:max_k-1
    if second_ball_center(2)==y1
        sl_after_impact(k)=corrected_sl_aiming_line(k)+sign((inx(k)-x1)*(iny(k)-y1))*deflected_angle(k);
    else if (second_ball_center(2)-y1)*(iny(k)-y1) < 0 
            sl_after_impact(k)=corrected_sl_aiming_line(k)+sign(-(second_ball_center(2)-y1)*second_ball_center(1));
        else
            
    if corrected_sl_aiming_line(k)>corrected_slope
        sl_after_impact(k)=corrected_sl_aiming_line(k)+deflected_angle(k);
        
    else if corrected_sl_aiming_line(k)<corrected_slope
        sl_after_impact(k)=corrected_sl_aiming_line(k)-deflected_angle(k);
        else if corrected_sl_aiming_line(k)==corrected_slope
                 sl_after_impact(k)=corrected_sl_aiming_line(k);
            end
        end
    end
    end
    end   
end

for k=1:1:max_k-1
     y_intercept(k)=tan(sl_after_impact(k)*pi/180)*(-inx(k))+iny(k);
     y_limit(k)=tan(sl_after_impact(k)*pi/180)*(500-inx(k))+iny(k);
     
     %z_plot(k)=plot([0,500],[y_intercept(k),y_limit(k)],'r');
   
     %z_plot(k)=plot([0,inx(k)],[y_intercept(k),iny(k)],'r')

     xlim([0 500]);
     ylim([0 500]);
     %z_plot(k)=plot([inx(k),0],[iny(k), y_intercept(k)],'r')
     hold on;
end
   for k=1:1:max_k-1
        Q2=[0 y_intercept(k)];
        Q1=[500 y_limit(k)];
        P=[third_ball_center(1) third_ball_center(2)];
        distance(k) = abs(det([Q2-Q1;P-Q1]))/norm(Q2-Q1);
        min_distance_index=find(distance==min(distance));
        
   end
       resulting_line_slope=180-corrected_sl_aiming_line(min_distance_index);
       resulting_line_y_intercept=[0 y_intercept(min_distance_index)];
       resulting_line_limit=[500 y_limit(min_distance_index)];
       resulting_line_ghost_intercept=[inx(min_distance_index) iny(min_distance_index)];
       result_plot_deflected=plot([0 500],[resulting_line_y_intercept(2) resulting_line_limit(2)],'c');
       result_plot=plot([x1 resulting_line_ghost_intercept(1)],[y1 resulting_line_ghost_intercept(2)],'b');
       y_intercept_result=tan(resulting_line_slope*pi/180)*(-resulting_line_ghost_intercept(1))+abs(resulting_line_ghost_intercept(2)-500);
       y_limit_result=tan(resulting_line_slope*pi/180)*(500-resulting_line_ghost_intercept(1))+resulting_line_ghost_intercept(2);
       x_intercept_result=(-resulting_line_ghost_intercept(2)/tan(resulting_line_slope*pi/180))+resulting_line_ghost_intercept(1);
       x_limit_result=((500-resulting_line_ghost_intercept(2))/tan(resulting_line_slope*pi/180))+resulting_line_ghost_intercept(1);
       
       
       size_distance(1)=sqrt((x1-0)^2+(y1-y_intercept_result)^2)-radius;
       size_distance(2)=sqrt((x1-500)^2+(y1-y_limit_result)^2)-radius;
       size_distance(3)=sqrt((x1-x_intercept_result)^2+(y1-0)^2)-radius;
       size_distance(4)=sqrt((x1-x_limit_result)^2+(y1-500)^2)-radius;
       g=min(size_distance)
       utku=tan((resulting_line_slope)*(pi/180));
       a=[utku y_intercept_result x1 abs(y1-500) x2 abs(y2-500) x3 abs(500-y3)];
       
      
       fid = fopen('data.txt','wt');  % Note the 'wt' for writing in text mode
       fprintf(fid,'%f ',a);  % The format string is applied to each element of a
       fclose(fid);
       
       set(handles.text1, 'String', 'Ready' );
guidata(hObject, handles);
