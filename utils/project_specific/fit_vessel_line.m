function pos_fit = fit_vessel_line(theta,phi,r,an,pos_fit)
% A line defined by 1) direction n and 2) the intercept of the line in the plane that goes
% through origin and perpendicular to n. The coordinates of the line
% are given by 
% n*l+intercept, where l takes values in [-inf, inf].

% pos_vessel_real = pos_fit.pos_vessel_real;
pos_path = pos_fit.pos_path;
[intercept,n]=line_in_space(r,an,theta,phi);

% Projection of the two endpoints voxel onto the fitted line
l_min = dot((pos_path(1,:)'-intercept), n') / norm(n')^2;  
l_max = dot((pos_path(end,:)'-intercept), n') / norm(n')^2;

l_range = linspace(l_min,l_max,50);

for i = 1:size(l_range,2)
    pos_vessel(i,:) = n*l_range(i)+intercept';
end
pos_vessel_interp_center = get_middle_point(pos_vessel);
pos_fit.pos_vessel_interp_fit = pos_vessel;
pos_fit.pos_vessel_interp_center = pos_vessel_interp_center;
end