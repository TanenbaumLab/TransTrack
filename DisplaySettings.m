function varargout = DisplaySettings(varargin)
% DISPLAYSETTINGS MATLAB code for DisplaySettings.fig
%      DISPLAYSETTINGS, by itself, creates a new DISPLAYSETTINGS or raises the existing
%      singleton*.
%
%      H = DISPLAYSETTINGS returns the handle to a new DISPLAYSETTINGS or the handle to
%      the existing singleton*.
%
%      DISPLAYSETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DISPLAYSETTINGS.M with the given input arguments.
%
%      DISPLAYSETTINGS('Property','Value',...) creates a new DisplaySettings or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DisplaySettings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop. All inputs are passed to DisplaySettings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Last Modified by GUIDE v2.5 18-Feb-2019 23:14:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DisplaySettings_OpeningFcn, ...
                   'gui_OutputFcn',  @DisplaySettings_OutputFcn, ...
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


% --- Executes just before Display Settings is made visible.
function DisplaySettings_OpeningFcn(hObject, eventdata, handles, varargin)

%Get handles of main GUI. 
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Retrieve display settings from app data. 
hMainGui = getappdata(0, 'hMainGui');
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');

%Display histogram of channel 1. Take first frame of first position to make
%histogram. 
example_image = g1data.Image_combined.channel1.num1(:,:,1);
numbins = 2*(size(example_image(:),1))^(1/3);
[handles.bin_values, handles.bins] = hist(double(example_image(:)),numbins,'Parent',handles.axes1);

%Set-up of different sliders in GUI. 

%Channel slider                                    
handles.sliderListener_channel = addlistener(handles.channel_slider,'ContinuousValueChange', ...
                                      @(hObject, event) channel_sliderContValCallback(...
                                        hObject, eventdata, handles));
set(handles.channel_slider, 'Max', g1data.num_channels);
set(handles.channel_slider, 'SliderStep', [1/g1data.num_channels , 10/g1data.num_channels]);
handles.selected_channel = 1;

%Minimum slider
handles.sliderListener_minimum = addlistener(handles.minimum_slider,'ContinuousValueChange', ...
                                      @(hObject, event) minimum_sliderContValCallback(...
                                        hObject, eventdata, handles));
set(handles.minimum_slider, 'SliderStep', [1/2^8, 10/2^8]);
set(handles.minimum_slider, 'Value', minimum_display(1));
set(handles.minimum_edit, 'String', minimum_display(1));

%Maximum slider
handles.sliderListener_maximum = addlistener(handles.maximum_slider,'ContinuousValueChange', ...
                                      @(hObject, event) maximum_sliderContValCallback(...
                                        hObject, eventdata, handles));
set(handles.maximum_slider, 'SliderStep', [1/2^8, 10/2^8]);
set(handles.maximum_slider, 'Value', maximum_display(1));
set(handles.maximum_edit, 'String', maximum_display(1));

%Brightness slider
handles.sliderListener_brightness = addlistener(handles.brightness_slider,'ContinuousValueChange', ...
                                      @(hObject, event) brightness_sliderContValCallback(...
                                        hObject, eventdata, handles));
set(handles.brightness_slider, 'Value', 0)
set(handles.brightness_slider, 'Max', (minimum_display(handles.selected_channel) + maximum_display(handles.selected_channel))/2)
set(handles.brightness_slider, 'Min', -(abs(2*65536 - minimum_display(handles.selected_channel) - maximum_display(handles.selected_channel)))/2)

%Note down brightness minimum and maximum based on current display settings. 
handles.brightness_minimum = minimum_display(handles.selected_channel);
handles.brightness_maximum = maximum_display(handles.selected_channel);
                                    
%Contrast slider
handles.sliderListener_contrast = addlistener(handles.contrast_slider,'ContinuousValueChange', ...
                                      @(hObject, event) contrast_sliderContValCallback(...
                                        hObject, eventdata, handles));
set(handles.contrast_slider, 'Max', 0)
set(handles.contrast_slider, 'Min', -2*2^16)

%Make contrast slider non-linear: decreasing the contrast slider goes
%faster and faster. 
handles.contrast_factor = transpose(1:3/2^16:4);
if maximum_display(handles.selected_channel) - minimum_display(handles.selected_channel) < 2^16
    contrast_value = minimum_display(handles.selected_channel) - maximum_display(handles.selected_channel);
else
    [~,closestIndex] = min(abs(round(handles.contrast_factor.*transpose(2^16:2*2^16))-(maximum_display(handles.selected_channel) - minimum_display(handles.selected_channel))));
    contrast_value = -closestIndex - 2^16;
end
set(handles.contrast_slider, 'Value', contrast_value)

%Display settings for histogram: upper and lower bound. Set starting values
%(which are full range of histogram). 
handles.lower_limit = zeros(g1data.num_channels,1);
handles.upper_limit = repmat(65536, g1data.num_channels, 1);

%Plot histogram and line through it to show current display settings for
%channel. 
hold(handles.axes1,'off')
bar(handles.axes1, handles.bins, handles.bin_values)
hold(handles.axes1,'on')
plot(handles.axes1, [minimum_display(handles.selected_channel); maximum_display(handles.selected_channel)], get(handles.axes1,'YLim'))
set(handles.axes1,'xtick',[],'ytick',[], 'xlim', [0, 65536])

% Choose default command line output for DisplaySettings
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = DisplaySettings_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Section 1 - Select channel for display settings%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on channel slider movement.
function channel_sliderContValCallback(hObject, eventdata, handles)

%Retrieve handles. 
handles = guidata(hObject);

%Get slider value and update channel edit. 
handles.selected_channel = round(get(hObject,'Value'));
set(handles.channel_edit, 'String', handles.selected_channel);

%Get handles of main GUI. 
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Get an example image for histogram for selected channel by user. Take
%first frame of first position, and calculate histogram. 
example_image = g1data.Image_combined.(strcat('channel',num2str(handles.selected_channel))).num1(:,:,1);
numbins = 2*(size(example_image(:),1))^(1/3);
[handles.bin_values, handles.bins] = hist(double(example_image(:)),numbins,'Parent',handles.axes1);

%Retrieve current display settings for channel. 
hMainGui = getappdata(0, 'hMainGui');
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');

%Update all sliders to current selected channel. 

%minimum slider and minimum edit. 
if minimum_display(handles.selected_channel) < 1
    set(handles.minimum_slider, 'Value', 1);
elseif minimum_display(handles.selected_channel) > 65536
    set(handles.minimum_slider, 'Value', 2^16);
else
    set(handles.minimum_slider, 'Value', minimum_display(handles.selected_channel));
end
set(handles.minimum_edit, 'String', minimum_display(handles.selected_channel));

%maximum slider and maximum edit. 
if maximum_display(handles.selected_channel) < 1
    set(handles.maximum_slider, 'Value', 1);
elseif maximum_display(handles.selected_channel) > 65536
    set(handles.maximum_slider, 'Value', 2^16);
else
    set(handles.maximum_slider, 'Value', maximum_display(handles.selected_channel));
end
set(handles.maximum_edit, 'String', maximum_display(handles.selected_channel));

%brightness slider. 
set(handles.brightness_slider, 'Value', 0)
set(handles.brightness_slider, 'Max', (minimum_display(handles.selected_channel) + maximum_display(handles.selected_channel))/2)
set(handles.brightness_slider, 'Min', -(abs(2*65536 - minimum_display(handles.selected_channel) - maximum_display(handles.selected_channel)))/2)

handles.brightness_minimum = minimum_display(handles.selected_channel);
handles.brightness_maximum = maximum_display(handles.selected_channel);

%contrast slider. 
if maximum_display(handles.selected_channel) - minimum_display(handles.selected_channel) < 2^16
    contrast_value = minimum_display(handles.selected_channel) - maximum_display(handles.selected_channel);
else
    [~,closestIndex] = min(abs(round(handles.contrast_factor.*transpose(2^16:2*2^16))-(maximum_display(handles.selected_channel) - minimum_display(handles.selected_channel))));
    contrast_value = -closestIndex - 2^16;
end
set(handles.contrast_slider, 'Value', contrast_value)

%Retrieve lower and upper bounds for histogram display. 
set(handles.limitlower_edit, 'String', handles.lower_limit(handles.selected_channel))
set(handles.limitupper_edit, 'String', handles.upper_limit(handles.selected_channel))

%Plot histogram and current display settings in it. 
hold(handles.axes1,'off')
bar(handles.axes1, handles.bins, handles.bin_values)
hold(handles.axes1,'on')
plot(handles.axes1, [minimum_display(handles.selected_channel); maximum_display(handles.selected_channel)], get(handles.axes1,'YLim'))
set(handles.axes1,'xtick',[],'ytick',[], 'xlim', [handles.lower_limit(handles.selected_channel), handles.upper_limit(handles.selected_channel)])

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function channel_slider_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




% --- Executes on channel edit change.
function channel_edit_Callback(hObject, eventdata, handles)

%Get handles of main GUI. 
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Only update when valid number is inserted. Otherwise: return.  
if isnan(str2double(get(hObject,'String')))
    return
elseif str2double(get(hObject,'String')) > g1data.num_channels
    errordlg('Number is higher than channels in image','Error')
    return
end

%Set selected channel for display settings, and update the slider. 
handles.selected_channel = str2double(get(hObject,'String'));
set(handles.channel_slider, 'Value', handles.selected_channel);

%Get example image for selected channel and calculate histogram. Take first
%frame of first position as example image. 
example_image = g1data.Image_combined.(strcat('channel',num2str(handles.selected_channel))).num1(:,:,1);
numbins = 2*(size(example_image(:),1))^(1/3);
[handles.bin_values, handles.bins] = hist(double(example_image(:)),numbins,'Parent',handles.axes1);

%Retrieve current display settings for this channel. 
hMainGui = getappdata(0, 'hMainGui');
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');

%Update all sliders and edits to selected channel.

%minimum slider and minimum edit. 
if minimum_display(handles.selected_channel) < 1
    set(handles.minimum_slider, 'Value', 1);
elseif minimum_display(handles.selected_channel) > 65536
    set(handles.minimum_slider, 'Value', 2^16);
else
    set(handles.minimum_slider, 'Value', minimum_display(handles.selected_channel));
end
set(handles.minimum_edit, 'String', minimum_display(handles.selected_channel));

%maximum slider and maximum edit. 
if maximum_display(handles.selected_channel) < 1
    set(handles.maximum_slider, 'Value', 1);
elseif maximum_display(handles.selected_channel) > 65536
    set(handles.maximum_slider, 'Value', 2^16);
else
    set(handles.maximum_slider, 'Value', maximum_display(handles.selected_channel));
end
set(handles.maximum_edit, 'String', maximum_display(handles.selected_channel));

%brightness slider. 
set(handles.brightness_slider, 'Value', 0)
set(handles.brightness_slider, 'Max', (minimum_display(handles.selected_channel) + maximum_display(handles.selected_channel))/2)
set(handles.brightness_slider, 'Min', -(abs(2*65536 - minimum_display(handles.selected_channel) - maximum_display(handles.selected_channel)))/2)

handles.brightness_minimum = minimum_display(handles.selected_channel);
handles.brightness_maximum = maximum_display(handles.selected_channel);

%contrast slider. 
if maximum_display(handles.selected_channel) - minimum_display(handles.selected_channel) < 2^16
    contrast_value = minimum_display(handles.selected_channel) - maximum_display(handles.selected_channel);
else
    [~,closestIndex] = min(abs(round(handles.contrast_factor.*transpose(2^16:2*2^16))-(maximum_display(handles.selected_channel) - minimum_display(handles.selected_channel))));
    contrast_value = -closestIndex - 2^16;
end
set(handles.contrast_slider, 'Value', contrast_value)

%Retrieve lower and upper bounds for histogram display. 
set(handles.limitlower_edit, 'String', handles.lower_limit(handles.selected_channel))
set(handles.limitupper_edit, 'String', handles.upper_limit(handles.selected_channel))

%Plot histogram and current display settings in it. 
hold(handles.axes1,'off')
bar(handles.axes1, handles.bins, handles.bin_values)
hold(handles.axes1,'on')
plot(handles.axes1, [minimum_display(handles.selected_channel); maximum_display(handles.selected_channel)], get(handles.axes1,'YLim'))
set(handles.axes1,'xtick',[],'ytick',[], 'xlim', [handles.lower_limit(handles.selected_channel), handles.upper_limit(handles.selected_channel)])

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function channel_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on lower limit edit change.
function limitlower_edit_Callback(hObject, eventdata, handles)

%Only update when valid number is inserted. Otherwise: return. 
if isnan(str2double(get(hObject,'String')))
    return
end

%Update lower limit for histogram display. 
handles.lower_limit(handles.selected_channel) = str2double(get(hObject,'String'));

%Lower limit must be in range 0-2^16. If not adjust automatically to
%extremes. 
if handles.lower_limit(handles.selected_channel)  < 0
    handles.lower_limit(handles.selected_channel)  = 0;
    set(handles.limitlower_edit, 'String', handles.lower_limit(handles.selected_channel))
elseif handles.lower_limit(handles.selected_channel)  > 65535
    handles.lower_limit(handles.selected_channel)  = 65535;
    set(handles.limitlower_edit, 'String', handles.lower_limit(handles.selected_channel))
end
%If upper limit is now lower than lower limit for display, update upper
%limit and make it one larger than lower limit. 
if handles.upper_limit(handles.selected_channel) <= handles.lower_limit(handles.selected_channel)
    handles.upper_limit(handles.selected_channel) = handles.lower_limit(handles.selected_channel) + 1;
    set(handles.limitupper_edit, 'String', handles.upper_limit(handles.selected_channel))
end

%Retrieve display settings for current channel. 
hMainGui = getappdata(0, 'hMainGui');
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');

%Plot histogram and current display settings in it. 
hold(handles.axes1,'off')
bar(handles.axes1, handles.bins, handles.bin_values)
hold(handles.axes1,'on')
plot(handles.axes1, [minimum_display(handles.selected_channel); maximum_display(handles.selected_channel)], get(handles.axes1,'YLim'))
set(handles.axes1,'xtick',[],'ytick',[], 'xlim', [handles.lower_limit(handles.selected_channel), handles.upper_limit(handles.selected_channel)])

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function limitlower_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on upper limit edit change.
function limitupper_edit_Callback(hObject, eventdata, handles)

%Only update when valid number is inserted. Otherwise: return. 
if isnan(str2double(get(hObject,'String')))
    return
end

%Update lower limit for histogram display. 
handles.upper_limit(handles.selected_channel) = str2double(get(hObject,'String'));

%Lower limit must be in range 0-2^16. If not adjust automatically to
%extremes. 
if handles.upper_limit(handles.selected_channel)  < 1
    handles.upper_limit(handles.selected_channel)  = 1;
    set(handles.limitupper_edit, 'String', handles.upper_limit(handles.selected_channel))
elseif handles.upper_limit(handles.selected_channel)  > 65536
    handles.upper_limit(handles.selected_channel)  = 65536;
    set(handles.limitupper_edit, 'String', handles.upper_limit(handles.selected_channel))
end
%If upper limit is now lower than lower limit for display, update upper
%limit and make it one larger than lower limit. 
if handles.lower_limit(handles.selected_channel) >= handles.upper_limit(handles.selected_channel)
    handles.lower_limit(handles.selected_channel) = handles.upper_limit(handles.selected_channel) - 1;
    set(handles.limitlower_edit, 'String', handles.lower_limit(handles.selected_channel))
end

%Retrieve display settings for current channel. 
hMainGui = getappdata(0, 'hMainGui');
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');

%Plot histogram and current display settings in it.
hold(handles.axes1,'off')
bar(handles.axes1, handles.bins, handles.bin_values)
hold(handles.axes1,'on')
plot(handles.axes1, [minimum_display(handles.selected_channel); maximum_display(handles.selected_channel)], get(handles.axes1,'YLim'))
set(handles.axes1,'xtick',[],'ytick',[], 'xlim', [handles.lower_limit(handles.selected_channel), handles.upper_limit(handles.selected_channel)])

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function limitupper_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Section 2- Change display settings of channel%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on minimum slider movement.
function minimum_sliderContValCallback(hObject, eventdata, handles)

%Retrieve handles. 
handles = guidata(hObject);

%Get slider value and update minimum edit accordingly. 
minimum = round(get(hObject,'Value'));
set(handles.minimum_edit, 'String', minimum);

%Retrieve current display settings. 
hMainGui = getappdata(0, 'hMainGui');
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');

%Update and save new display settings. 
minimum_display(handles.selected_channel) = minimum;
setappdata(hMainGui, 'minimum_display', minimum_display);


%Update maximum slider and edit in case minimum gets higher than maximum. 
%Also update display settings in this case. 
if minimum_display(handles.selected_channel) > maximum_display(handles.selected_channel)
    maximum_display(handles.selected_channel) = minimum_display(handles.selected_channel);
    
    setappdata(hMainGui, 'maximum_display', maximum_display);   
    set(handles.maximum_slider, 'Value', maximum_display(handles.selected_channel));
    set(handles.maximum_edit, 'String', maximum_display(handles.selected_channel));
end

%Make sure maximum display settings cannot get higher than 2^16. 
if maximum_display(handles.selected_channel) >65536
    maximum_display(handles.selected_channel) = 65536;
    
    setappdata(hMainGui, 'maximum_display', maximum_display);
    
    set(handles.maximum_slider, 'Value', maximum_display(handles.selected_channel));
    set(handles.maximum_edit, 'String', maximum_display(handles.selected_channel));
end

%Update brighntess slider. 
set(handles.brightness_slider, 'Value', 0)
set(handles.brightness_slider, 'Max', (minimum_display(handles.selected_channel) + maximum_display(handles.selected_channel))/2)
set(handles.brightness_slider, 'Min', -(abs(2*65536 - minimum_display(handles.selected_channel) - maximum_display(handles.selected_channel)))/2)

%Update brightness minimum and maximum with current display settings. 
handles.brightness_minimum = minimum_display(handles.selected_channel);
handles.brightness_maximum = maximum_display(handles.selected_channel);

%Update contrast slider. 
if maximum_display(handles.selected_channel) - minimum_display(handles.selected_channel) < 2^16
    contrast_value = minimum_display(handles.selected_channel) - maximum_display(handles.selected_channel);
else
    [~,closestIndex] = min(abs(round(handles.contrast_factor.*transpose(2^16:2*2^16))-(maximum_display(handles.selected_channel) - minimum_display(handles.selected_channel))));
    contrast_value = -closestIndex - 2^16;
end
set(handles.contrast_slider, 'Value', contrast_value)

%Plot histogram and current display settings in it. 
hold(handles.axes1,'off')
bar(handles.axes1, handles.bins, handles.bin_values)
hold(handles.axes1,'on')
plot(handles.axes1, [minimum_display(handles.selected_channel); maximum_display(handles.selected_channel)], get(handles.axes1,'YLim'))
set(handles.axes1,'xtick',[],'ytick',[], 'xlim', [handles.lower_limit(handles.selected_channel), handles.upper_limit(handles.selected_channel)])

%Get handles of main GUI. 
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Retrieve display settings. 
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
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function minimum_slider_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes when user changes minimum edit. 
function minimum_edit_Callback(hObject, eventdata, handles)

%Return in case invalid input is give by user. 
if isnan(str2double(get(hObject,'String')))
    return
end

%Get value given by user.. 
minimum = str2double(get(hObject,'String'));

%Minimum cannot be smaller than 1 or larger than 2^16. Correct if needed.
if minimum < 1
    minimum = 1;
    set(handles.minimum_edit, 'String', minimum)
elseif minimum > 65536
    minimum = 65536;
    set(handles.minimum_edit, 'String', minimum)
end

%Update slider and edit with minimum value. 
set(handles.minimum_slider, 'Value', minimum);
set(handles.minimum_edit, 'Value', minimum);

%Retrieve current display settings. 
hMainGui = getappdata(0, 'hMainGui');
minimum_display = getappdata(hMainGui, 'minimum_display');
maximum_display = getappdata(hMainGui, 'maximum_display');

%Update display settings and save in app data. 
minimum_display(handles.selected_channel) = minimum;
setappdata(hMainGui, 'minimum_display', minimum_display);

%Make sure that minimum display value cannot get larger than maximum
%display value, and update maximum display value. 
if minimum_display(handles.selected_channel) > maximum_display(handles.selected_channel)
    maximum_display(handles.selected_channel) = minimum_display(handles.selected_channel);
    
    setappdata(hMainGui, 'maximum_display', maximum_display);   
    
    set(handles.maximum_slider, 'Value', maximum_display(handles.selected_channel));
    set(handles.maximum_edit, 'String', maximum_display(handles.selected_channel));
end

%Make sure that maximum display cannot get larger than 2^16. 
if maximum_display(handles.selected_channel) >65536
    maximum_display(handles.selected_channel) = 65536;
    
    setappdata(hMainGui, 'maximum_display', maximum_display);
    
    set(handles.maximum_slider, 'Value', maximum_display(handles.selected_channel));
    set(handles.maximum_edit, 'String', maximum_display(handles.selected_channel));
end

%Update brightness slider. 
set(handles.brightness_slider, 'Value', 0)
set(handles.brightness_slider, 'Max', (minimum_display(handles.selected_channel) + maximum_display(handles.selected_channel))/2)
set(handles.brightness_slider, 'Min', -(abs(2*65536 - minimum_display(handles.selected_channel) - maximum_display(handles.selected_channel)))/2)

%Update brightness minimum and maximum. 
handles.brightness_minimum = minimum_display(handles.selected_channel);
handles.brightness_maximum = maximum_display(handles.selected_channel);

%Update contrast slider. 
if maximum_display(handles.selected_channel) - minimum_display(handles.selected_channel) < 2^16
    contrast_value = minimum_display(handles.selected_channel) - maximum_display(handles.selected_channel);
else
    [~,closestIndex] = min(abs(round(handles.contrast_factor.*transpose(2^16:2*2^16))-(maximum_display(handles.selected_channel) - minimum_display(handles.selected_channel))));
    contrast_value = -closestIndex - 2^16;
end
set(handles.contrast_slider, 'Value', contrast_value)

%Plot histogram and current display settings in it. 
hold(handles.axes1,'off')
bar(handles.axes1, handles.bins, handles.bin_values)
hold(handles.axes1,'on')
plot(handles.axes1, [minimum_display(handles.selected_channel); maximum_display(handles.selected_channel)], get(handles.axes1,'YLim'))
set(handles.axes1,'xtick',[],'ytick',[], 'xlim', [handles.lower_limit(handles.selected_channel), handles.upper_limit(handles.selected_channel)])

%Get handles of main GUI. 
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Retrieve display settings. 
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
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function minimum_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on maximum slider movement.
function maximum_sliderContValCallback(hObject, eventdata, handles)

%Retrieve handles. 
handles = guidata(hObject);

%Get slider value and update maximum edit accordingly. 
maximum = round(get(hObject,'Value'));
set(handles.maximum_edit, 'String', maximum);

%Retrieve current display settings. 
hMainGui = getappdata(0, 'hMainGui');
maximum_display = getappdata(hMainGui, 'maximum_display');
minimum_display = getappdata(hMainGui, 'minimum_display');

%Update display settings and save in app data. 
maximum_display(handles.selected_channel) = maximum;
setappdata(hMainGui, 'maximum_display', maximum_display);

%Make sure maximum display value cannot be smaller than minimum display
%value (make minimum display value smaller), and update minimum display
%value. 
if maximum_display(handles.selected_channel) < minimum_display(handles.selected_channel)
    minimum_display(handles.selected_channel) = maximum_display(handles.selected_channel);
    
    setappdata(hMainGui, 'minimum_display', minimum_display);   
    
    set(handles.minimum_slider, 'Value', minimum_display(handles.selected_channel));
    set(handles.minimum_edit, 'String', minimum_display(handles.selected_channel));
end

%Make sure that minimum display value cannot be smaller than 1. 
if minimum_display(handles.selected_channel) <1
    minimum_display(handles.selected_channel) = 1;
    
    setappdata(hMainGui, 'minimum_display', minimum_display);
    
    set(handles.minimum_slider, 'Value', minimum_display(handles.selected_channel));
    set(handles.minimum_edit, 'String', minimum_display(handles.selected_channel));
end

%Update brightness slider. 
set(handles.brightness_slider, 'Value', 0)
set(handles.brightness_slider, 'Max', (minimum_display(handles.selected_channel) + maximum_display(handles.selected_channel))/2)
set(handles.brightness_slider, 'Min', -(abs(2*65536 - minimum_display(handles.selected_channel) - maximum_display(handles.selected_channel)))/2)

%Update brightness minimum and maximum accordingly. 
handles.brightness_minimum = minimum_display(handles.selected_channel);
handles.brightness_maximum = maximum_display(handles.selected_channel);

%Update contrast slider. 
if maximum_display(handles.selected_channel) - minimum_display(handles.selected_channel) < 2^16
    contrast_value = minimum_display(handles.selected_channel) - maximum_display(handles.selected_channel);
else
    [~,closestIndex] = min(abs(round(handles.contrast_factor.*transpose(2^16:2*2^16))-(maximum_display(handles.selected_channel) - minimum_display(handles.selected_channel))));
    contrast_value = -closestIndex - 2^16;
end
set(handles.contrast_slider, 'Value', contrast_value)

%Plot histogram and display settings in it. 
hold(handles.axes1,'off')
bar(handles.axes1, handles.bins, handles.bin_values)
hold(handles.axes1,'on')
plot(handles.axes1, [minimum_display(handles.selected_channel); maximum_display(handles.selected_channel)], get(handles.axes1,'YLim'))
set(handles.axes1,'xtick',[],'ytick',[], 'xlim', [handles.lower_limit(handles.selected_channel), handles.upper_limit(handles.selected_channel)])

%Get handles of main GUI. 
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Retrieve display settings. 
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
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function maximum_slider_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes when user changes maximum edit.  
function maximum_edit_Callback(hObject, eventdata, handles)

%Return if invalid value is inserted by user. 
if isnan(str2double(get(hObject,'String')))
    return
end

%Get maximum value given by user. 
maximum = str2double(get(hObject,'String'));

%Make sure that maximum must be between 1 and 2^16, adjust if necesarry. 
if maximum < 1
    maximum = 1;
    set(handles.maximum_edit, 'String', maximum)
elseif maximum > 65536
    maximum = 65536;
    set(handles.maximum_edit, 'String', maximum)
end

%Update maximum slider and edit accordingly. 
set(handles.maximum_slider, 'Value', maximum);
set(handles.maximum_edit, 'Value', maximum);

%Retrieve current display settings. 
hMainGui = getappdata(0, 'hMainGui');
maximum_display = getappdata(hMainGui, 'maximum_display');
minimum_display = getappdata(hMainGui, 'minimum_display');

%Update display settings and save in app data. 
maximum_display(handles.selected_channel) = maximum;
setappdata(hMainGui, 'maximum_display', maximum_display);

%Make sure maximum display value cannot be smaller than minimum display
%value. Update minimum display value if necessary. 
if maximum_display(handles.selected_channel) < minimum_display(handles.selected_channel)
    minimum_display(handles.selected_channel) = maximum_display(handles.selected_channel);
    
    setappdata(hMainGui, 'minimum_display', minimum_display);
    
    set(handles.minimum_slider, 'Value', minimum_display(handles.selected_channel));
    set(handles.minimum_edit, 'String', minimum_display(handles.selected_channel));
end

%Make sure minimum display value cannot be smaller than 1. Correct if
%necessary. 
if minimum_display(handles.selected_channel) <1
    minimum_display(handles.selected_channel) = 1;
    
    setappdata(hMainGui, 'minimum_display', minimum_display);
    
    set(handles.minimum_slider, 'Value', minimum_display(handles.selected_channel));
    set(handles.minimum_edit, 'String', minimum_display(handles.selected_channel));
end

%Update brightness slider. 
set(handles.brightness_slider, 'Value', 0)
set(handles.brightness_slider, 'Max', (minimum_display(handles.selected_channel) + maximum_display(handles.selected_channel))/2)
set(handles.brightness_slider, 'Min', -(abs(2*65536 - minimum_display(handles.selected_channel) - maximum_display(handles.selected_channel)))/2)

%Update brightness minimum and maximum. 
handles.brightness_minimum = minimum_display(handles.selected_channel);
handles.brightness_maximum = maximum_display(handles.selected_channel);

%UPdate contrast slider. 
if maximum_display(handles.selected_channel) - minimum_display(handles.selected_channel) < 2^16
    contrast_value = minimum_display(handles.selected_channel) - maximum_display(handles.selected_channel);
else
    [~,closestIndex] = min(abs(round(handles.contrast_factor.*transpose(2^16:2*2^16))-(maximum_display(handles.selected_channel) - minimum_display(handles.selected_channel))));
    contrast_value = -closestIndex - 2^16;
end
set(handles.contrast_slider, 'Value', contrast_value)

%Plot histogram and display settings in it. 
hold(handles.axes1,'off')
bar(handles.axes1, handles.bins, handles.bin_values)
hold(handles.axes1,'on')
plot(handles.axes1, [minimum_display(handles.selected_channel); maximum_display(handles.selected_channel)], get(handles.axes1,'YLim'))
set(handles.axes1,'xtick',[],'ytick',[], 'xlim', [handles.lower_limit(handles.selected_channel), handles.upper_limit(handles.selected_channel)])

%Get handles of main GUI. 
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Retrieve display settings. 
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
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function maximum_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on brightness slider movement.
function brightness_sliderContValCallback(hObject, eventdata, handles)

%Get handles. 
handles = guidata(hObject);
 
%Retrieve current display settings. 
hMainGui = getappdata(0, 'hMainGui');
maximum_display = getappdata(hMainGui, 'maximum_display');
minimum_display = getappdata(hMainGui, 'minimum_display');

%Get minimum and maximum display values by correcting from brightness
%minimum and maximum. 
minimum_display(handles.selected_channel) =  handles.brightness_minimum - ceil(get(hObject,'Value'));
maximum_display(handles.selected_channel) =  handles.brightness_maximum - floor(get(hObject,'Value'));    

%Update minimum slider and edit. Make sure that minimum has to be between 0
%and 2^16. 
setappdata(hMainGui, 'minimum_display', minimum_display);
if minimum_display(handles.selected_channel)<1
    set(handles.minimum_slider, 'Value', 1);
elseif minimum_display(handles.selected_channel)>65536
    set(handles.minimum_slider, 'Value', 65536);
else
    set(handles.minimum_slider, 'Value', minimum_display(handles.selected_channel));
end
set(handles.minimum_edit, 'String', minimum_display(handles.selected_channel));

%Update maximum slider and edit. Make sure that maximum has to be between 0
%and 2^16. 
setappdata(hMainGui, 'maximum_display', maximum_display);
if maximum_display(handles.selected_channel)<1
    set(handles.maximum_slider, 'Value', 1);
elseif maximum_display(handles.selected_channel)>65536
    set(handles.maximum_slider, 'Value', 65536);
else
    set(handles.maximum_slider, 'Value', maximum_display(handles.selected_channel));
end
set(handles.maximum_edit, 'String', maximum_display(handles.selected_channel));

%Update contrast slider. 
if maximum_display(handles.selected_channel) - minimum_display(handles.selected_channel) < 2^16
    contrast_value = minimum_display(handles.selected_channel) - maximum_display(handles.selected_channel);
else
    [~,closestIndex] = min(abs(round(handles.contrast_factor.*transpose(2^16:2*2^16))-(maximum_display(handles.selected_channel) - minimum_display(handles.selected_channel))));
    contrast_value = -closestIndex - 2^16;
end
set(handles.contrast_slider, 'Value', contrast_value)

%Plot histogram and display settings in it. 
hold(handles.axes1,'off')
bar(handles.axes1, handles.bins, handles.bin_values)
hold(handles.axes1,'on')
plot(handles.axes1, [minimum_display(handles.selected_channel); maximum_display(handles.selected_channel)], get(handles.axes1,'YLim'))
set(handles.axes1,'xtick',[],'ytick',[], 'xlim', [handles.lower_limit(handles.selected_channel), handles.upper_limit(handles.selected_channel)])

%Get handles of main GUI. 
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Retrieve display settings.
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
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function brightness_slider_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




% --- Executes on contrast slider movement.
function contrast_sliderContValCallback(hObject, eventdata, handles)

%Get handles. 
handles = guidata(hObject);

%Get current display settings. 
hMainGui = getappdata(0, 'hMainGui');
maximum_display = getappdata(hMainGui, 'maximum_display');
minimum_display = getappdata(hMainGui, 'minimum_display');

%Get contrast value from slider. Correct for non linear slider (first part
%of slider is bigger steps than second part). 
if -round(get(hObject,'Value')) >2^16
    contrast = round(-handles.contrast_factor(-round(get(hObject,'Value')) - 2^16)*round(get(hObject,'Value'))) - (maximum_display(handles.selected_channel) - minimum_display(handles.selected_channel));
else
    contrast = -round(get(hObject,'Value')) - (maximum_display(handles.selected_channel) - minimum_display(handles.selected_channel));
end

%Update minimum and maximum display values with contrast. Make sure that
%minimum value cannot become larger than maximum value. 
if minimum_display(handles.selected_channel) - round(contrast/2) > maximum_display(handles.selected_channel) + round(contrast/2)
    maximum_display(handles.selected_channel) =  maximum_display(handles.selected_channel) + round(contrast/2);
    minimum_display(handles.selected_channel) =  maximum_display(handles.selected_channel);
else
    maximum_display(handles.selected_channel) =  maximum_display(handles.selected_channel) + round(contrast/2);
    minimum_display(handles.selected_channel) =  minimum_display(handles.selected_channel) - round(contrast/2);
end

%Update minimum slider and edit. Make sure that maximum has to be between 0
%and 2^16. 
setappdata(hMainGui, 'minimum_display', minimum_display);
if minimum_display(handles.selected_channel)<1
    set(handles.minimum_slider, 'Value', 1);
else
    set(handles.minimum_slider, 'Value', minimum_display(handles.selected_channel));
end
set(handles.minimum_edit, 'String', minimum_display(handles.selected_channel));

%Update maximum slider and edit. Make sure that maximum has to be between 0
%and 2^16. 
setappdata(hMainGui, 'maximum_display', maximum_display);
if maximum_display(handles.selected_channel)>65536
    set(handles.maximum_slider, 'Value', 65536);
else
    set(handles.maximum_slider, 'Value', maximum_display(handles.selected_channel));
end
set(handles.maximum_edit, 'String', maximum_display(handles.selected_channel));

%Update brightness slider. 
set(handles.brightness_slider, 'Value', 0)
set(handles.brightness_slider, 'Max', (minimum_display(handles.selected_channel) + maximum_display(handles.selected_channel))/2)
set(handles.brightness_slider, 'Min', -(abs(2*65536 - minimum_display(handles.selected_channel) - maximum_display(handles.selected_channel)))/2)

%Update brightness minimum and maximum. 
handles.brightness_minimum = minimum_display(handles.selected_channel);
handles.brightness_maximum = maximum_display(handles.selected_channel);

%Plot histogram and current display settings in it. 
hold(handles.axes1,'off')
bar(handles.axes1, handles.bins, handles.bin_values)
hold(handles.axes1,'on')
plot(handles.axes1, [minimum_display(handles.selected_channel); maximum_display(handles.selected_channel)], get(handles.axes1,'YLim'))
set(handles.axes1,'xtick',[],'ytick',[], 'xlim', [handles.lower_limit(handles.selected_channel), handles.upper_limit(handles.selected_channel)])

%Get handles of main GUI. 
h = findobj('Tag','Gui1');
g1data = guidata(h);

%Retrieve display settings. 
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
displayim(g1data.Image_combined, g1data.axes8, g1data.x, g1data.y, g1data.frame, g1data.position, g1data.zoomfactor,...
    g1data.num_channels, minimum_display, maximum_display, colour, channels, analysis_visuals, roi_boundaries, peaks,...
    preliminary_tracks, selected_tracks, analysis_metadata{30,2}, segmented_image, colocalization);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function contrast_slider_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
