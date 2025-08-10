function [phi_map,fit_par] = get_complex_map(pos_fit,vessel_radius,fit_par,theta)
%chi:ppm:
%vessel_radius:m
vessel_radius_real = vessel_radius;
chi = fit_par.chi;
TE = fit_par.TE;
B0 = fit_par.B0;
mu0 = fit_par.mu0;
gamma = fit_par.gamma;
% interp = fit_par.interp;
chi_s = chi*pi*(vessel_radius_real^2);

[H_map,mag] = get_B_field(pos_fit,vessel_radius_real,fit_par,chi_s);

phi_map_ini = mu0*H_map*TE*gamma;
phi_map_ini(H_map == 0) = B0*chi*(3*(cos(theta*pi/180)^2)-1)/6*TE*gamma;
mag(H_map == 0)=fit_par.val_vessel;
% save_nii(make_nii(phi_map_ini),'phi.nii');
% mag_interp = double(imresize3(chunk_mag,interp));
% phi_map = mag_interp.*exp(1i*phi_map_ini);
phi_map = mag.*exp(1i*phi_map_ini);
fit_par.size_map = size(phi_map);
end