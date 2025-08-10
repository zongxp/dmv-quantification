function [path_ind,vessel_ind,fit_ind] = findPathVessel(sub_path,vessel_ind_temp,matsize)
% this function is used for get the new dmv_ind_path and dmv_vessel_ind if
% the tortuosity is bigger than 1.05
path_ind = sub2indb(matsize,sub_path);
test_block_path = zeros(matsize);
test_block_vessel = zeros(matsize);
test_block_path(path_ind) = 1;
test_block_vessel(vessel_ind_temp) = 1;
SE = strel("disk",2);
SE2 = strel("disk",2);
dilated_area = zeros(matsize);
fit_area = zeros(matsize);
axis_dir = findMaxDiffColumn(sub_path);
sub_path = sortrows(sub_path,axis_dir);
if axis_dir == 1
    for i = sub_path(1,axis_dir):sub_path(end,axis_dir)
        dilated_area(i,:,:) =  imdilate(squeeze(test_block_path(i,:,:)),SE);
    end
    if size(sub_path,1) == 2
        temp = sub_path(1,axis_dir);
        fit_area(temp,:,:) = imdilate(squeeze(test_block_path(temp,:,:)),SE2);
    else
        for i = sub_path(2,axis_dir):sub_path(end-1,axis_dir)
            fit_area(i,:,:) =  imdilate(squeeze(test_block_path(i,:,:)),SE2);
        end
    end
elseif axis_dir == 2
    for i = sub_path(1,axis_dir):sub_path(end,axis_dir)
        dilated_area(:,i,:) =  imdilate(squeeze(test_block_path(:,i,:)),SE);
    end
    if size(sub_path,1) == 2
        temp = sub_path(1,axis_dir);
        fit_area(:,temp,:) = imdilate(squeeze(test_block_path(:,temp,:)),SE2);
    else
        for i = sub_path(2,axis_dir):sub_path(end-1,axis_dir)
            fit_area(:,i,:) =  imdilate(squeeze(test_block_path(:,i,:)),SE2);
        end
    end
else
    for i = sub_path(1,axis_dir):sub_path(end,axis_dir)
        dilated_area(:,:,i) =  imdilate(squeeze(test_block_path(:,:,i)),SE);
    end
    if size(sub_path,1) == 2
        temp = sub_path(1,axis_dir);
        fit_area(:,:,temp) = imdilate(squeeze(test_block_path(:,:,temp)),SE2);
    else
        for i = sub_path(2,axis_dir):sub_path(end-1,axis_dir)
            fit_area(:,:,i) =  imdilate(squeeze(test_block_path(:,:,i)),SE2);
        end
    end
end
test_block = test_block_vessel.*dilated_area;
vessel_ind = find(test_block == 1);
fit_ind = find(fit_area == 1);
end



