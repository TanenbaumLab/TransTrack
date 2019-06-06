function tracks_selected = make_tracks(tracks, image, start_filter, start, last_filter, last, overlap_filter, tracklength_filter, tracklength,...
    presence_filter, presence_channel, presence_threshold, presence_length, fov_filter, fov_channel, fov_selection, fov_threshold)

% 
% NAME:
%               displayim
% DESCRIPTION:
%             

%% Selection of tracks based on initial criteria.

if size(tracks,1) ==0
    tracks_selected = [];
    return
end

num_tracks = max(tracks(:,1));

number = 1;
tracks_initial = [];

%Look per track, if it fullfils the basic requirements to be selected.
for i = 1:num_tracks
    index_min = find(tracks(:,1)==i,1);
    index_max = find(tracks(:,1)==i,1,'last');
    
    track = tracks(index_min:index_max, 2:4);
    
    %Remove if the track ends too early, starts too late or isn'tlong enough.
    if track(end,3) < start && start_filter ==1
    elseif track(1,3) > last && last_filter ==1
    elseif track(1,3) < start && start_filter ==1 && overlap_filter ==0
    elseif track(end,3) > last && last_filter ==1 && overlap_filter ==0
    elseif size(track,1)<tracklength && tracklength_filter ==1
    
    %Remove if the track is at the border of the image.
    elseif sum(track(:,1) <= 20) >0
    elseif sum(track(:,1) >= size(image.channel1,2)-20) >0
    elseif sum(track(:,2) <=20) >0
    elseif sum(track(:,2) >= size(image.channel1,1)-20) >0
        
    %If the GFP track starts before analysis starts, only take the track
    %from the start of the analysis (remove the rest of the track, track
    %should also still be long enough).
    elseif track(1,3)< start && track(end,3)> last && start_filter ==1 && last_filter ==1 && overlap_filter ==1
        ind_start = find(track(:,3)==start);
        ind_last = find(track(:,3)==last);
        
        track = track(ind_start:ind_last,:);
        
        if size(track,1)>=tracklength && tracklength_filter ==1                
            tracknumber = repmat(number, size(track,1),1);
            track = [tracknumber,track];

            tracks_initial = [tracks_initial; track];
            number = number+1;
        elseif tracklength_filter == 0
            tracknumber = repmat(number,size(track,1),1);
            track = [tracknumber,track];

            tracks_initial = [tracks_initial; track];
            number = number+1;
        end
    elseif track(1,3)< start && start_filter ==1 && overlap_filter ==1
        ind_start = find(track(:,3)==start);
        
        track = track(ind_start:end,:);
        
        if size(track,1)>=tracklength && tracklength_filter ==1                
            tracknumber = repmat(number, size(track,1),1);
            track = [tracknumber,track];

            tracks_initial = [tracks_initial; track];
            number = number+1;
        elseif tracklength_filter == 0
            tracknumber = repmat(number,size(track,1),1);
            track = [tracknumber,track];

            tracks_initial = [tracks_initial; track];
            number = number+1;
        end
    elseif track(end,3)> last && last_filter ==1 && overlap_filter ==1
        ind_last = find(track(:,3)==last);
        
        track = track(1:ind_last,:);
        
        if size(track,1)>=tracklength && tracklength_filter ==1                
            tracknumber = repmat(number, size(track,1),1);
            track = [tracknumber,track];

            tracks_initial = [tracks_initial; track];
            number = number+1;
        elseif tracklength_filter == 0
            tracknumber = repmat(number,size(track,1),1);
            track = [tracknumber,track];

            tracks_initial = [tracks_initial; track];
            number = number+1;
        end
    else
        tracknumber = repmat(number,size(track,1),1);
        track = [tracknumber,track];
        
        tracks_initial = [tracks_initial;track];
        number = number+1;
    end    
end

%% Selection of tracks based on advanced criteria.

track_numbers_initial = unique(tracks_initial(:,1));

if presence_filter ==1
    track_numbers_presence = nan(size(track_numbers_initial,1),1);
    image_presence = image.(strcat('channel', num2str(presence_channel)));
    
    for i = 1:size(track_numbers_initial,1)
        index_track = tracks_initial(:,1)==track_numbers_initial(i);
        track = tracks_initial(index_track, 2:4);
        
        presence_temp = zeros(size(track,1),1);
        for j = 1:size(track,1)
            x_low = track(j,2)- 10;
            x_high = track(j,2)+ 10;
            y_low = track(j,1)- 10;
            y_high = track(j,1)+ 10;
            
            ROI = image_presence(x_low:x_high, y_low:y_high, track(j,3));

            %Search for local maxima in mCherry channel in the given box. 
            pk = pkfnd(ROI, presence_threshold, 5);

            %If only one mCherry peak is found in the box. 
            if size(pk,1) >= 1
                %If the spot is close enough and not too bright, it is
                %categorized as an 'on' track.
                distance = sqrt((11 -pk(:,1)).^2 + (11 -pk(:,2)).^2);
                if any(distance<3)
                    presence_temp(j) = 1;
                end
            end
        end
        
        presence_length_track = max(accumarray(nonzeros((cumsum(~presence_temp)+1).*presence_temp),1));
        if presence_length_track >= presence_length
            track_numbers_presence(i) = track_numbers_initial(i);
        end
    end
else
    track_numbers_presence = track_numbers_initial;
end
track_numbers_presence(isnan(track_numbers_presence)) = [];

%%

if fov_filter ==1
    track_numbers_fov = nan(size(track_numbers_initial,1),1);
    image_fov = image.(strcat('channel', num2str(fov_channel)));
    
    se = strel('disk',4,4);
    
    image_temp = nan(size(image_fov,1), size(image_fov,2), 1);
    image_binary = nan(size(image_fov,1), size(image_fov,2), size(image_fov,3));
    for i = 1:size(image_fov,3)
        image_temp(image_fov(:,:,i) > fov_threshold) = 50000;
        image_temp(image_fov(:,:,i) <= fov_threshold) = 0;
        
        image_binary(:,:,i) = imerode(image_temp, se);
        image_binary(:,:,i) = imdilate(image_temp, se);            
    end
    
    for i = 1:size(track_numbers_initial,1)
        index_track = tracks_initial(:,1)==track_numbers_initial(i);
        track = tracks_initial(index_track, 2:4);
                
        if image_binary(track(1,2), track(1,1), track(1,3)) > 0 && fov_selection ==1
            track_numbers_fov(i) = track_numbers_initial(i);
        elseif image_binary(track(1,2),track(1,1),track(1,3)) ==0 && fov_selection ==2
            track_numbers_fov(i) = track_numbers_initial(i);
                            
        end         
    end
else
    track_numbers_fov = track_numbers_initial;
end
track_numbers_fov(isnan(track_numbers_fov)) = [];

%%

track_numbers_selection = intersect(track_numbers_presence, track_numbers_fov);

tracks_selected = [];
number = 1;

for i = 1:size(track_numbers_selection,1)
    index_track = tracks_initial(:,1)==track_numbers_selection(i);
    track = tracks_initial(index_track, 2:4);
       
    tracks_selected = [tracks_selected; repmat(number, size(track,1), 1), track];
    number = number + 1;
end


