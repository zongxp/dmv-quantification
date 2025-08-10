function best_segment = findBestSegment3(sub_path_temp,pos_all,th)  
    % sub_path_temp - Nx3 pos of th vessel path  
    % voxsize
      
    N = size(sub_path_temp, 1); 
    best_segment = []; 
    max_length = 0; 
      
    for start_idx = 1:N-1 % go through all the start points
        current_segment = sub_path_temp(start_idx, :); % current start point 
        current_length = 1; % current segment length
          
        for end_idx = start_idx+1:N % all the possible endpoints  
            % add points
            current_segment = [current_segment; sub_path_temp(end_idx, :)];  
            current_length = current_length + 1;  
              
            %  tortuosity check
            if fitStraightLine(current_segment,pos_all) <= th
                % if longer 
                if current_length > max_length  
                    max_length = current_length;  
                    best_segment = current_segment;  
                end  
            else  
                % if tortuosity>1.05
                break;  
            end  
        end  
    end  
end
