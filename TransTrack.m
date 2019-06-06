function varargout = TransTrack(varargin)
% TRANSTRACK MATLAB code for TransTrack.fig
%      TRANSTRACK, by itself, creates a new TRANSTRACK or raises the existing
%      singleton*.
%
%      H = TRANSTRACK returns the handle to a new TRANSTRACK or the handle to
%      the existing singleton*.
%
%      TRANSTRACK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRANSTRACK.M with the given input arguments.
%
%      TRANSTRACK('Property','Value',...) creates a new TRANSTRACK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TransTrack_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TransTrack_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Last Modified by GUIDE v2.5 31-May-2019 16:47:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TransTrack_OpeningFcn, ...
                   'gui_OutputFcn',  @TransTrack_OutputFcn, ...
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


% --- Executes just before TransTrack is made visible.
function TransTrack_OpeningFcn(hObject, eventdata, handles, varargin)

%Load the app-data.                                    
setappdata(0, 'hMainGui', gcf);
hMainGui = getappdata(0, 'hMainGui');

%Note that transtrack is active.
handles.active_transtrack = 1;
%Indicates if a movie is loaded into TransTrack. At start up no movie is
%loaded.   
handles.active_image = 0;
%Note if analysis is active. 
setappdata(hMainGui, 'active_analysis', 0);


%Setting up slider controls so that sliding will result in immediate
%feedback. 
%Position slider
handles.sliderListener_position = addlistener(handles.position_slider,'ContinuousValueChange', ...
                                      @(hObject, event) position_sliderContValCallback(...
                                        hObject, eventdata, handles));
%Frame slider
handles.sliderListener_time = addlistener(handles.frame_slider,'ContinuousValueChange', ...
                                      @(hObject, event) frame_sliderContValCallback(...
                                        hObject, eventdata, handles));
%Zoom slider                                    
handles.sliderListener_zoom = addlistener(handles.zoom_slider,'ContinuousValueChange', ...
                                      @(hObject, event) zoom_sliderContValCallback(...
                                        hObject, eventdata, handles));
%Set maximum zoom and slider stepsize; Set current zoom factor at 1.  
set(handles.zoom_slider, 'Max', 10);
set(handles.zoom_slider, 'SliderStep', [1/10 , 10/10]);
handles.zoomfactor = 1;

%x-slider
handles.sliderListener_x = addlistener(handles.x_slider,'ContinuousValueChange', ...
                                      @(hObject, event) x_sliderContValCallback(...
                                        hObject, eventdata, handles));

%y-slider
handles.sliderListener_y = addlistener(handles.y_slider,'ContinuousValueChange', ...
                                      @(hObject, event) y_sliderContValCallback(...
                                        hObject, eventdata, handles));
                               
                                    
%Set the standard visualization options for analysis. 
analysis_visuals = zeros(7,1);
setappdata(hMainGui, 'analysis_visuals', analysis_visuals);

%Set the standard settings for analysis. 
analysis_metadata = {'bleach correction', 0; 'number of positions', 0; 'number of frames', 0; 'number of channels', 0; 'dimensions', 0;
    'analysis type', 0; 'analysis channel', 0; 'noise size', 1; 'object size', 8; 'noise level', 1000; 'threshold', 1000; 
    'tracking distance', 10; 'frame skipping', 1; 'overlap filter', 0; 'start filter', 0; 'start value', 1; 'end filter', 0; 'end value', 2;
    'minimum tracklength filter', 0; 'minimum tracklength value', 1; 'colocalization filter', 0; 'colocalization channel (analysis)', 0;
    'colocalization threshold (analysis)', 1000; 'colocalization length (analysis)', 1; 'subROI filter', 0; 'subROI channel (analysis)', 0; 
    'subROI selection', 0; 'subROI threshold (analysis)', 1000; 'intensity box size', 8; 'subROI channel (save)', 0; 
    'subROI threshold (save)', 1000; 'colocalization channel (save)', 0; 'colocalization threshold (save)', 1000; 'colocalization length (save)', 1};
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);


%Nice image to show at the start. 
imshow('saturn.png');

% Choose default command line output for TransTrack
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TransTrack wait for user response (see UIRESUME)
% uiwait(handles.Gui1);

% --- Outputs from this function are returned to the command line.
function varargout = TransTrack_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Section 1 - Controlling sliders%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on position slider movement.
function position_sliderContValCallback(hObject, eventdata, handles)

%Retrieve handles.
handles = guidata(hObject);

%Get the position from the slider and set the edit accordingly. 
handles.position = round(get(hObject,'Value'));
set(handles.position_edit, 'String', handles.position);

%Retrieve settings for displaying the image. 
hMainGui = getappdata(0, 'hMainGui');
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette');
channels = getappdata(hMainGui, 'channels_selection');

analysis_visuals = getappdata(hMainGui, 'analysis_visuals');

roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');

analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(handles.Image_combined, handles.axes8, handles.x, handles.y, handles.frame, handles.position, handles.zoomfactor,...
    handles.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function position_slider_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes when position edit is changed.
function position_edit_Callback(hObject, eventdata, handles)

%Get the position from the edit box   
position = str2double(get(hObject, 'String'));

%Check if position given by user is valid. 
if isnan(position)
    errordlg('Fill in correct value','Error')
    set(handles.position_edit, 'String', num2str(handles.position));
    return
elseif position <=0 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.position_edit, 'String', num2str(handles.position));
    return
elseif position > handles.num_position
    errordlg('There are not so many positions in movie', 'Error')
    set(handles.position_edit, 'String', num2str(handles.position));
    return
elseif position ~= round(position) 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.position_edit, 'String', num2str(handles.position));
    return
end

%If position is valid, update handles and set the slider accordingly.
handles.position = position;
set(handles.position_slider, 'Value', handles.position);

%Retrieve settings for displaying the image. 
hMainGui = getappdata(0, 'hMainGui');
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette');
channels = getappdata(hMainGui, 'channels_selection');

analysis_visuals = getappdata(hMainGui, 'analysis_visuals');

roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');

analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(handles.Image_combined, handles.axes8, handles.x, handles.y, handles.frame, handles.position, handles.zoomfactor,...
    handles.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function position_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on frame slider movement.
function frame_sliderContValCallback(hObject, eventdata, handles)

%Retrieve handles.
handles = guidata(hObject);

%Get frame from frame slider. Update edit accordingly. 
handles.frame = round(get(hObject,'Value'));
set(handles.frame_edit, 'String', handles.frame);

%Retrieve settings for displaying the image. 
hMainGui = getappdata(0, 'hMainGui');
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette');
channels = getappdata(hMainGui, 'channels_selection');

analysis_visuals = getappdata(hMainGui, 'analysis_visuals');

roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');

analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(handles.Image_combined, handles.axes8, handles.x, handles.y, handles.frame, handles.position, handles.zoomfactor,...
    handles.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function frame_slider_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes when frame edit is changed.
function frame_edit_Callback(hObject, eventdata, handles)

%Get frame from the edit box.  
frame = str2double(get(hObject,'String'));

%Check if frame given by user is valid. 
if isnan(frame)
    errordlg('Fill in correct value','Error')
    set(handles.frame_edit, 'String', num2str(handles.frame));
    return
elseif frame <=0 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.frame_edit, 'String', num2str(handles.frame));
    return
elseif frame > handles.total_frames
    errordlg('There are not so many positions in movie', 'Error')
    set(handles.frame_edit, 'String', num2str(handles.frame));
    return
elseif frame ~= round(frame) 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.frame_edit, 'String', num2str(handles.frame));
    return
end

%Update handles and slider accordingly.
handles.frame = frame; 
set(handles.frame_slider, 'Value', handles.frame);

%Retrieve settings for displaying the image. 
hMainGui = getappdata(0, 'hMainGui');
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette');
channels = getappdata(hMainGui, 'channels_selection');

analysis_visuals = getappdata(hMainGui, 'analysis_visuals');

roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');

analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(handles.Image_combined, handles.axes8, handles.x, handles.y, handles.frame, handles.position, handles.zoomfactor,...
    handles.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function frame_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on zoom slider movement.
function zoom_sliderContValCallback(hObject, eventdata, handles)

% Retrieve handles.
handles = guidata(hObject);

%Get zoomfactor from slider. Update edit accordingly. 
handles.zoomfactor = round(get(hObject,'Value'));
set(handles.zoom_edit, 'String', handles.zoomfactor);

%Retrieve settings for displaying the image. 
hMainGui = getappdata(0, 'hMainGui');
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette');
channels = getappdata(hMainGui, 'channels_selection');

analysis_visuals = getappdata(hMainGui, 'analysis_visuals');

roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');

analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(handles.Image_combined, handles.axes8, handles.x, handles.y, handles.frame, handles.position, handles.zoomfactor,...
    handles.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function zoom_slider_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes when zoom edit is changed.
function zoom_edit_Callback(hObject, eventdata, handles)

%Get zoomfactor from edit. 
zoom = str2double(get(hObject,'String'));

%Check if zoom given by user is valid. 
if isnan(zoom)
    errordlg('Fill in correct value','Error')
    set(handles.zoom_edit, 'String', num2str(handles.zoomfactor));
    return
elseif zoom <1 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.zoom_edit, 'String', num2str(handles.zoomfactor));
    return
elseif zoom > 10
    errordlg('There are not so many positions in movie', 'Error')
    set(handles.zoom_edit, 'String', num2str(handles.zoomfactor));
    return
end

%Update handels and slider accordingly. 
handles.zoomfactor = zoom;
set(handles.zoom_slider, 'Value', handles.zoomfactor);

%Retrieve settings for displaying the image. 
hMainGui = getappdata(0, 'hMainGui');
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette');
channels = getappdata(hMainGui, 'channels_selection');

analysis_visuals = getappdata(hMainGui, 'analysis_visuals');

roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');

analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(handles.Image_combined, handles.axes8, handles.x, handles.y, handles.frame, handles.position, handles.zoomfactor,...
    handles.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function zoom_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in reset_pushbutton.
function reset_pushbutton_Callback(hObject, eventdata, handles)

%Set x position back in the middle of the image and reset slider. 
handles.x = round(size(handles.Image_combined.channel1.num1,2)/2);
set(handles.x_slider, 'Value', handles.x);

%Set y position back in the middle of the image and reset slider. 
handles.y = round(size(handles.Image_combined.channel1.num1,1)/2);
set(handles.y_slider, 'Value', handles.y);

%Retrieve settings for displaying the image. 
hMainGui = getappdata(0, 'hMainGui');
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette');
channels = getappdata(hMainGui, 'channels_selection');

analysis_visuals = getappdata(hMainGui, 'analysis_visuals');

roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');

analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(handles.Image_combined, handles.axes8, handles.x, handles.y, handles.frame, handles.position, handles.zoomfactor,...
    handles.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);


% --- Executes on x slider movement.
function x_sliderContValCallback(hObject, eventdata, handles)

%Retriev handles.
handles = guidata(hObject);

%Retrieve x position from slider. 
handles.x = round(get(hObject,'Value'));

%Retrieve settings for displaying the image. 
hMainGui = getappdata(0, 'hMainGui');
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette');
channels = getappdata(hMainGui, 'channels_selection');

analysis_visuals = getappdata(hMainGui, 'analysis_visuals');

roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');

analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(handles.Image_combined, handles.axes8, handles.x, handles.y, handles.frame, handles.position, handles.zoomfactor,...
    handles.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function x_slider_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on y slider movement.
function y_sliderContValCallback(hObject, eventdata, handles)

%Retrieve handles.
handles = guidata(hObject);

%Retrieve y position from slider. 
handles.y = round(get(hObject,'Value'));

%Retrieve settings for displaying the image. 
hMainGui = getappdata(0, 'hMainGui');
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette');
channels = getappdata(hMainGui, 'channels_selection');

analysis_visuals = getappdata(hMainGui, 'analysis_visuals');

roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');

analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(handles.Image_combined, handles.axes8, handles.x, handles.y, handles.frame, handles.position, handles.zoomfactor,...
    handles.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function y_slider_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Section 2 - File menu%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --------------------------------------------------------------------
function open_menu_Callback(hObject, eventdata, handles)

%Ask the user for the number of channels in the image; optionally: user can
%also set a window for the frames uploaded. 
prompt = {'number of channels:', 'first frame (optional):', 'last frame (optional):'};
dims = [1,37];

input_user = inputdlg(prompt,'Open image',dims);

%If user doesn't fill in correct information or doesn't fill in anything;
%return. 
if isempty(input_user)
    return
elseif str2double(input_user{1})>6
    errordlg('Maximum number of channels is 6','Error')
    return
end

% User can choose file; filename and path are retrieved. Path is added to 
% the path list. 
pathname = uigetdir();
if pathname==0
    return
end

%Search for .tif files in given directory.  
cd(pathname);
file_directory = dir('*.tif');

%Retrieve all .tif files in the directory. If none are found return. 
filenames = {file_directory.name};
if isempty(filenames)
    errordlg('Could not find any .tif files in folder','Error')
    return
end
    
%Show name of the movie on top of the screen
Ind1 = find(pathname=='\');
set(handles.title_text, 'String', pathname(Ind1(end-1)+1:end));

%Store the number of channels in the image; given by the user. 
handles.num_channels = str2double(input_user{1});

%If user didn't list a lower limit for uploading, set lower limit at 1. 
if isnan(str2double(input_user{2}))
    handles.start_frame = 1;
else
    handles.start_frame = str2double(input_user{2});
end

%If user didn't list an upper limit for uploading, set upper limit at
%maximum number of frames present in image. 
if isnan(str2double(input_user{3}))
    handles.last_frame = size(imfinfo(filenames{1}),1)/handles.num_channels;
else
    handles.last_frame = str2double(input_user{3});
end

%Total number of frames is last - start frame. 
handles.total_frames = handles.last_frame - handles.start_frame +1;


%Extra check that correct information is filled in; return otherwise. 
if floor(handles.num_channels) == handles.num_channels && floor(handles.start_frame) == handles.start_frame && floor(handles.last_frame) == handles.last_frame
else
    errordlg('Incorrect input, fill in whole numbers and correct number of channels','Error')
    return    
end
%Extra check that correct information is filled in; return otherwise.
if handles.last_frame < handles.start_frame
    errordlg('Start frame must be before last frame','Error')
    return
elseif handles.last_frame > size(imfinfo(filenames{1}),1)/handles.num_channels
    errordlg('Last frame cannot be after end movie','Error')
    return
elseif handles.start_frame < 1
    errordlg('Start frame cannot be smaller than 1','Error')
end

%List number of positions (is equal to number of tiff files). 
position_number = size(filenames,2); 
handles.num_position = position_number;

%Load the image. Do this in following order: all channels, per frame, and
%finally per position. Each tiff file is one position. Each tiff file is
%ordered in a way that it shows all channels per frame. Make a single
%structure to store all image information. 
progressbar(0,0)
for i = 1:position_number
    filename = filenames{i};
    for j = 1:handles.num_channels
        handles.Image_combined.(strcat('channel', num2str(j))).(strcat('num', num2str(i))) = [];
        for k = 1:handles.total_frames
            handles.Image_combined.(strcat('channel', num2str(j))).(strcat('num', num2str(i)))(:,:,k) = imread(filename,(handles.num_channels*k + handles.num_channels*(handles.start_frame-1) - handles.num_channels + j));
            
            progressbar(((j-1)*handles.total_frames +k)/(handles.num_channels*handles.total_frames),[])
        end
    end
    progressbar([],i/position_number)
end
progressbar(1)


%Set the limits for the time slider. 
set(handles.frame_slider, 'Max', handles.total_frames);
set(handles.frame_slider, 'SliderStep', [1/handles.total_frames , 10/handles.total_frames]);
handles.frame = 1;

%Set the limits for the position slider.
set(handles.position_slider, 'Max', position_number);
set(handles.position_slider, 'SliderStep', [1/position_number , 10/position_number]);
handles.position = 1;

%Set the limits for the x slider
handles.x = round(size(handles.Image_combined.channel1.num1,2)/2);
handles.size_x = size(handles.Image_combined.channel1.num1,2);

set(handles.x_slider, 'Max', handles.size_x);
set(handles.x_slider, 'SliderStep', [1/handles.size_x , 10/handles.size_x]);
set(handles.x_slider, 'Value', handles.x);

%Set the limits for the y slider
handles.y = round(size(handles.Image_combined.channel1.num1,1)/2);
handles.size_y = size(handles.Image_combined.channel1.num1,1);

set(handles.y_slider, 'Max', handles.size_y);
set(handles.y_slider, 'SliderStep', [1/handles.size_y , 10/handles.size_y]);
set(handles.y_slider, 'Value', handles.y);


%Make back-up of image (can be used in case of photobleaching correction).
handles.Image_combined_backup = handles.Image_combined;
%Set bleach correction status for each channel.
handles.bleach_correction = zeros(handles.num_channels,1);

%Update metadata file with movie properties. 
hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{1,2} = handles.bleach_correction;
analysis_metadata{2,2} = handles.num_position;
analysis_metadata{3,2} = handles.total_frames;
analysis_metadata{4,2} = handles.num_channels;
analysis_metadata{5,2} = [handles.size_x; handles.size_y];

setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

%Set minimum and maximum display values (as an a priori guess take minimum
% and maximum value present. 
minimum_display = nan(handles.num_channels,1);
maximum_display = nan(handles.num_channels,1);

for i = 1:handles.num_channels
    minimum_display(i) = min(min(handles.Image_combined.(strcat('channel',num2str(i))).num1(:,:,1)));
    maximum_display(i) = max(max(handles.Image_combined.(strcat('channel',num2str(i))).num1(:,:,1)));
end

%Save display values. 
setappdata(hMainGui,   'minimum_display'    , minimum_display);
setappdata(hMainGui,   'maximum_display'    , maximum_display);

%Set the colours of each channel and save the values. 
colour_palette = [1,0,0; 0,1,0; 0,0,1; 1,1,0; 1,0,1; 0,1,1];
setappdata(hMainGui, 'colour_palette', colour_palette);

%Set which channels should be visualized and save the values. 
channels_selection = ones(handles.num_channels,1);
setappdata(hMainGui, 'channels_selection', channels_selection);

%(Re)set the tracking handles.
for i = 1:position_number
    roi_boundaries.(strcat('num', num2str(i))) = {};
    peaks.(strcat('num', num2str(i))) = [];
    preliminary_tracks.(strcat('num', num2str(i))) = [];
    selected_tracks.(strcat('num', num2str(i))) = [];
    segmented_image.(strcat('num', num2str(i))) = [];
    colocalization.(strcat('num', num2str(i))) = [];
end

%Save the tracking handles. 
setappdata(hMainGui, 'roi_boundaries', roi_boundaries);
setappdata(hMainGui, 'peaks', peaks);
setappdata(hMainGui, 'preliminary_tracks', preliminary_tracks);
setappdata(hMainGui, 'selected_tracks', selected_tracks);
setappdata(hMainGui, 'segmented_image', segmented_image);
setappdata(hMainGui, 'colocalization', colocalization);

%Note that an active image is present. Make all the sliders visible. 
handles.active_image = 1;
set(handles.text5, 'visible','on'), set(handles.text6, 'visible','on'), set(handles.text7, 'visible','on')
set(handles.position_edit, 'visible','on'), set(handles.frame_edit, 'visible','on'), set(handles.zoom_edit, 'visible','on')
set(handles.position_slider, 'visible','on'), set(handles.frame_slider, 'visible','on'), set(handles.zoom_slider, 'visible','on')
set(handles.x_slider, 'visible','on'), set(handles.y_slider, 'visible', 'on'), set(handles.reset_pushbutton, 'visible', 'on')

%Retrieve settings for displaying image. 
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette');
channels = getappdata(hMainGui, 'channels_selection');
analysis_visuals = getappdata(hMainGui, 'analysis_visuals');

%Display image. 
displayim(handles.Image_combined, handles.axes8, handles.x, handles.y, handles.frame, handles.position, handles.zoomfactor,...
    handles.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);



% --- Excecutes when user selects load track menu.
function load_tracks_menu_Callback(hObject, eventdata, handles)

%Retrieve app data. 
hMainGui = getappdata(0, 'hMainGui');

%If no movie is loaded in TransTrack, this menu cannot be started. 
if handles.active_image ==0
    errordlg('First load movie into TransTrack', 'Error')
    return
end

%If other analysis is active, this one has to be closed first. 
if getappdata(hMainGui, 'active_analysis') ==1
    if ~isempty(findobj('Name','Single Channel Tracking'))
        close('Single Channel Tracking')
    end
    if ~isempty(findobj('Name','Save'))
        close('Save')
    end
end

%Ask file from user. 
[filename, pathname] = uigetfile({'*.xlsx'});

%If incorrect filename/pathname, return. 
if filename ==0
    return
elseif pathname ==0
    return
end

%Set correct path to find file and retrieve the sheet names of Excel file. 
cd(pathname);
[~, sheet_names] = xlsfinfo(filename);

%Search for metadata and track info sheet. 
index_metadata = find(strcmp(sheet_names, 'Metadata'));
index_tracks = find(strcmp(sheet_names, 'General Track info'));

%Return if metadta and track info sheet are not present. 
if isempty(index_metadata)
    errordlg('Excel file misses Metadata sheet', 'Error')
    return
end
if isempty(index_tracks)
    errordlg('Excel file misses General Track info sheet', 'Error')
    return
end

%Read metadata sheet. 
metadata = xlsread(filename, index_metadata);
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Number of checks to make sure that Excel file is from same movie as is
%loaded into transtrack. 

%Return if metadata sheet has incorrect size. 
if size(metadata,1)~=size(analysis_metadata,1)
    errordlg('Incorrect metadata file')
    return
end
%Return if metadata has incorrect number of positions. 
if analysis_metadata{2,2}~= metadata(2,1)
    errordlg('Not same number of positions in movie', 'Error')
    return
%Return if metadata has incorrect number of frames. 
elseif analysis_metadata{3,2}~= metadata(3,1)
    errordlg('Not same number of frames in movie', 'Error')
    return
%Return if metadata has incorrect number of channels.
elseif analysis_metadata{4,2}~= metadata(4,1)
    errordlg('Not same number of channels in movie', 'Error')
    return
%Return if metadata has incorrect x dimensions. 
elseif analysis_metadata{5,2}(1)~= metadata(5,1)
    errordlg('X dimensions are different in movie', 'Error')
    return
%Return if metadata has incorrect y dimenions. 
elseif analysis_metadata{5,2}(2)~= metadata(5,2)
    errordlg('Y dimensions are different in movie', 'Error')
    return
end

%Indicate to user if the photobleaching status is different as in loaded
%analysis. 
for i = 1:handles.num_channels
    if analysis_metadata{1,2}(i)~= metadata(1,i)
        warndlg(strcat('Photobleach correction status of channel ',num2str(i),' is not the same!'), 'Warning')
    end
end

%Update metadata file with loaded metadata file. 
analysis_metadata(6:size(analysis_metadata,1),2) = num2cell(metadata(6:end, 1));
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

%Select view on for selected tracks and tracknumber. 
analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
analysis_visuals(4) = 1;
analysis_visuals(5) = 1;
setappdata(hMainGui, 'analysis_visuals', analysis_visuals);

%Start up analysis type 1 if this is indicated in metadata file. 
if analysis_metadata{6,2} ==1
    setappdata(hMainGui, 'active_analysis', 1);
    SingleChannelTracking
end

%Load track info file. 
track_info = xlsread(filename, index_tracks);

%Get positions and number of positions with tracks. 
positions = unique(track_info(:,1));
num_positions = size(positions,1);

%Fill the selected tracks handle with tracks at each position. 
selected_tracks = getappdata(hMainGui, 'selected_tracks');
for i = 1:num_positions
    index_position = track_info(:,1)==positions(i);
    selected_tracks.(strcat('num',num2str(positions(i)))) = track_info(index_position, 2:5);
end

%Save selected tracks in app data. 
setappdata(hMainGui, 'selected_tracks', selected_tracks);

%Retrieve settings for displaying image. 
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette');
channels = getappdata(hMainGui, 'channels_selection');
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');

%Display image. 
displayim(handles.Image_combined, handles.axes8, handles.x, handles.y, handles.frame, handles.position, handles.zoomfactor,...
    handles.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);




% --- Excecutes when user selects load roi menu. 
function load_rois_menu_Callback(hObject, eventdata, handles)

%Retrieve app data. 
hMainGui = getappdata(0, 'hMainGui');

%If no movie is loaded in TransTrack, this menu cannot be started. 
if handles.active_image ==0
    errordlg('First load movie into TransTrack', 'Error')
    return
end


%Ask filename and pathname from user. 
[filename, pathname] = uigetfile({'*.mat'});
        
%If incorrect file/pathname is selected, return. 
if filename ==0
    return
elseif pathname ==0
    return
end
        
%Load the ROI boundaries from given file.
data = load(strcat(pathname,filename), 'roi_boundaries');

%If ROI boundaries object is not in file: return.
if isempty(fieldnames(data))
    errordlg('Incorrect file selected', 'Error')
    return
%If there are more positions in file than in movie: return. 
    elseif size(fieldnames(data.roi_boundaries),1) ~= handles.num_position
    errordlg('Incorrect number of positions in ROI file', 'Error')
    return
end
        
%Set the ROI boundaries and save in app data. 
roi_boundaries = data.roi_boundaries;
setappdata(hMainGui, 'roi_boundaries', roi_boundaries);

%Retrieve settings for displaying image. 
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette');
channels = getappdata(hMainGui, 'channels_selection');
analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');

%Display image. 
displayim(handles.Image_combined, handles.axes8, handles.x, handles.y, handles.frame, handles.position, handles.zoomfactor,...
    handles.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);


guidata(hObject, handles);




% --- Excecutes when user selects save track menu.  
function save_tracks_menu_Callback(hObject, eventdata, handles)

%Retrieve app data. 
hMainGui = getappdata(0, 'hMainGui');

%If no movie is loaded in TransTrack, or if there is not an active
%analysis, this menu cannot be started. 
if handles.active_image ==0
    errordlg('First load movie into TransTrack', 'Error')
    return
elseif getappdata(hMainGui, 'active_analysis') ==0
    errordlg('First start analysis before you can save', 'Error')
    return
end

%Start up Save GUI.
Save

guidata(hObject, handles);




% --- Excecutes when user selects save roi menu. 
function save_rois_Callback(hObject, eventdata, handles)

hMainGui = getappdata(0, 'hMainGui');

%If no movie is loaded in TransTrack this menu cannot be started. 
if handles.active_image ==0
    errordlg('First load movie into TransTrack', 'Error')
    return
end

roi_boundaries = getappdata(hMainGui, 'roi_boundaries');

if sum(structfun(@isempty,roi_boundaries)) - numel(fieldnames(roi_boundaries)) ==0
    errordlg('No ROIs selected', 'Error')
    return
end

[FileNameBodeWrite, PathNameBodeWrite] = uiputfile({'*.mat'}, 'Save As...', ['rois' '.mat']);
save(strcat(PathNameBodeWrite, FileNameBodeWrite), 'roi_boundaries')

guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Section 3 - Image menu%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Excecutes when user selects display menu.
function display_menu_Callback(hObject, eventdata, handles)

%If no movie is loaded in TransTrack, this menu cannot be started. 
if handles.active_image ==0
    return
end

%Start display settings GUI. 
DisplaySettings

guidata(hObject, handles);




% --- Excecutes when user selects channels menu. 
function channels_menu_Callback(hObject, eventdata, handles)

%If no movie is loaded in TransTrack, this menu cannot be started. 
if handles.active_image ==0
    return
end

%Start up channels GUI. 
Channels

guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Section 4 - Analysis menu%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Excecutes when user selects measure menu. 
function measure_menu_Callback(hObject, eventdata, handles)

%If no movie is loaded in TransTrack, this menu cannot be started. 
if handles.active_image ==0
    return
end

%Ask user for a x and y input. 
[x,y] = ginput(1);

%Round the x,y coordinates given by user. Get current frame. 
x = round(x);
y = round(y);
frame = handles.frame;

%Return if user selected a point outside of the image. 
if x <= get(handles.x_slider, 'Max') && x >= 1
else
    errordlg('Select pixel in image', 'Error')
    return
end

%Return if user selected a point outside of the image. 
if y <= get(handles.x_slider, 'Max') && y >= 1
else
    errordlg('Select pixel in image', 'Error')
    return
end

%Pre-allocate vectors. 
channel_headers = cell(1, 3*handles.num_channels);
channel_values = nan(1, 3*handles.num_channels);

hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

for i = 1:handles.num_channels
    %Make the headers. 
    channel_headers{i} = strcat('Peak Channel ', num2str(i));
    channel_headers{i + handles.num_channels} = strcat('Mean Channel ', num2str(i));
    channel_headers{i + 2*handles.num_channels} = strcat('Total Channel ', num2str(i));
    
    %Get the measured value in each channel: (1) intensity of selected
    %pixel, (2) average intensity at pixel location (same as final output
    %will give), and (3) total average intensity at given frame. 
    channel_values(i) = handles.Image_combined.(strcat('channel', num2str(i))).(strcat('num', num2str(handles.position)))(y, x, frame);
    channel_values(i + handles.num_channels) = round(intensity_tracker_single_channel([1, x, y, frame], handles.Image_combined.(strcat('channel', num2str(i))).(strcat('num', num2str(handles.position))), analysis_metadata{29,2}));
    channel_values(i + 2*handles.num_channels) = round(nanmean(nanmean(handles.Image_combined.(strcat('channel', num2str(i))).(strcat('num', num2str(handles.position)))(:,:,frame))));
end

%Combine the measured data with the characteristics of the selected point. 
headers = ['x', 'y', 'frame', channel_headers];
data = [x, y, frame, channel_values];

%In case table already exists: append this table with the new measurement.
%If the table doesn't exist yet, make a new one. 
if isfield(handles, 'table_figure')    
    if isvalid(handles.table_figure)
        data_full = [get(handles.measure_table,'data'); data];
        set(handles.measure_table,'data', data_full);
    else
        handles.table_figure = figure('Name','Measured Data','NumberTitle','off', 'Position', [100,100,500,150]);
        handles.measure_table = uitable(handles.table_figure,'data', data, 'Position', [0,0, 500, 150], 'ColumnName', headers);
    end
else
    handles.table_figure = figure('Name','Measured Data','NumberTitle','off', 'Position', [100,100,500,150]);
    handles.measure_table = uitable(handles.table_figure,'data', data, 'Position', [0,0, 500, 150], 'ColumnName', headers);
end

guidata(hObject, handles);




% --- Excecutes when user select photobleach correction status. 
function correction_status_menu_Callback(hObject, eventdata, handles)

%If no movie is loaded in Transtrack, status menu cannot be started. 
if handles.active_image ==0
    return
end

%Pre-allocate vector. 
status = cell(handles.num_channels,1);
for i = 1:handles.num_channels
    %Give status for each channel: is photobleach correction being used or
    %not. 
    if handles.bleach_correction(i) ==0
        status{i} = strcat('Channel ', num2str(i), ': no correction');
    elseif handles.bleach_correction(i) ==1
        status{i} = strcat('Channel ', num2str(i), ': bleach corrected');
    end
end

%Display info in a message box to user. 
msgbox(status ,'Channel Status')

guidata(hObject, handles);


% --- Excecutes when user selects photobleach correction. 
function correction_menu_Callback(hObject, eventdata, handles)

%If no movie is loaded in TransTrack, correction cannot be started. 
if handles.active_image ==0
    return
end

%Get a colormap for displaying the photobleach curves in a plot. 
c = colormap(lines);

%The photobleach correction curve that is used to fit the data with. 
fun_bleach_correction = @(x,xdata)x(1)*exp(-x(2)*xdata)+x(3);

%Go through the photobleach correction protocol for each channel
%individually. 
for i = 1:handles.num_channels
    %Follow in case photobleach correction has not been applied to given
    %channel yet.  
    if handles.bleach_correction(i) ==0
        %Set up a figure to plot photobleach curves. 
        correction_figure = figure('Name', 'Bleach correction', 'NumberTitle', 'off');
        correction_axes = axes('Parent', correction_figure); 
        
        for j = 1:handles.num_position
            %Get the image at the current position. 
            image = handles.Image_combined.(strcat('channel', num2str(i))).(strcat('num', num2str(j)));
            
            %Make a time vector; each frame has equal length. 
            t = transpose(1:size(image,3));
            
            %Get the mean intensity in each frame at given position. 
            mean_image = nan(size(image,3),1);
            for k = 1:size(image,3)
                mean_image(k) = nanmean(nanmean(image(:,:,k)));
            end
            
            %Set up the initiation parameters for the fitting procedure. 
            initial_parameters = [mean_image(1) - mean_image(end), 0.0001, mean_image(end)];
            %Supress message output of function. 
            opts = optimset('Display','off');
            
            %Find optimal fitting parameters using least square fitting
            %approach. 
            p.(strcat('channel',num2str(i))).(strcat('num',num2str(j))) = lsqcurvefit(@(x,xdata)fun_bleach_correction(x,xdata), initial_parameters, t, mean_image, [], [], opts);
            
            %Color index for photobleach curves visualization. Since there
            %are only 64 colors available: in case of more than 64
            %positions keep on using the 64th color. 
            if j <= 64
                color_index = j;
            else
                color_index = 64;
            end
            
            %Plot the experimental data and the resulting fit for each
            %position. 
            plot(correction_axes, t, fun_bleach_correction(p.(strcat('channel',num2str(i))).(strcat('num',num2str(j))), t), 'Color', c(color_index,:), 'LineStyle', '--') 
            hold on 
            plot(t, mean_image, 'Color', c(color_index,:));
            title(strcat('Channel ',num2str(i), 'mean intensity'))
            hold on
        end
        
        %Ask user if it wants to apply the photobleach correction after
        %visual inspection of the fits. 
        answer = questdlg(strcat('Apply photobleach correction channel ',num2str(i),'?'),...
            'QuestionDialog',...
            'Yes','No','No');

        switch answer
            %User wants to apply photobleach correction. 
            case 'Yes'
                %Close the figure with photobleaching curves. 
                close('Bleach correction')
                
                %Do bleach correction per position. 
                for j = 1:handles.num_position
                    %Get image at current position. 
                    image = handles.Image_combined.(strcat('channel', num2str(i))).(strcat('num', num2str(j)));
                    
                    %Pre-allocate vector. 
                    corrected_image = nan(size(image,1),size(image,2),size(image,3));
                    for k = 1:size(image,3)
                        %Determine the fit ratio of given frame/starting
                        %frame. 
                        ratio = fun_bleach_correction(p.(strcat('channel',num2str(i))).(strcat('num',num2str(j))),1)/fun_bleach_correction(p.(strcat('channel',num2str(i))).(strcat('num',num2str(j))), k);
                        
                        %Correct image at given frame with fit ratio. 
                        corrected_image(:,:,k) = image(:,:,k).*ratio;
                    end
                    
                    %Replace the original image with the corrected image. 
                    handles.Image_combined.(strcat('channel', num2str(i))).(strcat('num', num2str(j))) = corrected_image;
                end
                
                %Note that photobleach correction is being used for this
                %channel. 
                handles.bleach_correction(i) = 1;
            %User doesn't want to apply photobleach correction. 
            case 'No'
                %Close the figure with the photobleaching curves. 
                close('Bleach correction')
        end
    %Follow in case photobleach correction is already done for given
    %channel. 
    elseif handles.bleach_correction(i) ==1
        %Ask user if it wants to remove the photobleach correction at given
        %channel. 
        answer = questdlg(strcat('Remove photobleach correction channel ',num2str(i),'?'),...
            'QuestionDialog',...
            'Yes','No','No');
        switch answer
            %User wants to remove correction. 
            case 'Yes'
                %At each position: replace the corrected image with the
                %back-up image (this is always the uncorrected image). 
                for j = 1:handles.num_position
                    handles.Image_combined.(strcat('channel', num2str(i))).(strcat('num', num2str(j))) = handles.Image_combined_backup.(strcat('channel', num2str(i))).(strcat('num', num2str(j)));
                end
                %Note that bleach correction is not used at given position.
                handles.bleach_correction(i) = 0;
            %User doesn't want to remove correction. 
            case 'No'
        end
    end
end

%Load app data.
hMainGui = getappdata(0, 'hMainGui');

%Set (new) bleach correction status in metadata file. 
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{1,2} = handles.bleach_correction;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

%Retrieve settings for displaying image. 
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette');
channels = getappdata(hMainGui, 'channels_selection');

analysis_visuals = getappdata(hMainGui, 'analysis_visuals');

roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');

%Display image. 
displayim(handles.Image_combined, handles.axes8, handles.x, handles.y, handles.frame, handles.position, handles.zoomfactor,...
    handles.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);




% --- Executes when user starts single channel analysis.
function single_channel_menu_Callback(hObject, eventdata, handles)

%Retrieve app data.
hMainGui = getappdata(0, 'hMainGui');

%Only start analysis when there is a movie loaded into TransTrack and when
%there is no other analysis is active at the moment.
if handles.active_image ==0
    errordlg('First load movie into TransTrack', 'Error')
    return
elseif getappdata(hMainGui, 'active_analysis') ~=0
    return
end

%Notify that analysis is active now.
setappdata(hMainGui, 'active_analysis', 1);

%Set in metadata that analysis type 1 is performed. 
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{6,2} = 1;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

%Start up single channel tracking GUI. 
SingleChannelTracking

guidata(hObject, handles);




% --- Excecutes when user starts track finder menu. 
function track_finder_menu_Callback(hObject, eventdata, handles)

%Retrieve app data. 
hMainGui = getappdata(0, 'hMainGui');

%If no movie is loaded in TransTrack, or if there is not an active
%analysis, this menu cannot be started. 
if handles.active_image ==0
    errordlg('First load movie into TransTrack', 'Error')
    return
elseif getappdata(hMainGui, 'active_analysis') ==0
    errordlg('First start analysis before you can search a track', 'Error')
    return
end


%Ask the user for track number and position 
prompt = {'position:', 'tracknumber:'};
dims = [1,12];

input_user = inputdlg(prompt,'Open image',dims);

%If user didn't give any input, return. 
if isempty(input_user)
    return
end

%Obtain input position and tracknumber. 
position = floor(str2double(input_user{1}));
track_number = floor(str2double(input_user{2}));

%Return in case position or tracknumber is incorrect (string, smaller than
%1). Return in case position is larger than number of positions in movie.
if isnan(position)
    errordlg('Incorrect position given', 'Error')
    return
elseif isnan(track_number)
    errordlg('Incorrect tracknumber given', 'Error')
elseif position <1
    errordlg('Position cannot be smaller than 1', 'Error')
    return
elseif position >handles.num_position
    errordlg('Not this many positions in movie', 'Error')
    return
elseif track_number <1
    errordlg('Tracknumber cannot be smaller than 1', 'Error')
    return
end

%Retrieve the selected tracks. 
selected_tracks = getappdata(hMainGui, 'selected_tracks');

%If there are no selected tracks at given position, return. 
if isempty(selected_tracks.(strcat('num', num2str(position))))
    errordlg('No tracks present at given position', 'Error')
    return
end

%Get the amount of tracks at position. 
max_track_number = max(selected_tracks.(strcat('num', num2str(position)))(:,1));

%If tracknumber is larger than amount of tracks at position; return. 
if track_number >max_track_number
    errordlg(strcat({'There are only '}, num2str(max_track_number), {' tracks at this position!'}),'Error')
    return
end

%Find index of track of interest. 
index_track = find(selected_tracks.(strcat('num', num2str(position)))(:,1)== track_number);

%Get x,y coordinates of first frame of track of interest. 
x = selected_tracks.(strcat('num', num2str(position)))(index_track(1),2);
y = selected_tracks.(strcat('num', num2str(position)))(index_track(1),3);

%Update position and frame according to track of interest. 
handles.position = position;
handles.frame = selected_tracks.(strcat('num', num2str(position)))(index_track(1),4);

%Update frame and position slider accordingly. 
set(handles.frame_slider, 'Value', handles.frame);
set(handles.frame_edit, 'String', handles.frame);
set(handles.position_slider, 'Value', handles.position);
set(handles.position_edit, 'String', handles.position);

%Retrieve settings for displaying image. 
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette');
channels = getappdata(hMainGui, 'channels_selection');
analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');

%Display image. 
displayim(handles.Image_combined, handles.axes8, handles.x, handles.y, handles.frame, handles.position, handles.zoomfactor,...
    handles.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);
hold on 
plot(x,y,'marker','o','markersize',40, 'MarkerEdgeColor', 'm')

guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Section 5 - Close TransTrack%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes when user attempts to close Gui1.
function Gui1_CloseRequestFcn(hObject, eventdata, handles)

%Ask if user is sure to quit the GUI. 
answer = questdlg('Are you sure you want to end this session?', ...
	'Quit', ...
	'Yes','No','No');

% Handle response. Only continuing with closing in case user confirmed. 
switch answer
    case 'Yes'
        handles.active_transtrack = 0;
    case 'No'
        return
    case '' 
        return
end
guidata(hObject, handles);

%Close sub-GUIs if they are open. 
if ~isempty(findobj('Name','Display Settings'))
    close('Display Settings')
end
if ~isempty(findobj('Name','Channels'))
    close('Channels')
end
if ~isempty(findobj('Name','Single Channel Tracking'))
    close('Single Channel Tracking')
end
if ~isempty(findobj('Name','Measured Data'))
    close('Measured Data')
end
if ~isempty(findobj('Name','Save'))
    close('Save')
end

%delete(hObject) closes the figure
delete(hObject);
