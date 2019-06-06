function varargout = Channels(varargin)
% CHANNELS MATLAB code for Channels.fig
%      CHANNELS, by itself, creates a new CHANNELS or raises the existing
%      singleton*.
%
%      H = CHANNELS returns the handle to a new CHANNELS or the handle to
%      the existing singleton*.
%
%      CHANNELS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHANNELS.M with the given input arguments.
%
%      CHANNELS('Property','Value',...) creates a new CHANNELS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Channels_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Channels_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Last Modified by GUIDE v2.5 18-Feb-2019 22:41:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Channels_OpeningFcn, ...
                   'gui_OutputFcn',  @Channels_OutputFcn, ...
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


% --- Executes just before Channels is made visible.
function Channels_OpeningFcn(hObject, eventdata, handles, varargin)

%Get handles from main GUI. 
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Get app data: colours and channel settings. 
hMainGui = getappdata(0, 'hMainGui');
colour_palette = getappdata(hMainGui, 'colour_palette');
channels = getappdata(hMainGui, 'channels_selection');

%Set the correct color for each channel. 
set(handles.colour1_pushbutton, 'BackgroundColor', colour_palette(1,:));
set(handles.colour2_pushbutton, 'BackgroundColor', colour_palette(2,:));
set(handles.colour3_pushbutton, 'BackgroundColor', colour_palette(3,:));
set(handles.colour4_pushbutton, 'BackgroundColor', colour_palette(4,:));
set(handles.colour5_pushbutton, 'BackgroundColor', colour_palette(5,:));
set(handles.colour6_pushbutton, 'BackgroundColor', colour_palette(6,:));

%Get number of channels in movie. 
handles.num_channels = g1data.num_channels;

%Depending on number of channels in movie, adjust the lay-out (only channel
%settings for the number of channels present in movie). 
if handles.num_channels ==1
    set(handles.figure1,'Position',[130,60,30,3])
    
    set(handles.channel1_checkbox,'Position',[3.625,0.5238095238095237,15.875,1.3809523809523814])
    set(handles.colour1_pushbutton,'Position',[21.875,0.38095238095238093,4.625,1.7142857142857135])
    
    set(handles.channel1_checkbox, 'Value', channels(1))
elseif handles.num_channels ==2
    set(handles.figure1,'Position',[130,60,30,5.5])
    
    set(handles.channel1_checkbox,'Position',[3.625,2.761904761904762,15.875,1.3809523809523814])
    set(handles.colour1_pushbutton,'Position',[21.875,2.619047619047619,4.625,1.7142857142857135])
    
    set(handles.channel2_checkbox,'Visible','on')
    set(handles.channel2_checkbox,'Position',[3.625,0.5238095238095237,15.875,1.3809523809523814])
    set(handles.colour2_pushbutton,'Visible','on')
    set(handles.colour2_pushbutton,'Position',[21.875,0.38095238095238093,4.625,1.7142857142857135])
    
    set(handles.channel1_checkbox, 'Value', channels(1))
    set(handles.channel2_checkbox, 'Value', channels(2))
    
elseif handles.num_channels ==3
    set(handles.figure1,'Position',[130,60,30,7.5])
    
    set(handles.channel1_checkbox,'Position',[3.625,5,15.875,1.3809523809523814])
    set(handles.colour1_pushbutton,'Position',[21.875,4.857142857142857,4.625,1.7142857142857135])
    
    set(handles.channel2_checkbox,'Visible','on')
    set(handles.channel2_checkbox,'Position',[3.625,2.761904761904762,15.875,1.3809523809523814])
    set(handles.colour2_pushbutton,'Visible','on')
    set(handles.colour2_pushbutton,'Position',[21.875,2.619047619047619,4.625,1.7142857142857135])
    
    set(handles.channel3_checkbox,'Visible','on')
    set(handles.channel3_checkbox,'Position',[3.625,0.5238095238095237,15.875,1.3809523809523814])
    set(handles.colour3_pushbutton,'Visible','on')
    set(handles.colour3_pushbutton,'Position',[21.875,0.38095238095238093,4.625,1.7142857142857135])
    
    set(handles.channel1_checkbox, 'Value', channels(1))
    set(handles.channel2_checkbox, 'Value', channels(2))
    set(handles.channel3_checkbox, 'Value', channels(3))
    
elseif handles.num_channels ==4
    set(handles.figure1,'Position',[130,60,30,10])
    
    set(handles.channel1_checkbox,'Position',[3.625,7.238095238095237,15.875,1.3809523809523814])
    set(handles.colour1_pushbutton,'Position',[21.875,7.095238095238095,4.625,1.7142857142857135])
    
    set(handles.channel2_checkbox,'Visible','on')
    set(handles.channel2_checkbox,'Position',[3.625,5,15.875,1.3809523809523814])
    set(handles.colour2_pushbutton,'Visible','on')
    set(handles.colour2_pushbutton,'Position',[21.875,4.857142857142857,4.625,1.7142857142857135])
    
    set(handles.channel3_checkbox,'Visible','on')
    set(handles.channel3_checkbox,'Position',[3.625,2.761904761904762,15.875,1.3809523809523814])
    set(handles.colour3_pushbutton,'Visible','on')
    set(handles.colour3_pushbutton,'Position',[21.875,2.619047619047619,4.625,1.7142857142857135])
    
    set(handles.channel4_checkbox,'Visible','on')
    set(handles.channel4_checkbox,'Position',[3.625,0.5238095238095237,15.875,1.3809523809523814])
    set(handles.colour4_pushbutton,'Visible','on')
    set(handles.colour4_pushbutton,'Position',[21.875,0.38095238095238093,4.625,1.7142857142857135])
    
    set(handles.channel1_checkbox, 'Value', channels(1))
    set(handles.channel2_checkbox, 'Value', channels(2))
    set(handles.channel3_checkbox, 'Value', channels(3))
    set(handles.channel4_checkbox, 'Value', channels(4))
    
elseif handles.num_channels ==5
    set(handles.figure1,'Position',[130,60,30,12.5])
    
    set(handles.channel1_checkbox,'Position',[3.625,9.476190476190476,15.875,1.3809523809523814])
    set(handles.colour1_pushbutton,'Position',[21.875,9.333333333333332,4.625,1.7142857142857135])
    
    set(handles.channel2_checkbox,'Visible','on')
    set(handles.channel2_checkbox,'Position',[3.625,7.238095238095237,15.875,1.3809523809523814])
    set(handles.colour2_pushbutton,'Visible','on')
    set(handles.colour2_pushbutton,'Position',[21.875,7.095238095238095,4.625,1.7142857142857135])
    
    set(handles.channel3_checkbox,'Visible','on')
    set(handles.channel3_checkbox,'Position',[3.625,5,15.875,1.3809523809523814])
    set(handles.colour3_pushbutton,'Visible','on')
    set(handles.colour3_pushbutton,'Position',[21.875,4.857142857142857,4.625,1.7142857142857135])
    
    set(handles.channel4_checkbox,'Visible','on')
    set(handles.channel4_checkbox,'Position',[3.625,2.761904761904762,15.875,1.3809523809523814])
    set(handles.colour4_pushbutton,'Visible','on')
    set(handles.colour4_pushbutton,'Position',[21.875,2.619047619047619,4.625,1.7142857142857135])
    
    set(handles.channel5_checkbox,'Visible','on')
    set(handles.channel5_checkbox,'Position',[3.625,0.5238095238095237,15.875,1.3809523809523814])
    set(handles.colour5_pushbutton,'Visible','on')
    set(handles.colour5_pushbutton,'Position',[21.875,0.38095238095238093,4.625,1.7142857142857135])
    
    set(handles.channel1_checkbox, 'Value', channels(1))
    set(handles.channel2_checkbox, 'Value', channels(2))
    set(handles.channel3_checkbox, 'Value', channels(3))
    set(handles.channel4_checkbox, 'Value', channels(4))
    set(handles.channel5_checkbox, 'Value', channels(5))
    
elseif handles.num_channels ==6
    set(handles.channel2_checkbox,'Visible','on')
    set(handles.colour2_pushbutton,'Visible','on')
    
    set(handles.channel3_checkbox,'Visible','on')
    set(handles.colour3_pushbutton,'Visible','on')
    
    set(handles.channel4_checkbox,'Visible','on')
    set(handles.colour4_pushbutton,'Visible','on')
    
    set(handles.channel5_checkbox,'Visible','on')
    set(handles.colour5_pushbutton,'Visible','on')
    
    set(handles.channel6_checkbox,'Visible','on')
    set(handles.colour6_pushbutton,'Visible','on')
    
    set(handles.channel1_checkbox, 'Value', channels(1))
    set(handles.channel2_checkbox, 'Value', channels(2))
    set(handles.channel3_checkbox, 'Value', channels(3))
    set(handles.channel4_checkbox, 'Value', channels(4))
    set(handles.channel5_checkbox, 'Value', channels(5))
    set(handles.channel6_checkbox, 'Value', channels(6))
end

% Choose default command line output for Channels
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = Channels_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Section 1 - Channel visibility settings%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in channel1_checkbox.
function channel1_checkbox_Callback(hObject, eventdata, handles)

%Get channel visibility status. 
channel = get(hObject,'Value');

%Get handles of main GUI. 
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Update channel visibility status in app data. 
hMainGui = getappdata(0, 'hMainGui');
channels_selection = getappdata(hMainGui, 'channels_selection');
channels_selection(1) = channel;

%Save channel visibility in app data. 
setappdata(hMainGui, 'channels_selection', channels_selection)

%Retrieve display settings. 
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette');
analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels_selection, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);


% --- Executes on button press in channel2_checkbox.
function channel2_checkbox_Callback(hObject, eventdata, handles)

%Get channel visibility status. 
channel = get(hObject,'Value');

%Get handles of main GUI. 
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Update channel visibility status in app data. 
hMainGui = getappdata(0, 'hMainGui');
channels_selection = getappdata(hMainGui, 'channels_selection');
channels_selection(2) = channel;

%Save channel visibility in app data. 
setappdata(hMainGui, 'channels_selection', channels_selection)

%Retrieve display settings.
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette');
analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels_selection, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);


% --- Executes on button press in channel3_checkbox.
function channel3_checkbox_Callback(hObject, eventdata, handles)

%Get channel visibility status. 
channel = get(hObject,'Value');

%Get handles of main GUI. 
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Update channel visibility status in app data. 
hMainGui = getappdata(0, 'hMainGui');
channels_selection = getappdata(hMainGui, 'channels_selection');
channels_selection(3) = channel;

%Save channel visibility in app data. 
setappdata(hMainGui, 'channels_selection', channels_selection)

%Retrieve display settings.
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette');
analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels_selection, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);


% --- Executes on button press in channel4_checkbox.
function channel4_checkbox_Callback(hObject, eventdata, handles)

%Get channel visibility status. 
channel = get(hObject,'Value');

%Get handles of main GUI.
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Update channel visibility status in app data. 
hMainGui = getappdata(0, 'hMainGui');
channels_selection = getappdata(hMainGui, 'channels_selection');
channels_selection(4) = channel;

%Save channel visibility in app data. 
setappdata(hMainGui, 'channels_selection', channels_selection)

%Retrieve display settings.
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette');
analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels_selection, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);


% --- Executes on button press in channel5_checkbox.
function channel5_checkbox_Callback(hObject, eventdata, handles)

%Get channel visibility status. 
channel = get(hObject,'Value');

%Get handles of main GUI.
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Update channel visibility status in app data. 
hMainGui = getappdata(0, 'hMainGui');
channels_selection = getappdata(hMainGui, 'channels_selection');
channels_selection(5) = channel;

%Save channel visibility in app data. 
setappdata(hMainGui, 'channels_selection', channels_selection)

%Retrieve display settings.
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette');
analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels_selection, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);


% --- Executes on button press in channel6_checkbox.
function channel6_checkbox_Callback(hObject, eventdata, handles)

%Get channel visibility status.
channel = get(hObject,'Value');

%Get handles of main GUI.
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Update channel visibility status in app data. 
hMainGui = getappdata(0, 'hMainGui');
channels_selection = getappdata(hMainGui, 'channels_selection');
channels_selection(6) = channel;

%Save channel visibility in app data. 
setappdata(hMainGui, 'channels_selection', channels_selection)

%Retrieve display settings.
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette');
analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels_selection, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Section 2 - Channel colour settings%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in colour1_pushbutton.
function colour1_pushbutton_Callback(hObject, eventdata, handles)

%Get channel colour settings. 
colour = uisetcolor();

%In case user cancels colour selection; return. 
if size(colour,2)<3
    return
end

%Update colour settings. 
hMainGui = getappdata(0, 'hMainGui');
colour_palette = getappdata(hMainGui, 'colour_palette');
colour_palette(1,:) = colour;

%Save colour settings in app data and update colour button. 
setappdata(hMainGui, 'colour_palette', colour_palette);
set(handles.colour1_pushbutton, 'BackgroundColor', colour_palette(1,:));

%Get handles of main GUI. 
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Retrieve display settings. 
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
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
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour_palette, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);


% --- Executes on button press in colour2_pushbutton.
function colour2_pushbutton_Callback(hObject, eventdata, handles)

%Get channel colour settings. 
colour = uisetcolor();

%In case user cancels colour selection; return.
if size(colour,2)<3
    return
end

%Update colour settings. 
hMainGui = getappdata(0, 'hMainGui');
colour_palette = getappdata(hMainGui, 'colour_palette');
colour_palette(2,:) = colour;

%Save colour settings in app data and update colour button. 
setappdata(hMainGui, 'colour_palette', colour_palette);
set(handles.colour2_pushbutton, 'BackgroundColor', colour_palette(2,:));

%Get handles of main GUI. 
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Retrieve display settings. 
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
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
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour_palette, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);


% --- Executes on button press in colour3_pushbutton.
function colour3_pushbutton_Callback(hObject, eventdata, handles)

%Get channel colour settings. 
colour = uisetcolor();

%In case user cancels colour selection; return.
if size(colour,2)<3
    return
end

%Update colour settings. 
hMainGui = getappdata(0, 'hMainGui');
colour_palette = getappdata(hMainGui, 'colour_palette');
colour_palette(3,:) = colour;

%Save colour settings in app data and update colour button.
setappdata(hMainGui, 'colour_palette', colour_palette);
set(handles.colour3_pushbutton, 'BackgroundColor', colour_palette(3,:));

%Get handles of main GUI.
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Retrieve display settings.
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
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
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour_palette, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);


% --- Executes on button press in colour4_pushbutton.
function colour4_pushbutton_Callback(hObject, eventdata, handles)

%Get channel colour settings. 
colour = uisetcolor();

%In case user cancels colour selection; return.
if size(colour,2)<3
    return
end

%Update colour settings. 
hMainGui = getappdata(0, 'hMainGui');
colour_palette = getappdata(hMainGui, 'colour_palette');
colour_palette(4,:) = colour;

%Save colour settings in app data and update colour button.
setappdata(hMainGui, 'colour_palette', colour_palette);
set(handles.colour4_pushbutton, 'BackgroundColor', colour_palette(4,:));

%Get handles of main GUI.
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Retrieve display settings.
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
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
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour_palette, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);


% --- Executes on button press in colour5_pushbutton.
function colour5_pushbutton_Callback(hObject, eventdata, handles)

%Get channel colour settings. 
colour = uisetcolor();

%In case user cancels colour selection; return.
if size(colour,2)<3
    return
end

%Update colour settings. 
hMainGui = getappdata(0, 'hMainGui');
colour_palette = getappdata(hMainGui, 'colour_palette');
colour_palette(5,:) = colour;

%Save colour settings in app data and update colour button.
setappdata(hMainGui, 'colour_palette', colour_palette);
set(handles.colour5_pushbutton, 'BackgroundColor', colour_palette(5,:));

%Get handles of main GUI.
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Retrieve display settings.
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
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
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour_palette, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);


% --- Executes on button press in colour6_pushbutton.
function colour6_pushbutton_Callback(hObject, eventdata, handles)

%Get channel colour settings. 
colour = uisetcolor();

%In case user cancels colour selection; return.
if size(colour,2)<3
    return
end

%Update colour settings. 
hMainGui = getappdata(0, 'hMainGui');
colour_palette = getappdata(hMainGui, 'colour_palette');
colour_palette(6,:) = colour;

%Save colour settings in app data and update colour button.
setappdata(hMainGui, 'colour_palette', colour_palette);
set(handles.colour6_pushbutton, 'BackgroundColor', colour_palette(6,:));

%Get handles of main GUI.
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Retrieve display settings.
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
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
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour_palette, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);
