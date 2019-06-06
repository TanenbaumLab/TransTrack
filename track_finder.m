function [track_selected, track_number] = track_finder(tracks, x_start, y_start, t_start)

% 
% NAME:
%               displayim
% DESCRIPTION:
%             

%%

coordinates = [x_start, y_start, t_start];

distance = abs(bsxfun(@minus,tracks(:,2:4),coordinates));
similarity = sum(distance,2); 

index_similar = similarity == min(similarity);

track_number = tracks(index_similar,1);

if size(track_number,1) == 1
    index_track = tracks(:,1) == track_number;
    track_selected = tracks(index_track,2:4);
    
elseif all(track_number == track_number(1))
    index_track = tracks(:,1) == track_number(1);
    track_selected = tracks(index_track,2:4);
    
    track_number = track_number(1);
else
    warndlg('Multiple tracks found', 'Error'); 
    
    track_selected = [];
    track_number = [];
end

end