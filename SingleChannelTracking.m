function varargout = SingleChannelTracking(varargin)
% SINGLECHANNELTRACKING MATLAB code for SingleChannelTracking.fig
%      SINGLECHANNELTRACKING, by itself, creates a new SINGLECHANNELTRACKING or raises the existing
%      singleton*.
%
%      H = SINGLECHANNELTRACKING returns the handle to a new SINGLECHANNELTRACKING or the handle to
%      the existing singleton*.
%
%      SINGLECHANNELTRACKING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SINGLECHANNELTRACKING.M with the given input arguments.
%
%      SINGLECHANNELTRACKING('Property','Value',...) creates a new SINGLECHANNELTRACKING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SingleChannelTracking_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SingleChannelTracking_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SingleChannelTracking

% Last Modified by GUIDE v2.5 19-Apr-2019 17:46:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SingleChannelTracking_OpeningFcn, ...
                   'gui_OutputFcn',  @SingleChannelTracking_OutputFcn, ...
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


% --- Executes just before SingleChannelTracking is made visible.
function SingleChannelTracking_OpeningFcn(hObject, eventdata, handles, varargin)

h = findobj('Tag','Gui1');
g1data = guidata(h);

analysis_options = cell(1+g1data.num_channels,1);
analysis_options{1} = 'Choose Channel';
presence_options = cell(1+g1data.num_channels,1);
fov_options = cell(1+g1data.num_channels,1);

for i = 1:g1data.num_channels
    analysis_options{i+1} = ['Channel', ' ', num2str(i)];
    presence_options{i+1} = ['Channel', ' ', num2str(i)];
    fov_options{i+1} = ['Channel', ' ', num2str(i)];
end
set(handles.channel_popupmenu, 'String', analysis_options);
set(handles.presence_channel_popupmenu, 'String', presence_options);
set(handles.fov_channel_popupmenu, 'String', fov_options);

handles.positions = [];

hMainGui = getappdata(0, 'hMainGui');

handles.use_roi = 0;
handles.roi_presence = zeros(g1data.num_position, 1);

roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
for i = 1:g1data.num_position
    if ~isempty(roi_boundaries.(strcat('num',num2str(i))))
        handles.roi_presence(i) = 1;
    end
end

%Set all analysis visuals correctly. 
analysis_visuals = getappdata(hMainGui, 'analysis_visuals');

set(handles.view_roi_checkbox, 'Value', analysis_visuals(1));
set(handles.view_peaks_checkbox, 'Value', analysis_visuals(2));
set(handles.view_tracks_checkbox, 'Value', analysis_visuals(3));
set(handles.view_selected_tracks_checkbox, 'Value', analysis_visuals(4));
set(handles.view_tracknumber_checkbox, 'Value', analysis_visuals(5));

%Set all analysis settings correctly. 
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

handles.analysis_channel = analysis_metadata{7,2}; set(handles.channel_popupmenu, 'Value', handles.analysis_channel+1);
handles.noisesz = analysis_metadata{8,2}; set(handles.noise_size_edit, 'String', handles.noisesz);
handles.objectsz = analysis_metadata{9,2}; set(handles.object_size_edit, 'String', handles.objectsz);
handles.noiselvl = analysis_metadata{10,2}; set(handles.noise_level_edit, 'String', handles.noiselvl);
handles.threshold = analysis_metadata{11,2}; set(handles.threshold_edit, 'String', handles.threshold);
handles.tracking_distance = analysis_metadata{12,2}; set(handles.tracking_distance_edit, 'String', handles.tracking_distance);
handles.frame_skipping = analysis_metadata{13,2}; set(handles.frame_skipping_edit, 'String', handles.frame_skipping);
handles.overlap_analysis_filter = analysis_metadata{14,2}; set(handles.overlap_checkbox, 'Value', handles.overlap_analysis_filter);
handles.start_analysis_filter = analysis_metadata{15,2}; set(handles.start_analysis_checkbox, 'Value', handles.start_analysis_filter);
handles.start_analysis = analysis_metadata{16,2}; set(handles.start_analysis_edit, 'String', handles.start_analysis);
handles.end_analysis_filter = analysis_metadata{17,2}; set(handles.end_analysis_checkbox, 'Value', handles.end_analysis_filter);
handles.end_analysis = analysis_metadata{18,2}; set(handles.end_analysis_edit, 'String', handles.end_analysis);
handles.tracklength_filter = analysis_metadata{19,2}; set(handles.tracklength_checkbox, 'Value', handles.tracklength_filter);
handles.tracklength = analysis_metadata{20,2}; set(handles.tracklength_edit, 'String', handles.tracklength);
handles.presence_filter = analysis_metadata{21,2}; set(handles.presence_checkbox, 'Value', handles.presence_filter);
handles.presence_channel = analysis_metadata{22,2}; set(handles.presence_channel_popupmenu, 'Value', handles.presence_channel+1);
handles.presence_threshold = analysis_metadata{23,2}; set(handles.presence_threshold_edit, 'String', handles.presence_threshold);
handles.presence_length = analysis_metadata{24,2}; set(handles.presence_length_edit, 'String', handles.presence_length);
handles.fov_filter = analysis_metadata{25,2}; set(handles.fov_checkbox, 'Value', handles.fov_filter);
handles.fov_channel = analysis_metadata{26,2}; set(handles.fov_channel_popupmenu, 'Value', handles.fov_channel+1);
handles.fov_selection = analysis_metadata{27,2}; set(handles.fov_selection_popupmenu, 'Value', handles.fov_selection+1);
handles.fov_threshold = analysis_metadata{28,2}; set(handles.fov_threshold_edit, 'String', handles.fov_threshold);

%Set track repair standard values. 
handles.tracknumber1 = NaN;
handles.tracknumber2 = NaN; handles.lower_clip = []; handles.upper_clip = [];
handles.tracknumber3 = NaN; handles.tracknumber4 = NaN; handles.merge_limit1 = NaN; handles.merge_limit2 = NaN;

% Choose default command line output for SingleChannelTracking
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = SingleChannelTracking_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;




% --- Executes on selection change in channel_popupmenu.
function channel_popupmenu_Callback(hObject, eventdata, handles)


%User can choose in which channel he wants to track. If no channel is selected set at value 0.   
handles.analysis_channel = get(hObject,'Value') - 1;

handles.presence_channel = 0;
set(handles.presence_channel_popupmenu, 'Value', handles.presence_channel+1);
handles.fov_channel = 0;
set(handles.fov_channel_popupmenu, 'Value', handles.fov_channel+1);

hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{7,2} = handles.analysis_channel;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function channel_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in clear_pushbutton.
function clear_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to clear_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

answer = questdlg(strcat('Are you sure you want to clear the given positions?'),...
            'QuestionDialog',...
            'Yes','No','No');

switch answer
    %User wants to do clear function
    case 'Yes'
        h = findobj('Tag','Gui1');
        g1data = guidata(h);

        %Determine the amount of positions given by the user.
        if size(handles.positions,1)==0
            errordlg('No positions given','Error')
            return
        elseif size(handles.positions,2)==3
            num_positions = g1data.num_position;
            positions = (1:num_positions)';
        else
            num_positions = size(handles.positions,1);
            positions = handles.positions;
        end

        hMainGui = getappdata(0, 'hMainGui');

        peaks = getappdata(hMainGui, 'peaks');
        preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
        selected_tracks = getappdata(hMainGui, 'selected_tracks');

        for i = 1:num_positions
            peaks.(strcat('num', num2str(positions(i)))) = [];
            preliminary_tracks.(strcat('num', num2str(positions(i)))) = []; 
            selected_tracks.(strcat('num', num2str(positions(i)))) = [];
        end

        setappdata(hMainGui, 'peaks', peaks);
        setappdata(hMainGui, 'preliminary_tracks', preliminary_tracks);
        setappdata(hMainGui, 'selected_tracks', selected_tracks);

        minimum_display = getappdata(hMainGui, 'minimum_display');
        maximum_display = getappdata(hMainGui, 'maximum_display');
        colour = getappdata(hMainGui, 'colour_palette'); 
        channels = getappdata(hMainGui, 'channels_selection');
        analysis_visuals = getappdata(hMainGui, 'analysis_visuals');

        roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
        segmented_image = getappdata(hMainGui, 'segmented_image');
        colocalization = getappdata(hMainGui, 'colocalization');

        analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

        %Display image. 
        displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
            g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
            preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);
    case 'No'
end

guidata(hObject, handles);




% --- Executes on button press in view_roi_checkbox.
function view_roi_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to view_roi_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
view_roi = get(hObject,'Value');

hMainGui = getappdata(0, 'hMainGui');
analysis_visuals = getappdata(hMainGui, 'analysis_visuals');

analysis_visuals(1) = view_roi;
setappdata(hMainGui, 'analysis_visuals', analysis_visuals);

h = findobj('Tag','Gui1');
g1data = guidata(h);

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

analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes on button press in view_peaks_checkbox.
function view_peaks_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to view_peaks_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
view_peaks = get(hObject,'Value');

hMainGui = getappdata(0, 'hMainGui');
analysis_visuals = getappdata(hMainGui, 'analysis_visuals');

analysis_visuals(2) = view_peaks;
setappdata(hMainGui, 'analysis_visuals', analysis_visuals);

h = findobj('Tag','Gui1');
g1data = guidata(h);

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

analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes on button press in view_tracks_checkbox.
function view_tracks_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to view_tracks_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
view_tracks = get(hObject,'Value');

hMainGui = getappdata(0, 'hMainGui');
analysis_visuals = getappdata(hMainGui, 'analysis_visuals');

analysis_visuals(3) = view_tracks;
setappdata(hMainGui, 'analysis_visuals', analysis_visuals);

h = findobj('Tag','Gui1');
g1data = guidata(h);

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

analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes on button press in view_selected_tracks_checkbox.
function view_selected_tracks_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to view_selected_tracks_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
view_selected_tracks = get(hObject,'Value');

hMainGui = getappdata(0, 'hMainGui');
analysis_visuals = getappdata(hMainGui, 'analysis_visuals');

analysis_visuals(4) = view_selected_tracks;
setappdata(hMainGui, 'analysis_visuals', analysis_visuals);

h = findobj('Tag','Gui1');
g1data = guidata(h);

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

analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes on button press in view_tracknumber_checkbox.
function view_tracknumber_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to view_tracknumber_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
view_tracknumber = get(hObject,'Value');

hMainGui = getappdata(0, 'hMainGui');
analysis_visuals = getappdata(hMainGui, 'analysis_visuals');

analysis_visuals(5) = view_tracknumber;
setappdata(hMainGui, 'analysis_visuals', analysis_visuals);

h = findobj('Tag','Gui1');
g1data = guidata(h);

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

analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);



function positions_edit_Callback(hObject, eventdata, handles)
% hObject    handle to positions_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Retrieve the positions that the user inserted.
s = get(hObject,'String');

h = findobj('Tag','Gui1');
g1data = guidata(h);

if size(s,1)==1 && size(s,2) ==3
    handles.positions = transpose(1:g1data.num_position);
else
    [row, ~] = size(s);
    
    positions = nan(row,1);
    for i = 1:row
        if isnan(str2double(s(i,:)))
            errordlg('Fill in correct position number','Error')
            set(handles.positions_edit, 'String', num2str(handles.positions));
            return
        elseif str2double(s(i,:))>g1data.num_position
            errordlg('There are not this many positions present in this movie','Error')
            set(handles.positions_edit, 'String', num2str(handles.positions));
            return
        end
        positions(i) = str2double(s(i,:)); 
    end
    handles.positions = positions;
end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function positions_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to positions_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in use_roi_checkbox.
function use_roi_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to use_roi_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.use_roi = get(hObject, 'Value');

guidata(hObject, handles);


% --- Executes on button press in add_roi_pushbutton.
function add_roi_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to add_roi_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = findobj('Tag','Gui1');
g1data = guidata(h);

%List down that at this position ROIs are made. 
handles.roi_presence(g1data.position) = 1;

%Let's the user draw an ROI. 
h = imfreehand(g1data.axes8);
bw_in = createMask(h);

hMainGui = getappdata(0, 'hMainGui');
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');

new_roi = bwboundaries(bw_in);
roi_boundaries.(strcat('num', num2str(g1data.position))){end+1} = new_roi{1};

setappdata(hMainGui, 'roi_boundaries', roi_boundaries);

minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette'); 
channels = getappdata(hMainGui, 'channels_selection');

analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');

analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);


% --- Executes on button press in delete_roi_pushbutton.
function delete_roi_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to delete_roi_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = findobj('Tag','Gui1');
g1data = guidata(h);

hMainGui = getappdata(0, 'hMainGui');
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');

rois = roi_boundaries.(strcat('num', num2str(g1data.position)));

if size(rois,2)<1
    errordlg('There are no ROIs at this position','Error')
    return
end

%Select correct axis. 
axes(g1data.axes8)
%Let user select ROI that has to be deleted.
[x,y] = ginput(1);

present = nan(size(rois,2),1);
for i = 1:size(rois,2)
    present(i) = inpolygon(y, x, rois{i}(:,1), rois{i}(:,2));
end

if sum(present==1)==0
    errordlg('No ROI selected to delete','Error')
    return
elseif sum(present==1)==1
    index = present==1;
    rois(index) = [];
else
    errordlg('Multiple ROIs selected to delete','Error')
    return
end

if size(rois,2)<1
    handles.roi_presence(g1data.position) = 0;
    roi_boundaries.(strcat('num', num2str(g1data.position))) = [];
else
    roi_boundaries.(strcat('num', num2str(g1data.position))) = rois;
end

setappdata(hMainGui, 'roi_boundaries', roi_boundaries);

minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette'); 
channels = getappdata(hMainGui, 'channels_selection');

analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');

analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes on button press in clear_roi_pushbutton.
function clear_roi_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to clear_roi_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = findobj('Tag','Gui1');
g1data = guidata(h);

%Determine the positions given by the user.
if size(handles.positions,1)==0
    errordlg('No positions given','Error')
    return
elseif size(handles.positions,2)==3
    num_positions = g1data.num_position;
    positions = (1:num_positions)';
else
    num_positions = size(handles.positions,1);
    positions = handles.positions;
end

%List down that at given positions ROIs are removed. 
for i = 1:num_positions
    handles.roi_presence(positions(i)) = 0;
end

hMainGui = getappdata(0, 'hMainGui');
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');

%Clear ROI at given positions. 
for i = 1:num_positions
    roi_boundaries.(strcat('num', num2str(positions(i)))) = [];
end

setappdata(hMainGui, 'roi_boundaries', roi_boundaries);

minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette'); 
channels = getappdata(hMainGui, 'channels_selection');

analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');

analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);




function noise_size_edit_Callback(hObject, eventdata, handles)
% hObject    handle to noise_size_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

noisesz = str2double(get(hObject,'String'));

if isnan(noisesz)
    errordlg('Fill in correct value','Error')
    set(handles.noise_size_edit, 'String', num2str(handles.noisesz));
    return
elseif noisesz <=0 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.noise_size_edit, 'String', num2str(handles.noisesz));
    return
elseif noisesz ~= round(noisesz) 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.noise_size_edit, 'String', num2str(handles.noisesz));
    return
end

handles.noisesz = noisesz;

hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{8,2} = noisesz;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function noise_size_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noise_size_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function object_size_edit_Callback(hObject, eventdata, handles)
% hObject    handle to object_size_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

objectsz = str2double(get(hObject,'String'));

if isnan(objectsz)
    errordlg('Fill in correct value','Error')
    set(handles.object_size_edit, 'String', num2str(handles.objectsz));
    return
elseif objectsz <=0 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.object_size_edit, 'String', num2str(handles.objectsz));
    return
elseif objectsz ~= round(objectsz) 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.object_size_edit, 'String', num2str(handles.objectsz));
    return
end

handles.objectsz = objectsz;

hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{9,2} = objectsz;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of object_size_edit as text
%        str2double(get(hObject,'String')) returns contents of object_size_edit as a double


% --- Executes during object creation, after setting all properties.
function object_size_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to object_size_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function noise_level_edit_Callback(hObject, eventdata, handles)
% hObject    handle to noise_level_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

noiselvl = str2double(get(hObject,'String'));

if isnan(noiselvl)
    errordlg('Fill in correct value','Error')
    set(handles.noise_level_edit, 'String', num2str(handles.noiselvl));
    return
elseif noiselvl <=0 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.noise_level_edit, 'String', num2str(handles.noiselvl));
    return
elseif noiselvl ~= round(noiselvl) 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.noise_level_edit, 'String', num2str(handles.noiselvl));
    return
end

handles.noiselvl = noiselvl;

hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{10,2} = noiselvl;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of noise_level_edit as text
%        str2double(get(hObject,'String')) returns contents of noise_level_edit as a double


% --- Executes during object creation, after setting all properties.
function noise_level_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noise_level_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function threshold_edit_Callback(hObject, eventdata, handles)
% hObject    handle to threshold_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

threshold = str2double(get(hObject,'String'));

if isnan(threshold)
    errordlg('Fill in correct value','Error')
    set(handles.threshold_edit, 'String', num2str(handles.threshold));
    return
elseif threshold <=0 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.threshold_edit, 'String', num2str(handles.threshold));
    return
elseif threshold ~= round(threshold) 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.threshold_edit, 'String', num2str(handles.threshold));
    return
end

handles.threshold = threshold;

hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{11,2} = threshold;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of threshold_edit as text
%        str2double(get(hObject,'String')) returns contents of threshold_edit as a double


% --- Executes during object creation, after setting all properties.
function threshold_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tracking_distance_edit_Callback(hObject, eventdata, handles)
% hObject    handle to tracking_distance_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tracking_distance = str2double(get(hObject,'String'));

if isnan(tracking_distance)
    errordlg('Fill in correct value','Error')
    set(handles.tracking_distance_edit, 'String', num2str(handles.tracking_distance));
    return
elseif tracking_distance <=0 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.tracking_distance_edit, 'String', num2str(handles.tracking_distance));
    return
elseif tracking_distance ~= round(tracking_distance) 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.tracking_distance_edit, 'String', num2str(handles.tracking_distance));
    return
end

handles.tracking_distance = tracking_distance;

hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{12,2} = tracking_distance;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of tracking_distance_edit as text
%        str2double(get(hObject,'String')) returns contents of tracking_distance_edit as a double


% --- Executes during object creation, after setting all properties.
function tracking_distance_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tracking_distance_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function frame_skipping_edit_Callback(hObject, eventdata, handles)
% hObject    handle to frame_skipping_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

frame_skipping = str2double(get(hObject,'String'));

if isnan(frame_skipping)
    errordlg('Fill in correct value','Error')
    set(handles.frame_skipping_edit, 'String', num2str(handles.frame_skipping));
    return
elseif frame_skipping <=0 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.frame_skipping_edit, 'String', num2str(handles.frame_skipping));
    return
elseif frame_skipping ~= round(frame_skipping) 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.frame_skipping_edit, 'String', num2str(handles.frame_skipping));
    return
end

handles.frame_skipping = frame_skipping;

hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{13,2} = frame_skipping;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of frame_skipping_edit as text
%        str2double(get(hObject,'String')) returns contents of frame_skipping_edit as a double


% --- Executes during object creation, after setting all properties.
function frame_skipping_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_skipping_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in track_pushbutton.
function track_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to track_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = findobj('Tag','Gui1');
g1data = guidata(h);

%Determine the amount of positions given by the user.
if size(handles.positions,1)==0
    errordlg('No positions given','Error')
    return
elseif size(handles.positions,2)==3
    num_positions = g1data.num_position;
    positions = (1:num_positions)';
else
    num_positions = size(handles.positions,1);
    positions = handles.positions;
end

if handles.analysis_channel ==0
    errordlg('Select channel for analysis','Error')
    return
end

hMainGui = getappdata(0, 'hMainGui');

peaks = getappdata(hMainGui, 'peaks');
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');

progressbar(0)
for i = 1:num_positions
    image = g1data.Image_combined.(strcat('channel', num2str(handles.analysis_channel))).(strcat('num', num2str(positions(i))));
    
    image_corrected = nan(size(image,1), size(image,2), size(image,3));
    %First filter the image with a low and high bandpass filter.
    for j = 1:g1data.total_frames
        image_corrected(:,:,j) = bpass(image(:,:,j), handles.noisesz, handles.objectsz, handles.noiselvl); 
    end
    
    %Find spots in the corrected image by searching for local maxima. Each
    %cell contains all the local maxima found in that frame. If no spot is
    %found in a frame, add a spot at position [1,1]. This is, because the
    %tracking script is not able to work if there is a frame without any
    %spots. 
    peaks.(strcat('num', num2str(positions(i))))  = cell(g1data.total_frames,1);
    for j = 1:g1data.total_frames
        pk = pkfnd(image_corrected(:,:,j), handles.threshold, 5);
        
        if size(pk,1)>0
            peaks.(strcat('num', num2str(positions(i)))) {j} = pk;
        else
            peaks.(strcat('num', num2str(positions(i)))) {j} = [1 1];
        end
    end
    
    %Make tracks from the input (spots positions) with the tracking algorithm.
    tracks = simpletracker(peaks.(strcat('num', num2str(positions(i)))), 'MaxLinkingDistance', handles.tracking_distance, 'MaxGapClosing', handles.frame_skipping);
    
    %Re-write the tracks in a different format. Every track is listed in a
    %cell, extract these tracks and give them a number. 
    tracks_all = [];
    for j = 1:size(tracks,1)
        track = tracks{j};
    
        index_first = find(isnan(track)==0, 1, 'first');
        index_last = find(isnan(track)==0, 1, 'last');
    
        track_clipped = nan(size(index_first:index_last,2),3);
        for k = 1:size(index_first:index_last,2)
            if isnan(track(index_first+k-1))
                track_clipped(k,3) = index_first+k-1;
            else
                track_clipped(k,:) = [peaks.(strcat('num', num2str(positions(i)))){index_first+k-1}(track(index_first+k-1),:), (index_first+k-1)];
            end
        end
        tracknumber = repmat(j,size(track_clipped,1), 1);
    
        tracks_all = [tracks_all; tracknumber, track_clipped];
    end
    
    %In tracks where frame skipping occurs, the missing frames are empty.
    %Use interpolation to calculate the coordinates of the spot in these
    %frames (take average of position before and after gap).
    for j = 1:max(tracks_all(:,1))
        index_track = find(tracks_all(:,1)==j);
        
        for k = 1:size(index_track,1)
            if isnan(tracks_all(index_track(k),2))
                index_min = index_track(k-1);
                index_max = find(~isnan(tracks_all(index_track(k+1):index_track(end),2)),1, 'first') + index_track(k);
                
                tracks_all(index_track(k),2) = tracks_all(index_min,2) + (tracks_all(index_max,2)-tracks_all(index_min,2))/(index_max-index_min);
                tracks_all(index_track(k),3) = tracks_all(index_min,3) + (tracks_all(index_max,3)-tracks_all(index_min,3))/(index_max-index_min);
            end
        end
    end
    
    %Since spots at position [1,1] have been added in each frame where no
    %real spot was present, we want to remove all the tracks that contain
    %these spots. So, determine if a track contains this spot, and remove
    %in case yes.
    number=1;
    tracks_selected = [];
    for j = 1:max(tracks_all(:,1))
        index_track = find(tracks_all(:,1)==j);
        
        sum = tracks_all(index_track,2) + tracks_all(index_track,3);
    
        if any(sum==2)
        else
            if handles.roi_presence(positions(i))==1 && handles.use_roi==1
                rois = roi_boundaries.(strcat('num', num2str(positions(i))));
                
                presence_roi = zeros(size(index_track,1),1);
                for k = 1:size(index_track,1)
                    coordinate = [tracks_all(index_track(k),2),tracks_all(index_track(k),3)];

                    in = zeros(size(rois,2),1);
                    for l = 1:size(rois,2)
                        in(l) = inpolygon(coordinate(:,2), coordinate(:,1), rois{l}(:,1), rois{l}(:,2));
                    end

                    if any(in==1)
                        presence_roi(k) = 1;
                    else
                        presence_roi(k) = 0;
                    end
                end
            
                if any(presence_roi ==0)
                    for k = 1:size(index_track,1)
                        peaks_temp = peaks.(strcat('num', num2str(positions(i)))){tracks_all(index_track(k),4)};
                        index_peaks = find(peaks_temp(:,1)== tracks_all(index_track(k),2) & peaks_temp(:,2)== tracks_all(index_track(k),3));

                        peaks_temp(index_peaks,:)=  [];
                        peaks.(strcat('num', num2str(positions(i)))){tracks_all(index_track(k),4)} = peaks_temp;
                    end
                else
                    tracknumber = repmat(number,size(index_track,1),1);
                    tracks_selected = [tracks_selected; tracknumber, tracks_all(index_track,2:4)];
                    
                    number = number+1;
                end            
            else
                tracknumber = repmat(number,size(index_track,1), 1); 
                tracks_selected = [tracks_selected; tracknumber, tracks_all(index_track,2:4)];
                
                number = number+1;
            end
        end
    end 
    
    if size(tracks_selected,1) >0
        preliminary_tracks.(strcat('num', num2str(positions(i)))) = tracks_selected;
    else
        preliminary_tracks.(strcat('num', num2str(positions(i)))) = [];
    end
        
    progressbar(i/num_positions)
end
progressbar(1)

setappdata(hMainGui, 'peaks', peaks);
setappdata(hMainGui, 'preliminary_tracks', preliminary_tracks);

minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette'); 
channels = getappdata(hMainGui, 'channels_selection');

analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');

analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);




% --- Executes on button press in overlap_checkbox.
function overlap_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to overlap_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Use the overlap filter or not.
handles.overlap_analysis_filter = get(hObject,'Value');

hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{14,2} = handles.overlap_analysis_filter;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of overlap_checkbox


% --- Executes on button press in start_analysis_checkbox.
function start_analysis_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to start_analysis_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Use the start filter or not.
handles.start_analysis_filter = get(hObject,'Value');

hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{15,2} = handles.start_analysis_filter;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of start_analysis_checkbox

function start_analysis_edit_Callback(hObject, eventdata, handles)
% hObject    handle to start_analysis_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

start_analysis = str2double(get(hObject,'String'));

if isnan(start_analysis)
    errordlg('Fill in correct value','Error')
    set(handles.start_analysis_edit, 'String', num2str(handles.start_analysis));
    return
elseif start_analysis <=0 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.start_analysis_edit, 'String', num2str(handles.start_analysis));
    return
elseif start_analysis ~= round(start_analysis) 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.start_analysis_edit, 'String', num2str(handles.start_analysis));
    return
end

handles.start_analysis = start_analysis;

hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{16,2} = start_analysis;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of start_analysis_edit as text
%        str2double(get(hObject,'String')) returns contents of start_analysis_edit as a double


% --- Executes during object creation, after setting all properties.
function start_analysis_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_analysis_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in end_analysis_checkbox.
function end_analysis_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to end_analysis_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Use the end filter or not.
handles.end_analysis_filter = get(hObject,'Value');

hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{17,2} = handles.end_analysis_filter;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of end_analysis_checkbox


function end_analysis_edit_Callback(hObject, eventdata, handles)
% hObject    handle to end_analysis_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end_analysis = str2double(get(hObject,'String'));

if isnan(end_analysis)
    errordlg('Fill in correct value','Error')
    set(handles.end_analysis_edit, 'String', num2str(handles.end_analysis));
    return
elseif end_analysis <=0 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.end_analysis_edit, 'String', num2str(handles.end_analysis));
    return
elseif end_analysis ~= round(end_analysis) 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.end_analysis_edit, 'String', num2str(handles.end_analysis));
    return
end

handles.end_analysis = end_analysis;

hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{18,2} = end_analysis;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of end_analysis_edit as text
%        str2double(get(hObject,'String')) returns contents of end_analysis_edit as a double


% --- Executes during object creation, after setting all properties.
function end_analysis_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to end_analysis_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in tracklength_checkbox.
function tracklength_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to tracklength_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Use the tracklength filter or not.
handles.tracklength_filter = get(hObject,'Value');

hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{19,2} = handles.tracklength_filter;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of tracklength_checkbox

function tracklength_edit_Callback(hObject, eventdata, handles)
% hObject    handle to tracklength_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tracklength = str2double(get(hObject,'String'));

if isnan(tracklength)
    errordlg('Fill in correct value','Error')
    set(handles.tracklength_edit, 'String', num2str(handles.tracklength));
    return
elseif tracklength <=0 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.tracklength_edit, 'String', num2str(handles.tracklength));
    return
elseif tracklength ~= round(tracklength) 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.tracklength_edit, 'String', num2str(handles.tracklength));
    return
end

handles.tracklength = tracklength;

hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{20,2} = tracklength;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of tracklength_edit as text
%        str2double(get(hObject,'String')) returns contents of tracklength_edit as a double


% --- Executes during object creation, after setting all properties.
function tracklength_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tracklength_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in presence_checkbox.
function presence_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to presence_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Use the presence filter or not.
handles.presence_filter = get(hObject,'Value');

hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{21,2} = handles.presence_filter;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

guidata(hObject, handles);


% --- Executes on selection change in presence_channel_popupmenu.
function presence_channel_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to presence_channel_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

presence_channel = get(hObject,'Value') - 1;

if presence_channel~=0 && presence_channel == handles.analysis_channel
    errordlg('Choose another channel than analysis channel', 'Error')
    set(handles.presence_channel_popupmenu, 'Value', handles.presence_channel+1);
    return
end

handles.presence_channel = presence_channel;

hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{22,2} =presence_channel;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns presence_channel_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from presence_channel_popupmenu

% --- Executes during object creation, after setting all properties.
function presence_channel_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to presence_channel_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function presence_threshold_edit_Callback(hObject, eventdata, handles)
% hObject    handle to presence_threshold_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

presence_threshold = str2double(get(hObject,'String'));

if isnan(presence_threshold)
    errordlg('Fill in correct value','Error')
    set(handles.presence_threshold_edit, 'String', num2str(handles.presence_threshold));
    return
elseif presence_threshold <=0 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.presence_threshold_edit, 'String', num2str(handles.presence_threshold));
    return
elseif presence_threshold ~= round(presence_threshold) 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.presence_threshold_edit, 'String', num2str(handles.presence_threshold));
    return
end

handles.presence_threshold = presence_threshold;

hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{23,2} = presence_threshold;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of presence_threshold_edit as text
%        str2double(get(hObject,'String')) returns contents of presence_threshold_edit as a double

% --- Executes during object creation, after setting all properties.
function presence_threshold_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to presence_threshold_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function presence_length_edit_Callback(hObject, eventdata, handles)
% hObject    handle to presence_length_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

presence_length = str2double(get(hObject,'String'));

if isnan(presence_length)
    errordlg('Fill in correct value','Error')
    set(handles.presence_length_edit, 'String', num2str(handles.presence_length));
    return
elseif presence_length <=0 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.presence_length_edit, 'String', num2str(handles.presence_length));
    return
elseif presence_length ~= round(presence_length) 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.presence_length_edit, 'String', num2str(handles.presence_length));
    return
end

handles.presence_length = presence_length;

hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{24,2} = presence_length;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of presence_length_edit as text
%        str2double(get(hObject,'String')) returns contents of presence_length_edit as a double

% --- Executes during object creation, after setting all properties.
function presence_length_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to presence_length_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in fov_checkbox.
function fov_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to fov_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Use the presence filter or not.
handles.fov_filter = get(hObject,'Value');

hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{25,2} = handles.fov_filter;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of fov_checkbox


% --- Executes on selection change in fov_channel_popupmenu.
function fov_channel_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to fov_channel_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fov_channel = get(hObject,'Value') - 1;

if fov_channel~=0 && fov_channel == handles.analysis_channel
    errordlg('Choose another channel than analysis channel', 'Error')
    set(handles.fov_channel_popupmenu, 'Value', handles.fov_channel+1);
    return
end

handles.fov_channel = fov_channel;

hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{26,2} =fov_channel;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns fov_channel_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fov_channel_popupmenu

% --- Executes during object creation, after setting all properties.
function fov_channel_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fov_channel_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fov_selection_popupmenu.
function fov_selection_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to fov_selection_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.fov_selection = get(hObject,'Value') - 1;

hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{27,2} = handles.fov_selection;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns fov_selection_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fov_selection_popupmenu

% --- Executes during object creation, after setting all properties.
function fov_selection_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fov_selection_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function fov_threshold_edit_Callback(hObject, eventdata, handles)
% hObject    handle to fov_threshold_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fov_threshold = str2double(get(hObject,'String'));

if isnan(fov_threshold)
    errordlg('Fill in correct value','Error')
    set(handles.fov_threshold_edit, 'String', num2str(handles.fov_threshold));
    return
elseif fov_threshold <=0 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.fov_threshold_edit, 'String', num2str(handles.fov_threshold));
    return
elseif fov_threshold ~= round(fov_threshold) 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.fov_threshold_edit, 'String', num2str(handles.fov_threshold));
    return
end

handles.fov_threshold = fov_threshold;

hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{28,2} = fov_threshold;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of fov_threshold_edit as text
%        str2double(get(hObject,'String')) returns contents of fov_threshold_edit as a double

% --- Executes during object creation, after setting all properties.
function fov_threshold_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fov_threshold_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in add_track_pushbutton.
function add_track_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to add_track_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = findobj('Tag','Gui1');
g1data = guidata(h);

hMainGui = getappdata(0, 'hMainGui');

preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');

if isempty(preliminary_tracks.(strcat('num', num2str(g1data.position))))
    errordlg('No preliminary tracks at this position', 'Error')
    return
end

%Select correct axis. 
axes(g1data.axes8)

%Offers user to give multiple tracks as input.
[x,y, mouse] = ginput();

x(mouse~=1) = [];
y(mouse~=1) = [];

if isempty(x)
    return
end

number_tracks = size(x,1);
for i = 1:number_tracks
    %Round all the coordinates.
    xo = round(x(i));
    yo = round(y(i));
    t = g1data.frame;
    position = g1data.position;
    
    %Find the closest track to the inserted coordinates from the
    %preliminary track list.
    track_selected = track_finder(preliminary_tracks.(strcat('num', num2str(position))), xo, yo, t);
    
    if ~isempty(track_selected)
        if sum(track_selected(:,1) <= 20) >0
            border_track = 0;
        elseif sum(track_selected(:,1) >= size(g1data.Image_combined.channel1.num1,2)-20) >0
            border_track = 0;
        elseif sum(track_selected(:,2) <=20) >0
            border_track = 0;
        elseif sum(track_selected(:,2) >= size(g1data.Image_combined.channel1.num1,1)-20) >0
            border_track = 0;
        else
            border_track = 1;
        end

        %Check if the track was already selected before. (Look for similar
        %track in the track list).
        if size(selected_tracks.(strcat('num', num2str(position))),1)>0
            coordinates = [track_selected(1,1), track_selected(1,2), track_selected(1,3)];
            similarity = abs(bsxfun(@minus, selected_tracks.(strcat('num', num2str(position)))(:,2:4), coordinates));
            unique_track = min(sum(similarity,2)); 
        else
            unique_track = 1;
        end

        %If track is already selected, do nothing and give warning.
        if unique_track == 0
            warndlg('Track was already selected')
        elseif border_track ==0
            warndlg('Track too close to border of image')
        %Else: determine track number first, and add the track to the list.
        else
            if size(selected_tracks.(strcat('num', num2str(position))),1) == 0
                track_number = 1;
            else
                track_number = max(selected_tracks.(strcat('num', num2str(position)))(:,1)) + 1;
            end

            if size(track_selected, 2) == 3
                track_numbers = repmat(track_number, size(track_selected,1),1);
                selected_tracks.(strcat('num', num2str(position))) = [selected_tracks.(strcat('num', num2str(position))); track_numbers, track_selected];
            else
            end
        end
    end
end

setappdata(hMainGui, 'selected_tracks', selected_tracks);

minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette'); 
channels = getappdata(hMainGui, 'channels_selection');

analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');

analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes on button press in make_tracks_pushbutton.
function make_tracks_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to make_tracks_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = findobj('Tag','Gui1');
g1data = guidata(h);

hMainGui = getappdata(0, 'hMainGui');

preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');

if any(~structfun(@isempty, selected_tracks))
    answer = questdlg(strcat('This will overwrite all current tracks, are you sure?'),...
                'QuestionDialog',...
                'Yes','No','No');

    switch answer
        %User doesn't confirm to make tracks
        case 'No'
            return
    end
end

%Determine the positions given by the user.
if size(handles.positions,1)==0
    errordlg('No positions given','Error')
    return
elseif size(handles.positions,2)==3
    num_positions_selected = g1data.num_position;
    positions_selected = (1:num_positions_selected)';
    
    positions = [];
    for i = 1:num_positions_selected
        if size(handles.preliminary_tracks.(strcat('num', num2str(positions_selected(i)))),1)>1
            positions = [positions; i];
        else
        end
    end
    
    num_positions = size(positions,1);
else
    num_positions_selected = size(handles.positions,1);
    positions_selected = handles.positions;
        
    positions = [];
    for i = 1:num_positions_selected
        if size(preliminary_tracks.(strcat('num', num2str(positions_selected(i)))),1)>1
            positions = [positions; positions_selected(i)];
        else
        end
    end
    
    num_positions = size(positions,1);
end

if num_positions<1
    errordlg('No positions with tracks are left', 'Error')
    return
end

if handles.analysis_channel ==0
    errordlg('Select channel for analysis')
    return
end

if handles.presence_filter ==1 && handles.presence_channel ==0
    errordlg('Select channel for presence filter')
    return
end

if handles.fov_filter ==1 && handles.fov_channel ==0
    errordlg('Select channel for fov filter')
    return
elseif handles.fov_filter ==1 && handles.fov_selection ==0
    errordlg('Select selection for fov filter')
    return
end

progressbar(0)
for i = 1:num_positions
    
    for j = 1:g1data.num_channels
        image.(strcat('channel', num2str(j))) = g1data.Image_combined.(strcat('channel',num2str(j))).(strcat('num',num2str(positions(i))));
    end
    
    selected_tracks.(strcat('num', num2str(positions(i)))) = make_tracks(preliminary_tracks.(strcat('num', num2str(positions(i)))), image,... 
    handles.start_analysis_filter, handles.start_analysis, handles.end_analysis_filter, handles.end_analysis, handles.overlap_analysis_filter,... 
    handles.tracklength_filter, handles.tracklength, handles.presence_filter, handles.presence_channel, handles.presence_threshold,...
    handles.presence_length, handles.fov_filter, handles.fov_channel, handles.fov_selection, handles.fov_threshold);
    
    progressbar(i/num_positions)
end
progressbar(1)

setappdata(hMainGui, 'selected_tracks', selected_tracks);

minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette'); 
channels = getappdata(hMainGui, 'channels_selection');

analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');

analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes on button press in delete_track_pushbutton.
function delete_track_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to delete_track_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = findobj('Tag','Gui1');
g1data = guidata(h);

hMainGui = getappdata(0, 'hMainGui');
selected_tracks = getappdata(hMainGui, 'selected_tracks');

if size(selected_tracks.(strcat('num', num2str(g1data.position))),1)==0
    errordlg('No tracks left at this position', 'Error')
    return
end

%Select correct axis. 
axes(g1data.axes8)

[x,y, mouse] = ginput(1);

if mouse~=1
    return
end

x = round(x);
y = round(y);
t = g1data.frame;


if size(selected_tracks.(strcat('num', num2str(g1data.position))),1)>0
    [~, tracknumber] = track_finder(selected_tracks.(strcat('num', num2str(g1data.position))), x, y, t);
    
    if size(tracknumber,1) ==1 && size(tracknumber,2) ==1
        number = 1;
        start = 1;

        tracks_new = [];
        for i = 1:max(selected_tracks.(strcat('num', num2str(g1data.position)))(:,1))
            if i == tracknumber
            else
                index_track = selected_tracks.(strcat('num', num2str(g1data.position)))(:,1)==i;
                add_track = selected_tracks.(strcat('num', num2str(g1data.position)))(index_track,2:4);
                
                tracknumber_new = repmat(number, size(add_track,1),1);
                add_track = [tracknumber_new, add_track];

                tracks_new(start:(start+size(add_track,1)-1),:) = add_track; 
                
                start = start+size(add_track,1); 
                number = number+1;
            end
        end
        selected_tracks.(strcat('num', num2str(g1data.position))) = tracks_new;
    else
    end
end

setappdata(hMainGui, 'selected_tracks', selected_tracks);

minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette'); 
channels = getappdata(hMainGui, 'channels_selection');

analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');

analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);




function tracknumber1_edit_Callback(hObject, eventdata, handles)
% hObject    handle to tracknumber1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tracknumber1 = str2double(get(hObject, 'String'));

if isnan(tracknumber1)
    errordlg('Fill in correct value','Error')
    set(handles.tracknumber1_edit, 'String', num2str(handles.tracknumber1));
    return
elseif tracknumber1 <=0 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.tracknumber1_edit, 'String', num2str(handles.tracknumber1));
    return
elseif tracknumber1 ~= round(tracknumber1) 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.tracknumber1_edit, 'String', num2str(handles.tracknumber1));
    return
end

handles.tracknumber1 = tracknumber1;

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function tracknumber1_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tracknumber1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in replace_pushbutton.
function replace_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to replace_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = findobj('Tag','Gui1');
g1data = guidata(h);

if handles.tracknumber1<=0
    errordlg('Insert correct track number to be replaced','Error')
    return
elseif isnan(handles.tracknumber1)
    errordlg('Insert correct track number to be replaced','Error')
    return
end

hMainGui = getappdata(0, 'hMainGui');
selected_tracks = getappdata(hMainGui, 'selected_tracks');

tracks = selected_tracks.(strcat('num', num2str(g1data.position)));

if isempty(tracks)
    errordlg('There are no tracks at this position','Error')
    return
end

if max(tracks(:,1)) < handles.tracknumber1
    errordlg('There are not that many tracks at this position','Error')
    return
end

index_track = intersect(find(tracks(:,1)==handles.tracknumber1),find(tracks(:,4)==g1data.frame));
if size(index_track,1)<1
    errordlg('Track not present in current frame')
    return
elseif size(index_track,1)>1
    errordlg('Unknown error')
    return
end

%Select correct axis. 
axes(g1data.axes8)

n = 0;
while n==0
    [x, y, mouse] = ginput(1);
    if x>0 && x <= size(g1data.Image_combined.channel1.num1,1) && y>0 && y <= size(g1data.Image_combined.channel1.num1,2)
        n=1;
    else
        waitfor(msgbox('Click somewhere in the image'))
    end
end

if mouse==1
    tracks(index_track,2:3) = [round(x),round(y)];
end

selected_tracks.(strcat('num', num2str(g1data.position))) = tracks;
setappdata(hMainGui, 'selected_tracks', selected_tracks);

minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette'); 
channels = getappdata(hMainGui, 'channels_selection');

analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');

analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);


% --- Executes on button press in extend_b_pushbutton.
function extend_b_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to extend_b_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = findobj('Tag','Gui1');
g1data = guidata(h);

if handles.tracknumber1<=0
    errordlg('Insert correct track number to be replaced','Error')
    return
elseif isnan(handles.tracknumber1)
    errordlg('Insert correct track number to be replaced','Error')
    return
end

hMainGui = getappdata(0, 'hMainGui');
selected_tracks = getappdata(hMainGui, 'selected_tracks');

tracks = selected_tracks.(strcat('num', num2str(g1data.position)));

if isempty(tracks)
    errordlg('There are no tracks at this position','Error')
    return
end

if max(tracks(:,1))<handles.tracknumber1
    errordlg('There are not that many tracks at this position','Error')
    return
end

minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette'); 
channels = getappdata(hMainGui, 'channels_selection');

analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');

analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Select correct axis. 
axes(g1data.axes8)

index_track = tracks(:,1) ==handles.tracknumber1;
track = tracks(index_track,:);

temp_track = [];

n=0;
time = track(1,4)-1;

while n==0 && time>0
    displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, time, g1data.position, g1data.zoomfactor,...
        g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
        preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

    m = 0;
    while m==0
        [x,y,mouse] = ginput(1);
        if x > 0 && x <= size(g1data.Image_combined.channel1.num1,1) && y > 0 && y <= size(g1data.Image_combined.channel1.num1,2)
            m=1;
        elseif mouse ~=1
            m=1;
        else
            waitfor(msgbox('Click somewhere in the image'))
        end
    end
    
    if mouse ==1 
        temp_track = [handles.tracknumber1, round(x), round(y), time; temp_track];
        time = time - 1;
    else
        n=1;
    end
end

if ~isempty(temp_track)
    track = [temp_track; track];
    
    tracks(tracks(:,1) == handles.tracknumber1,:) = [];
    if handles.tracknumber1 ==1
        tracks = [track; tracks];
    elseif handles.tracknumber1 ==max(tracks(:,1))
        tracks = [tracks; track];
    else
        tracks = [tracks(tracks(:,1) < handles.tracknumber1,:); track;  tracks(tracks(:,1) > handles.tracknumber1,:)];
    end
end

selected_tracks.(strcat('num', num2str(g1data.position))) = tracks;
setappdata(hMainGui, 'selected_tracks', selected_tracks);


%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes on button press in extend_f_pushbutton.
function extend_f_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to extend_f_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = findobj('Tag','Gui1');
g1data = guidata(h);

if handles.tracknumber1<=0
    errordlg('Insert correct track number to be replaced','Error')
    return
elseif isnan(handles.tracknumber1)
    errordlg('Insert correct track number to be replaced','Error')
    return
end

hMainGui = getappdata(0, 'hMainGui');
selected_tracks = getappdata(hMainGui, 'selected_tracks');

tracks = selected_tracks.(strcat('num', num2str(g1data.position)));

if isempty(tracks)
    errordlg('There are no tracks at this position','Error')
    return
end

if max(tracks(:,1))<handles.tracknumber1
    errordlg('There are not that many tracks at this position','Error')
    return
end

minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette'); 
channels = getappdata(hMainGui, 'channels_selection');

analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Select correct axis. 
axes(g1data.axes8)

index_track = tracks(:,1) ==handles.tracknumber1;
track = tracks(index_track,:);

temp_track = [];

n=0;
time = track(end,4)+1;

while n==0 && time <= g1data.total_frames
    displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, time, g1data.position, g1data.zoomfactor,...
        g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
        preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);
 
    m = 0;
    while m==0
        [x,y,mouse] = ginput(1);
        if x > 0 && x <= size(g1data.Image_combined.channel1.num1,1) && y > 0 && y <= size(g1data.Image_combined.channel1.num1,2)
            m=1;
        elseif mouse ~=1
            m=1;
        else
            waitfor(msgbox('Click somewhere in the image'))
        end
    end
    
    if mouse ==1 
        temp_track = [temp_track; handles.tracknumber1, round(x), round(y), time];
        time = time + 1;
    else
        n=1;
    end
end

if ~isempty(temp_track)
    track = [track; temp_track];
    
    tracks(tracks(:,1) == handles.tracknumber1,:) = [];
    if handles.tracknumber1 ==1
        tracks = [track; tracks];
    elseif handles.tracknumber1 ==max(tracks(:,1))
        tracks = [tracks; track];
    else
        tracks = [tracks(tracks(:,1) < handles.tracknumber1,:); track;  tracks(tracks(:,1) > handles.tracknumber1,:)];
    end
end

selected_tracks.(strcat('num', num2str(g1data.position))) = tracks;
setappdata(hMainGui, 'selected_tracks', selected_tracks);

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);


function tracknumber2_edit_Callback(hObject, eventdata, handles)
% hObject    handle to tracknumber2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tracknumber2 = str2double(get(hObject, 'String'));

if isnan(tracknumber2)
    errordlg('Fill in correct value','Error')
    set(handles.tracknumber2_edit, 'String', num2str(handles.tracknumber2));
    return
elseif tracknumber2 <=0 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.tracknumber2_edit, 'String', num2str(handles.tracknumber2));
    return
elseif tracknumber2 ~= round(tracknumber2) 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.tracknumber2_edit, 'String', num2str(handles.tracknumber2));
    return
end

handles.tracknumber2 = tracknumber2;

guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of tracknumber2_edit as text
%        str2double(get(hObject,'String')) returns contents of tracknumber2_edit as a double


% --- Executes during object creation, after setting all properties.
function tracknumber2_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tracknumber2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function lower_clip_edit_Callback(hObject, eventdata, handles)
% hObject    handle to lower_clip_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(get(hObject, 'String'))
    handles.lower_clip = [];
else
    lower_clip = str2double(get(hObject, 'String'));

    if isnan(lower_clip)
        errordlg('Fill in correct value','Error')
        set(handles.lower_clip_edit, 'String', num2str(handles.lower_clip));
        return
    elseif lower_clip <=0 
        errordlg('Value must be an integer larger than 0','Error')
        set(handles.lower_clip_edit, 'String', num2str(handles.lower_clip));
        return
    elseif lower_clip ~= round(lower_clip) 
        errordlg('Value must be an integer larger than 0','Error')
        set(handles.lower_clip_edit, 'String', num2str(handles.lower_clip));
        return
    end

    handles.lower_clip = lower_clip;
end

guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of lower_clip_edit as text
%        str2double(get(hObject,'String')) returns contents of lower_clip_edit as a double


% --- Executes during object creation, after setting all properties.
function lower_clip_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lower_clip_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function upper_clip_edit_Callback(hObject, eventdata, handles)
% hObject    handle to upper_clip_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(get(hObject, 'String'))
    handles.upper_clip = [];
else
    upper_clip = str2double(get(hObject, 'String'));

    if isnan(upper_clip)
        errordlg('Fill in correct value','Error')
        set(handles.upper_clip_edit, 'String', num2str(handles.upper_clip));
        return
    elseif upper_clip <=0 
        errordlg('Value must be an integer larger than 0','Error')
        set(handles.upper_clip_edit, 'String', num2str(handles.upper_clip));
        return
    elseif upper_clip ~= round(upper_clip) 
        errordlg('Value must be an integer larger than 0','Error')
        set(handles.upper_clip_edit, 'String', num2str(handles.upper_clip));
        return
    end

    handles.upper_clip = upper_clip;
end

guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of upper_clip_edit as text
%        str2double(get(hObject,'String')) returns contents of upper_clip_edit as a double


% --- Executes during object creation, after setting all properties.
function upper_clip_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upper_clip_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in clip_pushbutton.
function clip_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to clip_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = findobj('Tag','Gui1');
g1data = guidata(h);

if handles.tracknumber2 <= 0
    errordlg('Insert correct track number to be replaced','Error')
    return
elseif isnan(handles.tracknumber2)
    errordlg('Insert correct track number to be replaced','Error')
    return
end

hMainGui = getappdata(0, 'hMainGui');
selected_tracks = getappdata(hMainGui, 'selected_tracks');

tracks = selected_tracks.(strcat('num', num2str(g1data.position)));

if isempty(tracks)
    errordlg('There are no tracks at this position','Error')
    return
end

if max(tracks(:,1))<handles.tracknumber2
    errordlg('There are not that many tracks at this position','Error')
    return
end


index_track = tracks(:,1) ==handles.tracknumber2;
track = tracks(index_track,:);

if isnan(handles.lower_clip)
    errordlg('Select correct lower bound','Error')
    return
elseif handles.lower_clip< track(1,4)
    errordlg('Select lower bound that is higher than first frame','Error')
    return
end

if isnan(handles.upper_clip)
    errordlg('Select correct upper bound','Error')
    return
elseif handles.upper_clip > track(end,4)
    errordlg('Select upper bound that is lower than last frame','Error')
    return
end

if handles.upper_clip <= handles.lower_clip
    errordlg('Upper bound must be higher than lower bound','Error')
    return
end

if ~isempty(handles.lower_clip) && ~isempty(handles.upper_clip)
    index_lower = find(track(:,4)== handles.lower_clip);
    index_higher = find(track(:,4)==handles.upper_clip);
    
    temp_track = track(index_lower:index_higher,:);
elseif ~isempty(handles.lower_clip)
    index_lower = find(track(:,4)== handles.lower_clip);
    
    temp_track = track(index_lower:end,:);
elseif ~isempty(handles.upper_clip)
    index_higher = find(track(:,4)==handles.upper_clip);
    
    temp_track = track(1:index_higher,:);
else
    return
end


if ~isempty(temp_track)
    tracks(tracks(:,1) == handles.tracknumber2,:) = [];
    if handles.tracknumber2 ==1
        tracks = [temp_track; tracks];
    elseif handles.tracknumber2 ==max(tracks(:,1))
        tracks = [tracks; temp_track];
    else
        tracks = [tracks(tracks(:,1) < handles.tracknumber2,:); temp_track;  tracks(tracks(:,1) > handles.tracknumber2,:)];
    end
end

selected_tracks.(strcat('num', num2str(g1data.position))) = tracks;
setappdata(hMainGui, 'selected_tracks', selected_tracks);

minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette'); 
channels = getappdata(hMainGui, 'channels_selection');

analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');

analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);



function tracknumber3_edit_Callback(hObject, eventdata, handles)
% hObject    handle to tracknumber3_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tracknumber3 = str2double(get(hObject, 'String'));

if isnan(tracknumber3)
    errordlg('Fill in correct value','Error')
    set(handles.tracknumber3_edit, 'String', num2str(handles.tracknumber3));
    return
elseif tracknumber3 <=0 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.tracknumber3_edit, 'String', num2str(handles.tracknumber3));
    return
elseif tracknumber3 ~= round(tracknumber3) 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.tracknumber3_edit, 'String', num2str(handles.tracknumber3));
    return
end

handles.tracknumber3 = tracknumber3;

guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of tracknumber3_edit as text
%        str2double(get(hObject,'String')) returns contents of tracknumber3_edit as a double


% --- Executes during object creation, after setting all properties.
function tracknumber3_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tracknumber3_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tracknumber4_edit_Callback(hObject, eventdata, handles)
% hObject    handle to tracknumber4_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tracknumber4 = str2double(get(hObject, 'String'));

if isnan(tracknumber4)
    errordlg('Fill in correct value','Error')
    set(handles.tracknumber4_edit, 'String', num2str(handles.tracknumber4));
    return
elseif tracknumber4 <=0 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.tracknumber4_edit, 'String', num2str(handles.tracknumber4));
    return
elseif tracknumber4 ~= round(tracknumber4) 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.tracknumber4_edit, 'String', num2str(handles.tracknumber4));
    return
end

handles.tracknumber4 = tracknumber4;

guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of tracknumber4_edit as text
%        str2double(get(hObject,'String')) returns contents of tracknumber4_edit as a double


% --- Executes during object creation, after setting all properties.
function tracknumber4_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tracknumber4_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function limit_track1_edit_Callback(hObject, eventdata, handles)
% hObject    handle to limit_track1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.merge_limit1 = str2double(get(hObject, 'String'));

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function limit_track1_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to limit_track1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function limit_track2_edit_Callback(hObject, eventdata, handles)
% hObject    handle to limit_track2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.merge_limit2 = str2double(get(hObject, 'String'));

guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of limit_track2_edit as text
%        str2double(get(hObject,'String')) returns contents of limit_track2_edit as a double


% --- Executes during object creation, after setting all properties.
function limit_track2_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to limit_track2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in merge_pushbutton.
function merge_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to merge_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = findobj('Tag','Gui1');
g1data = guidata(h);

if handles.tracknumber3 <= 0
    errordlg('Insert correct track number to be replaced','Error')
    return
elseif isnan(handles.tracknumber3)
    errordlg('Insert correct track number to be replaced','Error')
    return
elseif handles.tracknumber4 <= 0
    errordlg('Insert correct track number to be replaced','Error')
    return
elseif isnan(handles.tracknumber4)
    errordlg('Insert correct track number to be replaced','Error')
    return
elseif handles.tracknumber3 == handles.tracknumber4
    errordlg('Choose two different tracks','Error')
    return
end

hMainGui = getappdata(0, 'hMainGui');
selected_tracks = getappdata(hMainGui, 'selected_tracks');

tracks = selected_tracks.(strcat('num', num2str(g1data.position)));

if isempty(tracks)
    errordlg('There are no tracks at this position','Error')
    return
end

if max(tracks(:,1))<handles.tracknumber3
    errordlg('There are not that many tracks at this position','Error')
    return
elseif max(tracks(:,1))<handles.tracknumber4
    errordlg('There are not that many tracks at this position','Error')
    return    
end

minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette'); 
channels = getappdata(hMainGui, 'channels_selection');

analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

track1 = tracks(tracks(:,1)==handles.tracknumber3, 2:4);
track2 = tracks(tracks(:,1)==handles.tracknumber4, 2:4);

%Select correct axis. 
axes(g1data.axes8)

if ~isnan(handles.merge_limit1) && ~isnan(handles.merge_limit2)
    if isempty(intersect(track1(:,3),handles.merge_limit1))
        errordlg('Limit 1 is not in track 1','Error')
        return
    elseif isempty(intersect(track2(:,3),handles.merge_limit2))
        errordlg('Limit 2 is not in track 2','Error')
        return
    elseif handles.merge_limit1>=handles.merge_limit2
        errordlg('Limit 2 should be larger than limit 1','Error')
        return
    end
     
    index_track1 = track1(:,3) <= handles.merge_limit1;
    index_track2 = track2(:,3) >= handles.merge_limit2;
        
    if handles.merge_limit2 - handles.merge_limit1 ==1
        merged_track = [track1(index_track1,:); track2(index_track2,:)];
    else
        index_fill = (handles.merge_limit1+1):(handles.merge_limit2-1);
        fill_track = nan(size(index_fill,2),3);
        for i = 1:size(index_fill,2)
            displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, index_fill(i), g1data.position, g1data.zoomfactor,...
                g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
                preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

            n=0;
            while n==0
                [x,y] = ginput(1);
                
                if x>0 && x<=size(g1data.Image_combined.channel1.num1,1) && y>0 && y<=size(g1data.Image_combined.channel1.num1,2)
                    n=1;
                else
                    waitfor(msgbox('Click somewhere in the image'))
                end
            end
            fill_track(i,:) = [round(x),round(y),index_fill(i)];    
        end
        merged_track = [track1(index_track1,:); fill_track; track2(index_track2,:)];
    end
else
    if track1(1,3)>=track2(1,3)
        errordlg('Track 1 should start before track 2','Error')
        return
    end
    
    if track2(end,3)<=track1(end,3)
        errordlg('Track 2 should end after track 1','Error')
        return        
    end
        
    if max(track1(:,3))>=min(track2(:,3))
        index_fill = intersect(track1(:,3),track2(:,3));
        fill_track = nan(size(index_fill,1),3);
        for i = 1:size(index_fill,1)

            displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, index_fill(i), g1data.position, g1data.zoomfactor,...
                g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
                preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

            n = 0;
            while n==0
                [x,y] = ginput(1);
                if x>0 && x<=size(g1data.Image_combined.channel1.num1,1) && y>0 && y<=size(g1data.Image_combined.channel1.num1,2)
                    n=1;
                else
                    waitfor(msgbox('Click somewhere in the image'))
                end
            end
            fill_track(i,:) = [round(x),round(y),index_fill(i)];
        end
        merged_track = [track1(1:find(track1(:,3)==index_fill(1))-1,:); fill_track; track2(find(track2(:,3)==index_fill(end))+1:end,:)];

    elseif (max(track1(:,3))+1)<min(track2(:,3))
        index_fill = (max(track1(:,3))+1):(min(track2(:,3))-1);
        fill_track = nan(size(index_fill,2),3);
        for i = 1:size(index_fill,2)

            displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, index_fill(i), g1data.position, g1data.zoomfactor,...
                g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
                preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

            n = 0;
            while n==0
                [x,y] = ginput(1);
                if x>0 && x<=size(g1data.Image_combined.channel1.num1,1) && y>0 && y<=size(g1data.Image_combined.channel1.num1,2)
                    n=1;
                else
                    waitfor(msgbox('Click somewhere in the image'))
                end
            end
            fill_track(i,:) = [round(x),round(y),index_fill(i)];
        end
        merged_track = [track1; fill_track; track2];    
    else
        merged_track = [track1; track2];
    end
end

tracknumber_low = min(handles.tracknumber3, handles.tracknumber4);
tracknumber_high = max(handles.tracknumber3, handles.tracknumber4);

temp_tracks = [];
for i = 1:max(tracks(:,1))
    if i < tracknumber_low && i < tracknumber_high
        index_track = tracks(:,1)==i;
        temp_tracks = [temp_tracks; tracks(index_track,:)];
    elseif i == tracknumber_low && i < tracknumber_high
        num = repmat(tracknumber_low,size(merged_track,1),1);
        temp_tracks = [temp_tracks; num, merged_track];
    elseif i > tracknumber_low && i < tracknumber_high
        index_track = tracks(:,1)==i;
        temp_tracks = [temp_tracks; tracks(index_track,:)];
    elseif i > tracknumber_low && i == tracknumber_high
    elseif i > tracknumber_low && i > tracknumber_high
        index_track = tracks(:,1)==i;
        
        num = repmat(i-1,sum(index_track),1);
        temp_tracks = [temp_tracks; num, tracks(index_track,2:4)];
    end
end

selected_tracks.(strcat('num', num2str(g1data.position))) = temp_tracks;
setappdata(hMainGui, 'selected_tracks', selected_tracks);

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = findobj('Tag','Gui1');
g1data = guidata(h);

hMainGui = getappdata(0, 'hMainGui');

if g1data.active_transtrack ==1
    %Ask if user is sure to quit the GUI. 
    answer = questdlg('Are you sure you want to close the analysis? All tracks will be removed', ...
        'Quit', ...
        'Yes','No','No');

    % Handle response. Only continuing with closing in case user confirmed. 
    switch answer
        case 'Yes'
        case 'No'
            return
        case '' 
            return
    end

    %Set the standard visualization options for analysis. 
    analysis_visuals = zeros(7,1);
    setappdata(hMainGui, 'analysis_visuals', analysis_visuals);

    %Note if analysis is active. 
    setappdata(hMainGui, 'active_analysis', 0);

    %Set the standard settings for analysis. 
    metadata_current = getappdata(hMainGui,'analysis_metadata');

    analysis_metadata = {'bleach correction', metadata_current{1,2}; 'number of positions', metadata_current{2,2};
        'number of frames', metadata_current{3,2}; 'number of channels', metadata_current{4,2}; 'dimensions', metadata_current{5,2}; 
        'analysis type', 0; 'analysis channel', 0; 'noise size', 1; 'object size', 8; 'noise level', 1000; 'threshold', 1000; 
        'tracking distance', 10; 'frame skipping', 1; 'overlap filter', 0; 'start filter', 0; 'start value', 1; 'end filter', 0; 'end value', 2;
        'minimum tracklength filter', 0; 'minimum tracklength value', 1; 'colocalization filter', 0; 'colocalization channel (analysis)', 0;
        'colocalization threshold (analysis)', 1000; 'colocalization length (analysis)', 1; 'subROI filter', 0; 'subROI channel (analysis)', 0; 
        'subROI selection', 0; 'subROI threshold (analysis)', 1000; 'intensity box size', 8; 'subROI channel (save)', 0; 
        'subROI threshold (save)', 1000; 'colocalization channel (save)', 0; 'colocalization threshold (save)', 1000; 'colocalization length (save)', 1};

    setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

    %Close save GUI if open. 
    if ~isempty(findobj('Name','Save'))
        close('Save')
    end

    %(Re)set the tracking handles.
    for i = 1:g1data.num_position
        roi_boundaries.(strcat('num', num2str(i))) = {};
        peaks.(strcat('num', num2str(i))) = [];
        preliminary_tracks.(strcat('num', num2str(i))) = [];
        selected_tracks.(strcat('num', num2str(i))) = [];
        segmented_image.(strcat('num', num2str(i))) = [];
        colocalization.(strcat('num', num2str(i))) = [];
    end

    setappdata(hMainGui, 'roi_boundaries', roi_boundaries);
    setappdata(hMainGui, 'peaks', peaks);
    setappdata(hMainGui, 'preliminary_tracks', preliminary_tracks);
    setappdata(hMainGui, 'selected_tracks', selected_tracks);
    setappdata(hMainGui, 'segmented_image', segmented_image);
    setappdata(hMainGui, 'colocalization', colocalization);

    minimum_display = getappdata(hMainGui, 'minimum_display');
    maximum_display = getappdata(hMainGui, 'maximum_display');
    colour = getappdata(hMainGui, 'colour_palette'); 
    channels = getappdata(hMainGui, 'channels_selection');

    %Display image. 
    displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
        g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
        preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);
else
end

% Close the figure
delete(hObject);
