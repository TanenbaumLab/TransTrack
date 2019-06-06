function [intensity, noise_intensity] = intensity_tracker_single_channel(track, image, roisz)

% 
% NAME:
%               displayim
% DESCRIPTION:
%               


%% Intensity Tracker

transposition = [10 0; 10 10; 10 -10; 0 10; 0 -10; -10 0; -10 10; -10 -10];

tracklength = size(track,1);

intensity = nan(tracklength,1);
noise_intensity = nan(tracklength,1);

for i = 1:tracklength
    if isnan(track(i,3))
        intensity(i) = nan;   
        noise_intensity(i) = nan;
    else
        x_low = track(i,3) - floor(roisz/2);
        x_high = track(i,3) + floor(roisz/2);
        y_low = track(i,2) - floor(roisz/2);
        y_high = track(i,2) + floor(roisz/2);
        

        roi1 = image(x_low:x_high, y_low:y_high, track(i,4));
        intensity(i) = mean(mean(roi1));
         
        noise_intensity_temp = ones(8,1);
        k = 0;
        n = 0;
        while n<1 
            k = k+1;
            n = 0;
        
            for j = 1:8
                x_low_t = x_low + k*transposition(j,1);
                x_high_t = x_high + k*transposition(j,1);
                y_low_t = y_low + k*transposition(j,2);
                y_high_t = y_high + k*transposition(j,2); 
                
                if x_low_t < 1
                    noise_intensity_temp(j) = nan;
                elseif x_high_t > size(image,1)
                    noise_intensity_temp(j) = nan;
                elseif y_low_t < 1
                    noise_intensity_temp(j) = nan;
                elseif y_high_t> size(image,2)
                    noise_intensity_temp(j) = nan;
                else
                    roi_noise = image(x_low_t:x_high_t, y_low_t:y_high_t, track(i,4));
        
                    if max(max(roi_noise))> 4*min(min(roi_noise))
                        noise_intensity_temp(j) = nan;
                    else
                        noise_intensity_temp(j) = mean(mean(roi_noise)); 
                        n = n+1;
                    end
                end 
            end
        end
             
        noise_intensity(i) = nanmean(noise_intensity_temp);
    end
end
