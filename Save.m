function varargout = Save(varargin)
% SAVE MATLAB code for Save.fig
%      SAVE, by itself, creates a new SAVE or raises the existing
%      singleton*.
%
%      H = SAVE returns the handle to a new SAVE or the handle to
%      the existing singleton*.
%
%      SAVE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAVE.M with the given input arguments.
%
%      SAVE('Property','Value',...) creates a new SAVE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Save_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Save_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Last Modified by GUIDE v2.5 26-May-2019 18:03:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Save_OpeningFcn, ...
                   'gui_OutputFcn',  @Save_OutputFcn, ...
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


% --- Executes just before Save is made visible.
function Save_OpeningFcn(hObject, eventdata, handles, varargin)

%Get app data. 
hMainGui = getappdata(0, 'hMainGui');

%Get handles of main GUI. 
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Make options for channel popupmenu's. Depends on number of channels
%present in movie. 
channel_options = cell(1+g1data.num_channels,1);
channel_options{1} = 'Choose Channel';

for i = 1:g1data.num_channels
    channel_options{i+1} = ['Channel', ' ', num2str(i)];
end
set(handles.subroi_channel_popupmenu, 'String', channel_options);
set(handles.colocalization_channel_popupmenu, 'String', channel_options);

%Set all analysis visuals correctly. 
analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
set(handles.subroi_view_checkbox, 'Value', analysis_visuals(6));
set(handles.colocalization_view_checkbox, 'Value', analysis_visuals(7));

%Set all analysis settings correctly. 
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

handles.boxsize = analysis_metadata{29,2}; set(handles.box_size_edit, 'String', handles.boxsize);
handles.subroi_channel = analysis_metadata{30,2}; set(handles.subroi_channel_popupmenu, 'Value', handles.subroi_channel+1);
handles.subroi_threshold = analysis_metadata{31,2}; set(handles.subroi_threshold_edit, 'String', handles.subroi_threshold);
handles.colocalization_channel = analysis_metadata{32,2}; set(handles.colocalization_channel_popupmenu, 'Value', handles.colocalization_channel+1);
handles.colocalization_threshold = analysis_metadata{33,2}; set(handles.colocalization_threshold_edit, 'String', handles.colocalization_threshold);
handles.colocalization_length = analysis_metadata{34,2}; set(handles.colocalization_length_edit, 'String', handles.colocalization_length);

%Set standard save settings. 
handles.fov_save = 0; set(handles.fov_save_checkbox, 'Value', handles.fov_save);
handles.roi_save = 0; set(handles.roi_save_checkbox, 'Value', handles.roi_save);
handles.subroi_save = 0; set(handles.subroi_save_checkbox, 'Value', handles.subroi_save);
handles.intensities_save = 0; set(handles.intensities_save_checkbox, 'Value', handles.intensities_save);
handles.total_spots_save = 0; set(handles.total_spots_save_checkbox, 'Value', handles.total_spots_save);
handles.appearances_save = 0; set(handles.appearances_save_checkbox, 'Value', handles.appearances_save);
handles.colocalization_save = 0; set(handles.colocalization_save_checkbox, 'Value', handles.colocalization_save);

% Choose default command line output for Save
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = Save_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Section 1 - Save settings: simple%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in fov_save_checkbox.
function fov_save_checkbox_Callback(hObject, eventdata, handles)

%Get user input: save FOV data or not. 
handles.fov_save = get(hObject, 'Value');

guidata(hObject, handles);


% --- Executes on button press in roi_save_checkbox.
function roi_save_checkbox_Callback(hObject, eventdata, handles)

%Get user input: save ROI data or not. 
handles.roi_save = get(hObject, 'Value');

guidata(hObject, handles);


% --- Executes on button press in subroi_save_checkbox.
function subroi_save_checkbox_Callback(hObject, eventdata, handles)

%Get user input: save subROI data or not. 
handles.subroi_save = get(hObject, 'Value');

guidata(hObject, handles);




% --- Executes on box size edit change.
function box_size_edit_Callback(hObject, eventdata, handles)

%Get user input for box size. 
boxsize = str2double(get(hObject,'String'));

%In case entered value is not a valid number return. 
if isnan(boxsize)
    errordlg('Fill in correct value','Error')
    set(handles.box_size_edit, 'String', num2str(handles.boxsize));
    return
elseif boxsize <=0 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.box_size_edit, 'String', num2str(handles.boxsize));
    return
elseif boxsize ~= round(boxsize) 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.box_size_edit, 'String', num2str(handles.boxsize));
    return
end

%Update boxsize value. 
handles.boxsize = boxsize;

%Update boxsize value in metadata file. 
hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{29,2} = boxsize;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function box_size_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Section 2 - Save settings: subROIs%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on selection change in subroi_channel_popupmenu.
function subroi_channel_popupmenu_Callback(hObject, eventdata, handles)

%Get selection from user and update accordingly. 
handles.subroi_channel = get(hObject,'Value') - 1;

%Update in metadata file. 
hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{30,2} = handles.subroi_channel;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

%Get handles from main GUI. 
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Retrieve current segmented image. 
segmented_image = getappdata(hMainGui, 'segmented_image');

%In case a channel is selected, segment image of that channel. 
if handles.subroi_channel >0
    %Do segmentation at each position.  
    for i = 1:g1data.num_position
        %Get image at position of given channel.
        image = g1data.Image_combined.(strcat('channel',num2str(handles.subroi_channel))).(strcat('num',num2str(i)));
        
        %Mask for smoothing after initial segmentation. 
        se = strel('disk',4,4);
        
        %Pre-allocate matrices. 
        image_temp = nan(size(image,1), size(image,2), 1);
        image_binary = nan(size(image,1), size(image,2), size(image,3));
        for j = 1:size(image,3)
            %Segment image using the given threshold.
            image_temp(image(:,:,j) > handles.subroi_threshold) = 65536;
            image_temp(image(:,:,j) <= handles.subroi_threshold) = 0;
            
            %Smoothing with erosion and dilation step with given mask. 
            image_binary(:,:,j) = imerode(image_temp, se);
            image_binary(:,:,j) = imdilate(image_temp, se);            
        end
        
        %Get segmented image at this position.
        segmented_image.(strcat('num', num2str(i))) = image_binary;
    end
%In case no channel is selected, there is no segmented image.     
else
    for i = 1:g1data.num_position
        segmented_image.(strcat('num', num2str(i))) = [];
    end
end

%Save new segmented image in app data. 
setappdata(hMainGui, 'segmented_image', segmented_image);

%Retrieve display settings. 
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette'); 
channels = getappdata(hMainGui, 'channels_selection');
analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
colocalization = getappdata(hMainGui, 'colocalization');

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function subroi_channel_popupmenu_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes when subroi edit is changed. 
function subroi_threshold_edit_Callback(hObject, eventdata, handles)

%Get input from user. 
subroi_threshold = str2double(get(hObject,'String'));

%Return in case invalid number for subroi threshold is given by user. 
if isnan(subroi_threshold)
    errordlg('Fill in correct value','Error')
    set(handles.subroi_threshold_edit, 'String', num2str(handles.subroi_threshold));
    return
elseif subroi_threshold <=0 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.subroi_threshold_edit, 'String', num2str(handles.subroi_threshold));
    return
elseif subroi_threshold ~= round(subroi_threshold) 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.subroi_threshold_edit, 'String', num2str(handles.subroi_threshold));
    return
end

%Update subroi threshold value accordingly. 
handles.subroi_threshold = subroi_threshold;

%Update metadata file accordingly. 
hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{31,2} = subroi_threshold;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

%Get handles of main GUI. 
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Get current segmented image. 
segmented_image = getappdata(hMainGui, 'segmented_image');

%In case a channel is selected for segmentation, perform it. 
if handles.subroi_channel >0
    
    %Do segmentation at each position for given channel.     
    for i = 1:g1data.num_position
        %Get image at this position for the given channel. 
        image = g1data.Image_combined.(strcat('channel',num2str(handles.subroi_channel))).(strcat('num',num2str(i)));
        
        %Mask for smoothing after initial segmentation. 
        se = strel('disk',4,4);
        
        %Pre-allocate matrices. 
        image_temp = nan(size(image,1), size(image,2), 1);
        image_binary = nan(size(image,1), size(image,2), size(image,3));
        for j = 1:size(image,3)
            %Segment image using the given threshold.
            image_temp(image(:,:,j) > handles.subroi_threshold) = 65536;
            image_temp(image(:,:,j) <= handles.subroi_threshold) = 0;
            
            %Smoothing with erosion and dilation step with given mask. 
            image_binary(:,:,j) = imerode(image_temp, se);
            image_binary(:,:,j) = imdilate(image_temp, se);            
        end
        
        %Get segmented image at this position.
        segmented_image.(strcat('num', num2str(i))) = image_binary;
    end    
    
    %Save new segmented image in app data. 
    setappdata(hMainGui, 'segmented_image', segmented_image);
end

%Retrieve display settings. 
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette'); 
channels = getappdata(hMainGui, 'channels_selection');
analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
colocalization = getappdata(hMainGui, 'colocalization');

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function subroi_threshold_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in subroi_view_checkbox.
function subroi_view_checkbox_Callback(hObject, eventdata, handles)

%Get user input for viewing subrois or not. 
view_subroi = get(hObject,'Value');

%Get current analysis visuals. 
hMainGui = getappdata(0, 'hMainGui');
analysis_visuals = getappdata(hMainGui, 'analysis_visuals');

%Update analysis visuals in app data. 
analysis_visuals(6) = view_subroi;
setappdata(hMainGui, 'analysis_visuals', analysis_visuals);

%Get handles of main GUI. 
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Retrieve display settings.
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette'); 
channels = getappdata(hMainGui, 'channels_selection');
analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Section 3 - Save settings: colocalization%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on selection change in colocalization_channel_popupmenu.
function colocalization_channel_popupmenu_Callback(hObject, eventdata, handles)

%Get channel selection by user. 
handles.colocalization_channel = get(hObject,'Value') - 1;

%Update channel selection in metadata file. 
hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{32,2} = handles.colocalization_channel;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

%Get handles of main GUI. 
h = findobj('Tag','Gui1');
g1data = guidata(h);

%In case channel is selected, determine the colocalization. 
if handles.colocalization_channel >0
    %Get all selected tracks. 
    selected_tracks = getappdata(hMainGui, 'selected_tracks'); 
    
    %Find positions at which there are selected tracks. 
    positions = find(~structfun(@isempty,selected_tracks)); 
    
    %If there are no positions; return. 
    if isempty(positions)
        return
    else
        %Get number of positions at which there are tracks. 
        num_positions = size(positions,1);
    end
    
    %Get current colocalization data. 
    colocalization = getappdata(hMainGui, 'colocalization');
    
    %For each position with tracks, determine for each track if there is
    %colocalization. 
    for i = 1:num_positions
        %Get tracks and image at current position. 
        tracks = selected_tracks.(strcat('num',num2str(positions(i))));
        image = g1data.Image_combined.(strcat('channel',num2str(handles.colocalization_channel))).(strcat('num',num2str(positions(i))));
        
        %Pre-allocate vector. 
        colocalization_temp = nan(max(tracks(:,1)), 1);
        
        %Determine for each track if there is colocalization. 
        for j = 1:max(tracks(:,1))
            %Get the coordinates of current track. 
            index_track = tracks(:,1)==j;
            track = tracks(index_track, 2:4);
            
            %Pre-allocate vector. 
            presence_temp = zeros(size(track,1),1);
            
            %Determine for each frame if there is colocalization. 
            for k = 1:size(track,1)
                %Get x,y coordinates in current frame. 
                x_low = track(k,2)- 10;
                x_high = track(k,2)+ 10;
                y_low = track(k,1)- 10;
                y_high = track(k,1)+ 10;
                
                %Construct ROI centered around spot. 
                ROI = image(x_low:x_high, y_low:y_high, track(k,3));

                %Search for local maxima with given threshold in the given
                %channel in the ROI. 
                pk = pkfnd(ROI, handles.colocalization_threshold, 5);

                %If a peak is found in the ROI, calculate distance to 
                %center and only take if this is smaller than 3. 
                if size(pk,1) >= 1
                    %Calculate distance to center.
                    distance = sqrt((11 -pk(:,1)).^2 + (11 -pk(:,2)).^2);
                    if any(distance<3)
                        presence_temp(k) = 1;
                    end
                end
            end
            
            %Get the maximum number of consecutive frames with a spot in
            %the given channel. In case this is larger than the threshold
            %length, call colocalization. 
            presence_length_track = max(accumarray(nonzeros((cumsum(~presence_temp)+1).*presence_temp),1));
            if presence_length_track >= handles.colocalization_length
                colocalization_temp(j) = 1;
            else
                colocalization_temp(j) = 0;
            end
        end
        
        %Get colocalization vector for given position.         
        colocalization.(strcat('num', num2str(positions(i)))) = colocalization_temp;
    end
    
    %Save colocalization data in app data. 
    setappdata(hMainGui, 'colocalization', colocalization);
%In case no channel is selected, remove all colocalization data. 
else
    for i = 1:g1data.num_position
        colocalization.(strcat('num', num2str(i))) = [];
    end
    
    setappdata(hMainGui, 'colocalization', colocalization);
end

%Retrieve display settings. 
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

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function colocalization_channel_popupmenu_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes when colocalization threshold edit is changed.
function colocalization_threshold_edit_Callback(hObject, eventdata, handles)

%Get user input for edit. 
colocalization_threshold = str2double(get(hObject,'String'));

%Return in case value given by user is invalid. 
if isnan(colocalization_threshold)
    errordlg('Fill in correct value','Error')
    set(handles.colocalization_threshold_edit, 'String', num2str(handles.colocalization_threshold));
    return
elseif colocalization_threshold <=0 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.colocalization_threshold_edit, 'String', num2str(handles.colocalization_threshold));
    return
elseif colocalization_threshold ~= round(colocalization_threshold) 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.colocalization_threshold_edit, 'String', num2str(handles.colocalization_threshold));
    return
end

%Update threshold value. 
handles.colocalization_threshold = colocalization_threshold;

%Update threshold value in metadata. 
hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{33,2} = colocalization_threshold;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

%Get handles of main GUI. 
h = findobj('Tag','Gui1');
g1data = guidata(h);

%In case colocalization channel is selected, determine colocalization. 
if handles.colocalization_channel >0
    %Get all selected tracks.
    selected_tracks = getappdata(hMainGui, 'selected_tracks'); 
    
    %Find positions at which there are selected tracks. 
    positions = find(~structfun(@isempty,selected_tracks)); 
    
    %If there are no positions; return. 
    if isempty(positions)
        return
    else
        %Get number of positions at which there are tracks.
        num_positions = size(positions,1);
    end
    
    %Get current colocalization data.
    colocalization = getappdata(hMainGui, 'colocalization');
    
    %For each position with tracks, determine for each track if there is
    %colocalization. 
    for i = 1:num_positions
        %Get tracks and image at current position.
        tracks = selected_tracks.(strcat('num',num2str(positions(i))));
        image = g1data.Image_combined.(strcat('channel',num2str(handles.colocalization_channel))).(strcat('num',num2str(positions(i))));
              
        %Pre-allocate vector. 
        colocalization_temp = nan(max(tracks(:,1)), 1);
        
        %Determine for each track if there is colocalization.
        for j = 1:max(tracks(:,1))
            %Get the coordinates of current track. 
            index_track = tracks(:,1)==j;
            track = tracks(index_track, 2:4);

            %Pre-allocate vector. 
            presence_temp = zeros(size(track,1),1);
            
            %Determine for each frame if there is colocalization. 
            for k = 1:size(track,1)
                %Get x,y coordinates in current frame. 
                x_low = track(k,2)- 10;
                x_high = track(k,2)+ 10;
                y_low = track(k,1)- 10;
                y_high = track(k,1)+ 10;

                %Construct ROI centered around spot.
                ROI = image(x_low:x_high, y_low:y_high, track(k,3));

                %Search for local maxima with given threshold in the given
                %channel in the ROI. 
                pk = pkfnd(ROI, handles.colocalization_threshold, 5);

                %If a peak is found in the ROI, calculate distance to 
                %center and only take if this is smaller than 3. 
                if size(pk,1) >= 1
                    %Calculate distance to center.
                    distance = sqrt((11 -pk(:,1)).^2 + (11 -pk(:,2)).^2);
                    if any(distance<3)
                        presence_temp(k) = 1;
                    end
                end
            end
            
            %Get the maximum number of consecutive frames with a spot in
            %the given channel. In case this is larger than the threshold
            %length, call colocalization. 
            presence_length_track = max(accumarray(nonzeros((cumsum(~presence_temp)+1).*presence_temp),1));
            if presence_length_track >= handles.colocalization_length
                colocalization_temp(j) = 1;
            else
                colocalization_temp(j) = 0;
            end
        end
        
        %Save colocalization data in app data. 
        colocalization.(strcat('num', num2str(positions(i)))) = colocalization_temp;
    end
    
    setappdata(hMainGui, 'colocalization', colocalization);
end

%Retrieve display settings. 
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette'); 
channels = getappdata(hMainGui, 'channels_selection');
analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function colocalization_threshold_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes when colocalization length threshold edit is changed.
function colocalization_length_edit_Callback(hObject, eventdata, handles)

%Get user input for edit. 
colocalization_length = str2double(get(hObject,'String'));

%Return in case value given by user is invalid. 
if isnan(colocalization_length)
    errordlg('Fill in correct value','Error')
    set(handles.colocalization_length_edit, 'String', num2str(handles.colocalization_length));
    return
elseif colocalization_length <=0 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.colocalization_length_edit, 'String', num2str(handles.colocalization_length));
    return
elseif colocalization_length ~= round(colocalization_length) 
    errordlg('Value must be an integer larger than 0','Error')
    set(handles.colocalization_length_edit, 'String', num2str(handles.colocalization_length));
    return
end

%Update colocalization length value. 
handles.colocalization_length = colocalization_length;

%Update metadata file. 
hMainGui = getappdata(0, 'hMainGui');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
analysis_metadata{34,2} = colocalization_length;
setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

%Get handles of main GUI. 
h = findobj('Tag','Gui1');
g1data = guidata(h);

%In case colocalization channel is selected, determine colocalization. 
if handles.colocalization_channel >0
    %Get all selected tracks.
    selected_tracks = getappdata(hMainGui, 'selected_tracks'); 
    
    %Find positions at which there are selected tracks. 
    positions = find(~structfun(@isempty,selected_tracks)); 
    
    %If there are no positions; return.
    if isempty(positions)
        return
    else
        %Get number of positions at which there are tracks.
        num_positions = size(positions,1);
    end
    
    %Get current colocalization data.
    colocalization = getappdata(hMainGui, 'colocalization');
    
    %For each position with tracks, determine for each track if there is
    %colocalization.
    for i = 1:num_positions
        %Get tracks and image at current position.
        tracks = selected_tracks.(strcat('num',num2str(positions(i))));
        image = g1data.Image_combined.(strcat('channel',num2str(handles.colocalization_channel))).(strcat('num',num2str(positions(i))));
                
        %Pre-allocate vector. 
        colocalization_temp = nan(max(tracks(:,1)), 1);
        
        %Determine for each track if there is colocalization.
        for j = 1:max(tracks(:,1))
            %Get the coordinates of current track. 
            index_track = tracks(:,1)==j;
            track = tracks(index_track, 2:4);
        
            %Pre-allocate vector.
            presence_temp = zeros(size(track,1),1);
            
            %Determine for each frame if there is colocalization. 
            for k = 1:size(track,1)
                %Get x,y coordinates in current frame.
                x_low = track(k,2)- 10;
                x_high = track(k,2)+ 10;
                y_low = track(k,1)- 10;
                y_high = track(k,1)+ 10;

                %Construct ROI centered around spot.
                ROI = image(x_low:x_high, y_low:y_high, track(k,3));

                %Search for local maxima with given threshold in the given
                %channel in the ROI. 
                pk = pkfnd(ROI, handles.colocalization_threshold, 5);

                %If a peak is found in the ROI, calculate distance to 
                %center and only take if this is smaller than 3. 
                if size(pk,1) >= 1
                    %Calculate distance to center.
                    distance = sqrt((11 -pk(:,1)).^2 + (11 -pk(:,2)).^2);
                    if any(distance<3)
                        presence_temp(k) = 1;
                    end
                end
            end

            %Get the maximum number of consecutive frames with a spot in
            %the given channel. In case this is larger than the threshold
            %length, call colocalization. 
            presence_length_track = max(accumarray(nonzeros((cumsum(~presence_temp)+1).*presence_temp),1));
            if presence_length_track >= handles.colocalization_length
                colocalization_temp(j) = 1;
            else
                colocalization_temp(j) = 0;
            end
        end
        
        %Save colocalization data in app data. 
        colocalization.(strcat('num', num2str(positions(i)))) = colocalization_temp;
    end
    
    setappdata(hMainGui, 'colocalization', colocalization);
end

%Retrieve display settings. 
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette'); 
channels = getappdata(hMainGui, 'channels_selection');
analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function colocalization_length_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in colocalization_view_checkbox.
function colocalization_view_checkbox_Callback(hObject, eventdata, handles)

%Get user input. 
view_colocalization = get(hObject,'Value');

%Update analysis visuals in app data. 
hMainGui = getappdata(0, 'hMainGui');
analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
analysis_visuals(7) = view_colocalization;
setappdata(hMainGui, 'analysis_visuals', analysis_visuals);

%Get handles of main GUI. 
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Retrieve display settings. 
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');
colour = getappdata(hMainGui, 'colour_palette'); 
channels = getappdata(hMainGui, 'channels_selection');
analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
peaks = getappdata(hMainGui, 'peaks');
preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
selected_tracks = getappdata(hMainGui, 'selected_tracks');
segmented_image = getappdata(hMainGui, 'segmented_image');
colocalization = getappdata(hMainGui, 'colocalization');

%Display image. 
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Section 4 - Save %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in intensities_save_checkbox.
function intensities_save_checkbox_Callback(hObject, eventdata, handles)

%Get user input. 
handles.intensities_save = get(hObject, 'Value');

guidata(hObject, handles);


% --- Executes on button press in total_spots_save_checkbox.
function total_spots_save_checkbox_Callback(hObject, eventdata, handles)

%Get user input. 
handles.total_spots_save = get(hObject, 'Value');

guidata(hObject, handles);


% --- Executes on button press in appearances_save_checkbox.
function appearances_save_checkbox_Callback(hObject, eventdata, handles)

%Get user input. 
handles.appearances_save = get(hObject, 'Value');

guidata(hObject, handles);


% --- Executes on button press in colocalization_save_checkbox.
function colocalization_save_checkbox_Callback(hObject, eventdata, handles)

%Get user input.
handles.colocalization_save = get(hObject, 'Value');

guidata(hObject, handles);




% --- Executes on button press in save_pushbutton.
function save_pushbutton_Callback(hObject, eventdata, handles)

%If save settings for subroi and colocalization are activated, make sure
%that all settings are correct for it. 
if handles.subroi_channel ==0 && handles.subroi_save ==1
    errordlg('Choose a channel for segmentation', 'Error')
    return
elseif handles.colocalization_channel ==0 && handles.colocalization_save ==1
    errordlg('Choose a channel for colocalization', 'Error')
    return
end

%Get handles of main GUI. 
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Get selected tracks. 
hMainGui = getappdata(0, 'hMainGui');
selected_tracks = getappdata(hMainGui, 'selected_tracks');

%Get positions where tracks were selected. 
positions = [];
for i = 1:size(fieldnames(selected_tracks),1)
    if ~isempty(selected_tracks.(strcat('num', num2str(i))))
        positions = [positions; i];
    else
    end
end

%Get number of positions with selected tracks. 
num_positions = size(positions,1);

%Return if there are no positions with selected tracks. 
if num_positions<1
    errordlg('No positions with tracks are left', 'Error')
    return
end

%Calculate intensities for all tracks (do per position). 
for i = 1:num_positions
    %Get all tracks at current position.
    tracks = selected_tracks.(strcat('num', num2str(positions(i))));
    
    %Pre-allocate vectors. 
    intensity.(strcat('num', num2str(positions(i)))) = nan(size(tracks,1), g1data.num_channels);
    background_intensity.(strcat('num', num2str(positions(i)))) = nan(size(tracks,1), g1data.num_channels);
     
    %Get number of tracks at current position. 
    num_tracks = max(tracks(:,1));    
    
    %For each track: determine intensity and background intensity. 
    for j = 1:num_tracks
        %Get current track. 
        index_track = tracks(:,1)==j;
        track = tracks(index_track,:);
        
        %For each channel determine the intenisty and background intensity.
        for k = 1:g1data.num_channels
            [intensity.(strcat('num', num2str(positions(i))))(index_track, k), background_intensity.(strcat('num', num2str(positions(i))))(index_track, k)]= intensity_tracker_single_channel(...
                track, g1data.Image_combined.(strcat('channel', num2str(k))).(strcat('num', num2str(positions(i)))), handles.boxsize);
        end
    end
    
    %Calculate a corrected intensity (intensity-background)
    corrected_intensity.(strcat('num', num2str(positions(i)))) = intensity.(strcat('num', num2str(positions(i))))- background_intensity.(strcat('num', num2str(positions(i))));
    
    %Make a new matrix where everything is ordered on type intensity
    %(intensity, background, and background subtracted intensity. 
    all_intensity.(strcat('num', num2str(positions(i)))) = nan(size(corrected_intensity.(strcat('num', num2str(positions(i)))),1), 3*g1data.num_channels);
    for j = 1:g1data.num_channels
        all_intensity.(strcat('num', num2str(positions(i))))(:,3*j - 2) = intensity.(strcat('num', num2str(positions(i))))(:,j);
        all_intensity.(strcat('num', num2str(positions(i))))(:,3*j - 1) = background_intensity.(strcat('num', num2str(positions(i))))(:,j);
        all_intensity.(strcat('num', num2str(positions(i))))(:,3*j) = corrected_intensity.(strcat('num', num2str(positions(i))))(:,j);
    end
end

%Pre-allocate vectors. 
position_tracklength = zeros(num_positions,1);
position_number_tracks = zeros(num_positions,1);
track_info = [];

for i = 1:num_positions
    %Get length of longest track at current position. 
    [~, position_tracklength(i)] = mode(selected_tracks.(strcat('num', num2str(positions(i))))(:,1));
    %Get number of tracks at current position. 
    position_number_tracks(i) = max(selected_tracks.(strcat('num', num2str(positions(i))))(:,1));
    
    %Make vector indicating that all tracks at this position are from this
    %position. 
    position_numbers = repmat(positions(i),size(selected_tracks.(strcat('num', num2str(positions(i)))),1),1);
    
    %Fill track info with tracks and intensities at current position. 
    track_info = [track_info; position_numbers, selected_tracks.(strcat('num', num2str(positions(i)))),...
        all_intensity.(strcat('num', num2str(positions(i))))];
end

%Get maximum tracklength at all tracks and the total number of tracks. 
maximum_tracklength = max(position_tracklength);
total_number_tracks = sum(position_number_tracks);

%Reorganize corrected intensities: make a file where intensities of single
%channel are all next to each other. 
for i = 1:g1data.num_channels
    %Pre allocate vector according to longest track and number of tracks. 
    intensities.(strcat('channel', num2str(i))) = nan(maximum_tracklength +2, total_number_tracks);
    
    %Keep track of index (as we have to combine multiple positions). 
    number = 1;
    for j = 1:num_positions
        %Get corrected intensities of current channel at current position. 
        ci = corrected_intensity.(strcat('num', num2str(positions(j))))(:,i);
        
        %Get tracknumber at current position and max number of tracks. 
        tracknumbers = selected_tracks.(strcat('num', num2str(positions(j))))(:,1);
        num_tracks = max(tracknumbers);
        
        for k = 1:num_tracks
            %Get current intensity track. 
            index_track = tracknumbers==k;
            i_temp = ci(index_track);
            
            %To make all tracks equally long, nan's have to be added to all
            %tracks shorter than the longest track. 
            add_nan = nan((maximum_tracklength - size(i_temp,1)),1);
            
            %Add intensity track to the matrix.
            intensities.(strcat('channel', num2str(i)))(:,number) = [positions(j); k; i_temp; add_nan];
            
            %Update the index.
            number = number +1;
        end
    end
end

%Get the rois from the app data. 
roi_boundaries = getappdata(hMainGui, 'roi_boundaries');

%Pre-allocate vector to count rois at each position. 
num_rois = zeros(num_positions,1);

%For each position, determine the number of ROIs present. 
for i = 1:num_positions
    num_rois(i) = size(roi_boundaries.(strcat('num', num2str(positions(i)))),2);
end
%Get the total number of ROIs present in movie. 
total_num_rois = sum(num_rois);

if handles.subroi_save ==1
    num_entries = 3*(num_positions + total_num_rois);    
else
    num_entries = num_positions + total_num_rois;
end


position_info = cell(num_entries, 6);
number=1;
for i = 1:num_positions
    if handles.subroi_save ==1
        if num_rois(i)==0
            for j = 1:3
                position_info{number+j-1,1} = 'FOV';
                position_info{number+j-1,3} = positions(i);
            end
            
            position_info{number,2} = 'All';
            position_info{number+1,2} = 'Low';
            position_info{number+2,2} = 'High';
            
            number = number+3;
        else
            for j = 1:3
                position_info{number+j-1,1} = 'FOV';
                position_info{number+j-1,3} = positions(i);
            end
            
            position_info{number,2} = 'All';
            position_info{number+1,2} = 'Low';
            position_info{number+2,2} = 'High';
            
            for j = 1:num_rois(i)
                for k = 1:3
                    position_info{number+3*j+k-1,1} = strcat('ROI', num2str(j));
                    position_info{number+3*j+k-1,3} = positions(i);
                end
                
                position_info{number+3*j,2} = 'All';
                position_info{number+3*j+1,2} = 'Low';
                position_info{number+3*j+2,2} = 'High';
            end
            
            number = number+3*(j+1);
        end
    else
        if num_rois(i)==0
            position_info{number,1} = 'FOV';
            position_info{number,2} = 'All';
            position_info{number,3} = positions(i);
            
            number = number+1;
        else
            position_info{number,1} = 'FOV';
            position_info{number,2} = 'All';
            position_info{number,3} = positions(i);

            for j = 1:num_rois(i)
                position_info{number+j,1} = strcat('ROI ',num2str(j));
                position_info{number+j,2} = 'All';
                position_info{number+j,3} = positions(i);
            end

            number = number+j+1;
        end
    end
end

segmented_image = getappdata(hMainGui, 'segmented_image');

for i = 1:num_positions
    tracks = selected_tracks.(strcat('num', num2str(positions(i))));
    num_tracks = max(tracks(:,1));
    
    if handles.subroi_save ==1
        index_subroi.(strcat('num',num2str(positions(i)))) = nan(num_tracks,1);
    end
    if num_rois(i)>0
        index_roi.(strcat('num',num2str(positions(i)))) = nan(num_tracks,1);
    end
        
    for j = 1:num_tracks
        index_track = find(tracks(:,1)==j, 1,'first');
        
        if handles.subroi_save ==1
            [x,y] = find(segmented_image.(strcat('num',num2str(positions(i))))(:,:,tracks(index_track,4))>0);
            
            if isempty(intersect(find(x - tracks(index_track,3)==0),find(y - tracks(index_track,2)==0)))
                index_subroi.(strcat('num',num2str(positions(i))))(j) = 1;
            else
                index_subroi.(strcat('num',num2str(positions(i))))(j) = 2;                
            end            
        end
        
        if num_rois(i) >0
            rois = roi_boundaries.(strcat('num', num2str(positions(i))));
            
            inside = nan(num_rois(i),1);
            for k = 1:num_rois(i)
                inside(k) = inpolygon(tracks(index_track,3), tracks(index_track,2), rois{k}(:,1), rois{k}(:,2));
            end
            
            index_temp = find(inside==1);
            if isempty(index_temp)
                index_roi.(strcat('num',num2str(positions(i))))(j) = 0;
            else
                index_roi.(strcat('num',num2str(positions(i))))(j) = index_temp(1);
            end
        end
    end
end

analysis_metadata = getappdata(hMainGui, 'analysis_metadata');
    
if analysis_metadata{15,2} ==1 && analysis_metadata{17,2} ==1
    number_analysis_frames = analysis_metadata{18,2} - analysis_metadata{16,2} + 1;
    start_analysis = analysis_metadata{16,2};
    end_analysis = analysis_metadata{18,2};
elseif analysis_metadata{15,2} ==1
    number_analysis_frames = analysis_metadata{3,2} - analysis_metadata{16,2} + 1;
    start_analysis = analysis_metadata{16,2};
    end_analysis = analysis_metadata{3,2};
elseif analysis_metadata{17,2} ==1
    number_analysis_frames = analysis_metadata{18,2};
    start_analysis = 1;
    end_analysis = analysis_metadata{18,2};
else
    number_analysis_frames = analysis_metadata{3,2};
    start_analysis = 1;
    end_analysis = analysis_metadata{3,2};
end

if handles.total_spots_save ==1
    number =1;    
    for i = 1:num_positions
        tracks = selected_tracks.(strcat('num', num2str(positions(i))));

        total_spots_temp = nan(number_analysis_frames, 1);
        for j = start_analysis:end_analysis
            total_spots_temp(j -start_analysis +1) = sum(tracks(:,4)==j);
        end
        position_info{number,4} = total_spots_temp;

        number = number+1;

        if handles.subroi_save ==1
            track_numbers = find(index_subroi.(strcat('num', num2str(positions(i))))==1);
            tracks_temp = tracks(ismember(tracks(:,1), track_numbers),:);
            
            total_spots_temp = nan(number_analysis_frames, 1);
            for j = start_analysis:end_analysis
                total_spots_temp(j -start_analysis +1) = sum(tracks_temp(:,4)==j);
            end
            position_info{number,4} = total_spots_temp;

            track_numbers = find(index_subroi.(strcat('num', num2str(positions(i))))==2);
            tracks_temp = tracks(ismember(tracks(:,1), track_numbers),:);
            
            total_spots_temp = nan(number_analysis_frames, 1);
            for j = start_analysis:end_analysis
                total_spots_temp(j -start_analysis +1) = sum(tracks_temp(:,4)==j);
            end
            position_info{number+1,4} = total_spots_temp;

            number = number+2;
        end

        if num_rois(i) >0
            for j = 1:num_rois(i)
                track_numbers = find(index_roi.(strcat('num',num2str(positions(i))))==j);
                tracks_temp = tracks(ismember(tracks(:,1), track_numbers),:);

                total_spots_temp = nan(number_analysis_frames, 1);
                for k = start_analysis:end_analysis
                    total_spots_temp(k -start_analysis +1) = sum(tracks_temp(:,4)==k);
                end
                position_info{number,4} = total_spots_temp;

                if handles.subroi_save ==1
                    track_numbers = intersect(find(index_subroi.(strcat('num',num2str(positions(i))))==1),...
                        find(index_roi.(strcat('num',num2str(positions(i))))==j));

                    tracks_temp = tracks(ismember(tracks(:,1),track_numbers),:);

                    total_spots_temp = nan(number_analysis_frames, 1);
                    for k = start_analysis:end_analysis
                        total_spots_temp(k -start_analysis +1) = sum(tracks_temp(:,4)==k);
                    end
                    position_info{number+1,4} = total_spots_temp;

                    track_numbers = intersect(find(index_subroi.(strcat('num',num2str(positions(i))))==2),...
                        find(index_roi.(strcat('num',num2str(positions(i))))==j));

                    tracks_temp = tracks(ismember(tracks(:,1),track_numbers),:);

                    total_spots_temp = nan(number_analysis_frames, 1);
                    for k = start_analysis:end_analysis
                        total_spots_temp(k -start_analysis +1) = sum(tracks_temp(:,4)==k);
                    end
                    position_info{number+2,4} = total_spots_temp;

                    number = number+3;
                else
                    number = number+1;
                end
            end
        end
    end
end


if handles.appearances_save ==1
    number = 1;
    for i = 1:num_positions
        tracks = selected_tracks.(strcat('num', num2str(positions(i))));

        [~,index_appearance,~] = unique(tracks(:,1),'rows','first');
        appearance_times = tracks(index_appearance,4);

        temp_appearance = nan(number_analysis_frames, 1); 
        for j = start_analysis:end_analysis
            temp_appearance(j -start_analysis +1) = sum(appearance_times ==j);
        end
        position_info{number,5} = temp_appearance; 
        number = number+1;

        if handles.subroi_save ==1
            tracks_temp = appearance_times(index_subroi.(strcat('num',num2str(positions(i))))==1);

            temp_appearance = nan(number_analysis_frames, 1); 
            for j = start_analysis:end_analysis
                 temp_appearance(j -start_analysis +1) = sum(tracks_temp ==j);
            end
            position_info{number,5} = temp_appearance;

            tracks_temp = appearance_times(index_subroi.(strcat('num',num2str(positions(i))))==2);

            temp_appearance = nan(number_analysis_frames, 1); 
            for j = start_analysis:end_analysis
                 temp_appearance(j -start_analysis +1) = sum(tracks_temp ==j);
            end
            position_info{number+1,5} = temp_appearance;

            number = number+2;
        end

        if num_rois(i) >0
            for j = 1:num_rois(i)
                tracks_temp = appearance_times(index_roi.(strcat('num',num2str(positions(i))))==j);

                temp_appearance = nan(number_analysis_frames, 1); 
                for k = start_analysis:end_analysis
                    temp_appearance(k -start_analysis +1) = sum(tracks_temp ==k);
                end
                position_info{number,5} = temp_appearance;

                if handles.subroi_save ==1
                    index_combined = intersect(find(index_subroi.(strcat('num',num2str(positions(i))))==1),...
                        find(index_roi.(strcat('num',num2str(positions(i))))==j));

                    tracks_temp = appearance_times(index_combined);

                    temp_appearance = nan(number_analysis_frames, 1); 
                    for k = start_analysis:end_analysis
                        temp_appearance(k -start_analysis +1) = sum(tracks_temp ==k);
                    end
                    position_info{number+1,5} = temp_appearance;

                    index_combined = intersect(find(index_subroi.(strcat('num',num2str(positions(i))))==2),...
                        find(index_roi.(strcat('num',num2str(positions(i))))==j));

                    tracks_temp = appearance_times(index_combined);

                    temp_appearance = nan(number_analysis_frames, 1); 
                    for k = start_analysis:end_analysis
                        temp_appearance(k -start_analysis +1) = sum(tracks_temp ==k);
                    end
                    position_info{number+2,5} = temp_appearance;

                    number= number+3;
                else
                    number = number+1;
                end
            end
        end    
    end
end

if handles.colocalization_save ==1
    colocalization = getappdata(hMainGui, 'colocalization'); 
    number =1;  
    
    for i = 1:num_positions
        colocalization_position = colocalization.(strcat('num', num2str(positions(i))));

        position_info{number,6} = [sum(colocalization_position ==0); sum(colocalization_position ==1)];
        number = number+1;

        if handles.subroi_save ==1
            colocalization_temp = colocalization_position(index_subroi.(strcat('num',num2str(positions(i))))==1);
            position_info{number,6} = [sum(colocalization_temp ==0); sum(colocalization_temp ==1)];

            colocalization_temp = colocalization_position(index_subroi.(strcat('num',num2str(positions(i))))==2);
            position_info{number+1,6} = [sum(colocalization_temp ==0); sum(colocalization_temp ==1)];

            number = number+2;
        end

        if num_rois(i) >0
            for j = 1:num_rois(i)
                colocalization_temp = colocalization_position(index_roi.(strcat('num',num2str(positions(i))))==j);
                position_info{number,6} = [sum(colocalization_temp ==0); sum(colocalization_temp ==1)];

                if handles.subroi_save ==1
                    index_combined = intersect(find(index_subroi.(strcat('num',num2str(positions(i))))==1),...
                        find(index_roi.(strcat('num',num2str(positions(i))))==j));

                    colocalization_temp = colocalization_position(index_combined);
                    position_info{number+1,6} = [sum(colocalization_temp ==0); sum(colocalization_temp ==1)];

                    index_combined = intersect(find(index_subroi.(strcat('num',num2str(positions(i))))==2),...
                        find(index_roi.(strcat('num',num2str(positions(i))))==j));

                    colocalization_temp = colocalization_position(index_combined);
                    position_info{number+2,6} = [sum(colocalization_temp ==0); sum(colocalization_temp ==1)];

                    number = number+3;
                else
                    number = number+1;
                end
            end
        end
    end
end

    
[FileNameBodeWrite, PathNameBodeWrite] = uiputfile({'*.xlsx';'*.csv'}, 'Save As...', ['defname' '.xlsx']);
progressbar(0)

analysis_metadata = getappdata(hMainGui, 'analysis_metadata');

if g1data.num_channels>1
    metadata_sheet = cell(size(analysis_metadata,1), g1data.num_channels +1);
else
    metadata_sheet = cell(size(analysis_metadata,1), 3);
end

metadata_sheet(:,1:2) = analysis_metadata;

bleach_correction = analysis_metadata{1,2};
for i = 1:g1data.num_channels
    metadata_sheet{1,i+1} = bleach_correction(i);
end

dimensions = analysis_metadata{5,2};
metadata_sheet{5,2} = dimensions(1);
metadata_sheet{5,3} = dimensions(2);

xlswrite(strcat(PathNameBodeWrite,FileNameBodeWrite), metadata_sheet, 'Metadata')
progressbar(1/6)

headings1 = cell(1, 5 + g1data.num_channels*3);
headings1{1} = 'Position';
headings1{2} = 'Tracknumber';
headings1{3} = 'x';
headings1{4} = 'y';
headings1{5} = 't';

for i = 1:g1data.num_channels
    headings1{5 + 3*i - 2} = strcat('Intensity Channel', num2str(i));
    headings1{5 + 3*i - 1} = strcat('Background Channel', num2str(i));
    headings1{5 + 3*i} = strcat('Corrected Intensity Channel', num2str(i));
end

track_info_sheet = [headings1; num2cell(track_info)];

xlswrite(strcat(PathNameBodeWrite,FileNameBodeWrite), track_info_sheet, 'General Track info')
progressbar(2/6)

headings2 = cell(maximum_tracklength +2,1);
headings2{1} = 'Position';
headings2{2} = 'Track number';

for i = 1:g1data.num_channels
    intensities_sheet.(strcat('channel', num2str(i))) = [headings2, num2cell(intensities.(strcat('channel', num2str(i))))];
end

for i = 1:g1data.num_channels
    if handles.intensities_save ==1
        xlswrite(strcat(PathNameBodeWrite,FileNameBodeWrite), intensities_sheet.(strcat('channel', num2str(i))), strcat('Channel', num2str(i), 'Intensities'))
    end
end
progressbar(3/6)

if handles.fov_save ==1
    index_fov_all = intersect(find(strcmp(position_info(:,1), 'FOV')==1), find(strcmp(position_info(:,2), 'All')==1));
    if handles.subroi_save ==1
        index_fov_low = intersect(find(strcmp(position_info(:,1), 'FOV')==1), find(strcmp(position_info(:,2), 'Low')==1));
        index_fov_high = intersect(find(strcmp(position_info(:,1), 'FOV')==1), find(strcmp(position_info(:,2), 'High')==1));
    end

    headings3 = cell(1, 1 +size(index_fov_all, 1));
    headings3{1} = 'Time (frame)';

    headings4c = cell(1, size(index_fov_all, 1));
    headings4r = {'Colocalization?';'no'; 'yes'};

    for i = 1:size(index_fov_all, 1)
        headings3{i+1} = strcat('Position', num2str(position_info{index_fov_all(i),3}));
        headings4c{i} = strcat('Position', num2str(position_info{index_fov_all(i),3}));    
    end

    time_frames = transpose(start_analysis:end_analysis); 
    
    if handles.total_spots_save ==1
        total_spots_fov_all = nan(number_analysis_frames, size(index_fov_all, 1) +1);
        total_spots_fov_all(:,1) = time_frames;
        
        for i = 1:size(index_fov_all,1)
            total_spots_fov_all(:,i+1) = position_info{index_fov_all(i),4}; 
        end
        
        xlswrite(strcat(PathNameBodeWrite,FileNameBodeWrite),[headings3; num2cell(total_spots_fov_all)],'FOV-All-Total Spots')
                
        if handles.subroi_save ==1
            total_spots_fov_low = nan(number_analysis_frames, size(index_fov_low,1)+1); 
            total_spots_fov_low(:,1) = time_frames; 
            
            total_spots_fov_high = nan(number_analysis_frames, size(index_fov_high,1)+1); 
            total_spots_fov_high(:,1) = time_frames;
            
            for i = 1:size(index_fov_all,1)
                total_spots_fov_low(:,i+1) = position_info{index_fov_low(i),4};
                total_spots_fov_high(:,i+1) = position_info{index_fov_high(i),4};
            end
            
            xlswrite(strcat(PathNameBodeWrite,FileNameBodeWrite),[headings3; num2cell(total_spots_fov_low)],'FOV-Low-Total Spots')
            xlswrite(strcat(PathNameBodeWrite,FileNameBodeWrite),[headings3; num2cell(total_spots_fov_high)],'FOV-High-Total Spots')
        end
    end
    
    if handles.appearances_save ==1
        appearances_fov_all = nan(number_analysis_frames, size(index_fov_all,1) +1);    
        appearances_fov_all(:,1) = time_frames;
        
        for i = 1:size(index_fov_all,1)
            appearances_fov_all(:,i+1) = position_info{index_fov_all(i),5};
        end
        
        xlswrite(strcat(PathNameBodeWrite,FileNameBodeWrite),[headings3; num2cell(appearances_fov_all)],'FOV-All-Appearances')
        
        if handles.subroi_save ==1
            appearances_fov_low = nan(number_analysis_frames, size(index_fov_low,1)+1); 
            appearances_fov_low(:,1) = time_frames;
            
            appearances_fov_high = nan(number_analysis_frames, size(index_fov_high,1)+1); 
            appearances_fov_high(:,1) = time_frames;
            
            for i = 1:size(index_fov_all,1)
                appearances_fov_low(:,i+1) = position_info{index_fov_low(i),5};
                appearances_fov_high(:,i+1) = position_info{index_fov_high(i),5};
            end
            
            xlswrite(strcat(PathNameBodeWrite,FileNameBodeWrite),[headings3; num2cell(appearances_fov_low)],'FOV-Low-Appearances')
            xlswrite(strcat(PathNameBodeWrite,FileNameBodeWrite),[headings3; num2cell(appearances_fov_high)],'FOV-High-Appearances')
        end
    end
    
    if handles.colocalization_save ==1
        colocalization_fov_all = nan(2, size(index_fov_all,1));
        
        for i = 1:size(index_fov_all,1)
            colocalization_fov_all(:,i) = position_info{index_fov_all(i),6};
        end
        
        xlswrite(strcat(PathNameBodeWrite,FileNameBodeWrite),[headings4r,[headings4c; num2cell(colocalization_fov_all)]],'FOV-All-Colocalization')
    
        if handles.subroi_save ==1
            colocalization_fov_low = nan(2, size(index_fov_low,1));
            colocalization_fov_high = nan(2, size(index_fov_high,1));
            
            for i = 1:size(index_fov_all,1)
                colocalization_fov_low(:,i) = position_info{index_fov_low(i),6};
                colocalization_fov_high(:,i) = position_info{index_fov_high(i),6};
            end
            
            xlswrite(strcat(PathNameBodeWrite,FileNameBodeWrite),[headings4r,[headings4c; num2cell(colocalization_fov_low)]],'FOV-Low-Colocalization')
            xlswrite(strcat(PathNameBodeWrite,FileNameBodeWrite),[headings4r,[headings4c; num2cell(colocalization_fov_high)]],'FOV-High-Colocalization')
        end
    end 
end
progressbar(4/6)

if handles.roi_save ==1
    index_roi_all = intersect(find(~cellfun(@isempty,strfind(position_info(:,1),'ROI'))), find(strcmp(position_info(:,2),'All')==1));
    if handles.subroi_save ==1
        index_roi_low = intersect(find(~cellfun(@isempty,strfind(position_info(:,1),'ROI'))), find(strcmp(position_info(:,2),'Low')==1));
        index_roi_high = intersect(find(~cellfun(@isempty,strfind(position_info(:,1),'ROI'))), find(strcmp(position_info(:,2),'High')==1));
    end

    headings5 = cell(1, 1 +size(index_roi_all, 1));
    headings5{1} = 'Time (frame)';

    headings6c = cell(1, size(index_roi_all, 1));
    headings6r = {'Colocalization?';'no'; 'yes'};

    for i = 1:size(index_roi_all,1)
        headings5{i+1} = strcat('Position',num2str(position_info{index_roi_all(i),3}), position_info{index_roi_all(i),1});        
        headings6c{i} = strcat('Position',num2str(position_info{index_roi_all(i),3}), position_info{index_roi_all(i),1});
    end
    
    if handles.total_spots_save ==1
        total_spots_roi_all = nan(number_analysis_frames, size(index_roi_all, 1) +1);
        total_spots_roi_all(:,1) = time_frames;
        
        for i = 1:size(index_roi_all,1)
            total_spots_roi_all(:,i+1) = position_info{index_roi_all(i),4}; 
        end
        
        xlswrite(strcat(PathNameBodeWrite,FileNameBodeWrite),[headings5; num2cell(total_spots_roi_all)],'ROI-All-Total Spots')
        
        if handles.subroi_save ==1
            total_spots_roi_low = nan(number_analysis_frames, size(index_roi_low,1)+1); 
            total_spots_roi_low(:,1) = time_frames; 
            
            total_spots_roi_high = nan(number_analysis_frames, size(index_roi_high,1)+1); 
            total_spots_roi_high(:,1) = time_frames;
            
            for i = 1:size(index_roi_all,1)
                total_spots_roi_low(:,i+1) = position_info{index_roi_low(i),4};
                total_spots_roi_high(:,i+1) = position_info{index_roi_high(i),4};
            end
            
            xlswrite(strcat(PathNameBodeWrite,FileNameBodeWrite),[headings5; num2cell(total_spots_roi_low)],'ROI-Low-Total Spots')
            xlswrite(strcat(PathNameBodeWrite,FileNameBodeWrite),[headings5; num2cell(total_spots_roi_high)],'ROI-High-Total Spots')
        end
        
    end
    
    if handles.appearances_save ==1
        appearances_roi_all = nan(number_analysis_frames, size(index_roi_all, 1) +1);
        appearances_roi_all(:,1) = time_frames;
        
        for i = 1:size(index_roi_all,1)
            appearances_roi_all(:,i+1) = position_info{index_roi_all(i),5};
        end
        
        xlswrite(strcat(PathNameBodeWrite,FileNameBodeWrite),[headings5; num2cell(appearances_roi_all)],'ROI-All-Appearances')
        
        if handles.subroi_save ==1
            appearances_roi_low = nan(number_analysis_frames, size(index_roi_low,1)+1); 
            appearances_roi_low(:,1) = time_frames; 
            
            appearances_roi_high = nan(number_analysis_frames, size(index_roi_high,1)+1); 
            appearances_roi_high(:,1) = time_frames;
            
            for i = 1:size(index_roi_all,1)
                appearances_roi_low(:,i+1) = position_info{index_roi_low(i),5};
                appearances_roi_high(:,i+1) = position_info{index_roi_high(i),5};
            end
            
            xlswrite(strcat(PathNameBodeWrite,FileNameBodeWrite),[headings5; num2cell(appearances_roi_low)],'ROI-Low-Appearances')
            xlswrite(strcat(PathNameBodeWrite,FileNameBodeWrite),[headings5; num2cell(appearances_roi_high)],'ROI-High-Appearances')
        end
        
    end
    
    if handles.colocalization_save ==1
        colocalization_roi_all = nan(2, size(index_roi_all,1));
        
        for i = 1:size(index_roi_all,1)
            colocalization_roi_all(:,i) = position_info{index_roi_all(i),6};
        end
        
        xlswrite(strcat(PathNameBodeWrite,FileNameBodeWrite),[headings6r, [headings6c; num2cell(colocalization_roi_all)]],'ROI-All-Colocalization')
        
        if handles.subroi_save ==1
            colocalization_roi_low = nan(2, size(index_roi_low,1));
            colocalization_roi_high = nan(2, size(index_roi_high,1));
            
            for i = 1:size(index_roi_all,1)
                colocalization_roi_low(:,i) = position_info{index_roi_low(i),6};
                colocalization_roi_high(:,i) = position_info{index_roi_high(i),6};
            end
            
            xlswrite(strcat(PathNameBodeWrite,FileNameBodeWrite),[headings6r, [headings6c; num2cell(colocalization_roi_low)]],'ROI-Low-Colocalization')
            xlswrite(strcat(PathNameBodeWrite,FileNameBodeWrite),[headings6r, [headings6c; num2cell(colocalization_roi_high)]],'ROI-High-Colocalization')
        end      
    end
end
progressbar(5/6)

% EN: Sheet, DE: Tabelle, etc. (language dependent)
sheetName = 'Sheet'; 

% Open Excel file.
objExcel = actxserver('Excel.Application');
objExcel.Workbooks.Open(fullfile(PathNameBodeWrite, FileNameBodeWrite)); % Full path is necessary!

% Delete sheets.
try
    % Throws an error if the sheets do not exist.
    objExcel.ActiveWorkbook.Worksheets.Item([sheetName '1']).Delete;
catch
    % Do nothing.
end

% Save, close and clean up.
objExcel.ActiveWorkbook.Save;
objExcel.ActiveWorkbook.Close;
objExcel.Quit;
objExcel.delete;
    
progressbar(1)
clc

guidata(hObject, handles)




% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)

h = findobj('Tag','Gui1');
g1data = guidata(h);

hMainGui = getappdata(0, 'hMainGui');

if g1data.active_transtrack ==1
    %Set the standard visualization options for analysis. 
    analysis_visuals = getappdata(hMainGui, 'analysis_visuals');
    analysis_visuals(6:7) = 0;
    setappdata(hMainGui, 'analysis_visuals', analysis_visuals);

    %Set the standard settings for analysis. 
    analysis_metadata = getappdata(hMainGui,'analysis_metadata');

    analysis_metadata{29,2} = 8;
    analysis_metadata{30,2} = 0;
    analysis_metadata{31,2} = 1000;
    analysis_metadata{32,2} = 0;
    analysis_metadata{33,2} = 1000;
    analysis_metadata{34,2} = 1;

    setappdata(hMainGui, 'analysis_metadata', analysis_metadata);

    %(Re)set the tracking handles.
    for i = 1:g1data.num_position
        segmented_image.(strcat('num', num2str(i))) = [];
        colocalization.(strcat('num', num2str(i))) = [];
    end

    setappdata(hMainGui, 'segmented_image', segmented_image);
    setappdata(hMainGui, 'colocalization', colocalization);

    minimum_display = getappdata(hMainGui, 'minimum_display');
    maximum_display = getappdata(hMainGui, 'maximum_display');
    colour = getappdata(hMainGui, 'colour_palette'); 
    channels = getappdata(hMainGui, 'channels_selection');

    roi_boundaries = getappdata(hMainGui, 'roi_boundaries');
    peaks = getappdata(hMainGui, 'peaks');
    preliminary_tracks = getappdata(hMainGui, 'preliminary_tracks');
    selected_tracks = getappdata(hMainGui, 'selected_tracks');

    %Display image. 
    displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
        g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
        preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);
else
end

%Delete(hObject); closes the figure
delete(hObject);
