function [B,mag_map] = get_B_field(pos_fit,fit_rad,fit_par,chi_s)

B0 = fit_par.B0;
mu0 = fit_par.mu0;
val_wm = fit_par.val_wm;
% val_vessel = fit_par.val_vessel;

pos_fit_interp = pos_fit.pos_fit_interp;
pos_vessel = pos_fit.pos_vessel_interp_fit;
matsize = pos_fit.size_interp;
pos_vessel_interp_center = pos_fit.pos_vessel_interp_center;


B = zeros(matsize(1),matsize(2),matsize(3));
% B_all = zeros(matsize(1),matsize(2),matsize(3),size(pos_vessel_interp_center,1));
mag_map = ones(matsize(1),matsize(2),matsize(3)).*val_wm;
m = chi_s*B0/mu0*sos(diff(pos_vessel));
vessel_point = [];
%%
%ltime=tic;
for i = 1:size(pos_vessel_interp_center,1)
    
    pos_dist = pos_fit_interp-pos_vessel_interp_center(i,:);
    r = sos(pos_dist,2);
    
    val_cos = (pos_dist(:,3))./r;
    val_B = m(i).*(3*val_cos.^2-1)./(4*pi*(r.^3));
    vessel_point = [vessel_point,find(r<=fit_rad)'];
    B = B+reshape(val_B,size(B));
    %     B_all(:,:,:,i) = reshape((m(i).*(3*val_cos.^2-1)./(4*pi*(r.^3))),size(B));
    %time_left(i,size(pos_vessel_interp_center,1),toc(ltime));
end
B(unique(vessel_point)) = 0;
% B = sum(B_all,4);

%%
%{
ltime=tic;
for i = 1:size(pos_fit_interp,1)
    
    pos_dist = pos_fit_interp(i,:)-pos_vessel_interp_center;
    r = sos(pos_dist,2);
    if any(r <= fit_rad) % only claculate the voxel outside the fit_rad
        mag_map(i) = val_vessel;
        continue
    end
    val_cos = (pos_dist(:,3))./r;
    B(i) = sum(m.*(3*val_cos.^2-1)./(4*pi*(r.^3)));
    if mod(i,10000)==0
        time_left(i,size(pos_fit_interp,1),toc(ltime));
    end

end
%}  
    