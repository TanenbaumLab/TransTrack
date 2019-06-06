function displayim(IM,axes, x , y, frame, position, zoomfactor, num_channels, minimum, maximum, colour, channels, analysis_visuals, roi_boundaries, peaks, preliminary_tracks, selected_tracks, segmented_channel, segmented_image, colocalization)
% 
% NAME:
%               displayim
% DESCRIPTION:
%               

%% Switching on/off the channels in the frame, and adjusting its brightness. 

%Pre-allocate image matrix.
data = zeros(size(IM.channel1.num1,1),size(IM.channel1.num1,2),3, 'uint16');

%Make sure that minimum and maximum display values for all channels are
%between 1 and 2^16 and that maximum is larger than minimum. 
for i = 1:num_channels
    if minimum(i) <1
        minimum(i) = 1;
    end
    if maximum(i) >65536
        maximum(i) = 65536;
    end
    if minimum(i) == maximum(i)
        maximum(i) = minimum(i) + 1;
    end
end

for i = 1:num_channels
    if analysis_visuals(6) ==1 && segmented_channel ==i && ~isempty(segmented_image.(strcat('num', num2str(position))))
        %In case user wants to display the segmented image. 
        temp = double(segmented_image.(strcat('num', num2str(position)))(:,:,frame));
    else
        %In case user wants to display the normal image.
        temp = channels(i).*double(IM.(strcat('channel',num2str(i))).(strcat('num',num2str(position)))(:,:,frame));
        
        %Adjust the values of the channel for minimum and maximum display values. 
        temp = (temp - minimum(i))./(maximum(i) - minimum(i));     
        temp(temp<0) = 0;
    end
        
    %Fill image matrix (RGB format) according to channel colour (distribute
    %along the RGB channels depending on the colour). 
    data(:,:,1) = data(:,:,1)  + uint16(65536.*colour(i,1).*temp);
    data(:,:,2) = data(:,:,2)  + uint16(65536.*colour(i,2).*temp);
    data(:,:,3) = data(:,:,3)  + uint16(65536.*colour(i,3).*temp);
end

%Display the image. 
cla(axes,'reset')
imshow(data, 'Parent', axes);

%Zoom in the image according to the zoomfactor and the positioning (x,y).
cax = axis(axes);
daxX = (cax(2)-cax(1))/zoomfactor/2;
daxY = (cax(4)-cax(3))/zoomfactor/2;
axis(axes,[x+[-1 1]*daxX y+[-1 1]*daxY]);

%Get visible range for x and y axis
x_range = x+[-1 1]*daxX;
y_range = y+[-1 1]*daxY;

%% Overlaying the different tracks on the current frame. 

%Show ROIs
if size(roi_boundaries.(strcat('num', num2str(position))),2)>0 && analysis_visuals(1) ==1
    hold(axes,'on')

    for i = 1:size(roi_boundaries.(strcat('num', num2str(position))),2)
        x1 = roi_boundaries.(strcat('num', num2str(position))){i}(:,1);
        y1 = roi_boundaries.(strcat('num', num2str(position))){i}(:,2);
       
        plot(y1,x1, 'b', 'Parent', axes);
        text('units','normalized','color', 'white', 'position',[max((y1 -x_range(1))/(x_range(2) - x_range(1))) 1-min((x1- y_range(1))/(y_range(2) - y_range(1)))],'fontsize',12,'string',strcat('ROI',num2str(i)), 'Parent', axes);
    end
    
    hold(axes,'off')
end

%Show peaks
if size(peaks.(strcat('num', num2str(position))),1)>0 && analysis_visuals(2) ==1
    hold(axes,'on')
    
    for j = 1:size(peaks.(strcat('num', num2str(position))){frame},1)
        x2 = peaks.(strcat('num', num2str(position))){frame}(j,1);
        y2 = peaks.(strcat('num', num2str(position))){frame}(j,2);
        
        plot(x2, y2, 'marker', 'o', 'markersize', 20, 'MarkerEdgeColor', 'm', 'Parent', axes);
    end
    
    hold(axes,'off')
end

%Show preliminary tracks. 
if size(preliminary_tracks.(strcat('num', num2str(position))),1)>0 && analysis_visuals(3) ==1
    hold(axes,'on')

    track_number = preliminary_tracks.(strcat('num', num2str(position)))(preliminary_tracks.(strcat('num', num2str(position)))(:,4)==frame,1);
    
    for j = 1:size(track_number,1)
        index_track = find(preliminary_tracks.(strcat('num', num2str(position)))(:,1)==track_number(j));
        index_max = find(preliminary_tracks.(strcat('num', num2str(position)))(index_track,4)==frame);
                
        x3 = preliminary_tracks.(strcat('num', num2str(position)))(index_track(1:index_max),2);
        y3 = preliminary_tracks.(strcat('num', num2str(position)))(index_track(1:index_max),3);
                
        plot(x3, y3, 'b', 'Parent', axes);
    end
    
    hold(axes,'off')
end

%Show selected tracks. 
if size(selected_tracks.(strcat('num', num2str(position))),1)>0 && analysis_visuals(4) ==1
    hold(axes,'on')
    
    index_tracks = find(selected_tracks.(strcat('num', num2str(position)))(:,4)==frame);
    
    for j = 1:size(index_tracks,1)
        x4 = selected_tracks.(strcat('num', num2str(position)))(index_tracks(j),2);
        y4 = selected_tracks.(strcat('num', num2str(position)))(index_tracks(j),3);
        
        plot(x4, y4, 'marker', 'o', 'markersize', 20, 'MarkerEdgeColor', 'g', 'Parent', axes);
    end
    
    hold(axes,'off')
end

%Show the tracknumber of each track
if size(selected_tracks.(strcat('num', num2str(position))),1)>0 && analysis_visuals(5) ==1
    hold(axes,'on')
    
    index_tracks = find(selected_tracks.(strcat('num', num2str(position)))(:,4)==frame);
      
    for j = 1:size(index_tracks,1)
        tracknumber = selected_tracks.(strcat('num', num2str(position)))(index_tracks(j),1);
        
        x5 = (selected_tracks.(strcat('num', num2str(position)))(index_tracks(j),2) - x_range(1))/(x_range(2) - x_range(1));
        y5 = 1 - (selected_tracks.(strcat('num', num2str(position)))(index_tracks(j),3) - y_range(1))/(y_range(2) - y_range(1));
        
        text('units','normalized','color', 'white', 'position',[x5+0.02 y5+0.02],'fontsize',12,'string',num2str(tracknumber), 'Parent', axes);
    end
 
    hold(axes,'off')
end

%Show if there is colocalization for each track
if size(selected_tracks.(strcat('num', num2str(position))),1)>0 && analysis_visuals(7) ==1 && ~isempty(colocalization.(strcat('num', num2str(position))))
    hold(axes,'on')
    
    index_tracks = find(selected_tracks.(strcat('num', num2str(position)))(:,4)==frame);
       
    for j = 1:size(index_tracks,1)
        x6 = selected_tracks.(strcat('num', num2str(position)))(index_tracks(j),2);
        y6 = selected_tracks.(strcat('num', num2str(position)))(index_tracks(j),3);
        
        if colocalization.(strcat('num', num2str(position)))(selected_tracks.(strcat('num', num2str(position)))(index_tracks(j),1)) == 1
            plot(x6,y6,'marker','.','markersize',15, 'MarkerEdgeColor', 'g', 'Parent', axes);
        else
            plot(x6,y6,'marker','.','markersize',15, 'MarkerEdgeColor', 'r', 'Parent', axes);
        end
    end
    hold(axes,'off')
end
