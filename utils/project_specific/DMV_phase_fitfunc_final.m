function [res,cmplx_fit]=DMV_phase_fitfunc_final(radius_vessel,mag,x,fit_par,pos_fit,fit_ind)
% x(1)x(2):theta and phi in degree (diraction of the vessel)
% x(3) r_intercept in um (should *1e-6 in fit_vessel_line)
% x(4) an in degree
fit_par.val_wm=mag*1e-3;
pos_fit = fit_vessel_line(x(1),x(2),x(3)*1e-6,x(4),pos_fit);
[cmplx_map,fit_par] = get_complex_map(pos_fit,radius_vessel*1e-6,fit_par,x(1));
cmplx_fit = ComplexImage_phase(cmplx_map,fit_par,fit_ind);
% fprintf('rad = %f\n',radius_vessel);
measured = fit_par.phi_complex(fit_ind);
fitted = cmplx_fit(fit_ind);

meas2=fit_par.chunk_phi*0;
fitted2=meas2;

meas2(fit_ind)=measured;
fitted2(fit_ind)=fitted;
resid = measured - fitted;
res = double([real(resid(:));imag(resid(:))]);








