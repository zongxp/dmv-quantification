function middle_pos = get_middle_point(pos)
% get the pos of the centre between two neighbour voxel
    middle_pos = zeros((size(pos,1)-1),size(pos,2));
    for  i = 1:(size(pos,1)-1)
        middle_pos(i,:) = (pos(i+1,:)+pos(i,:))./2;
    end
end