function res_final = DMV_Diameter(mag_file,phase_file,mask_file,B0,voxSize,TE,mag_vein)
%   main function for the measurement of DMV diameter
%   input:
%       mag_file   - nii.gz file of GRE magnitude image
%       phase_file - nii.gz file of GRE phase image
%       mask_file  - nii.gz file of the mask of DMVs
%       B0         - the main magnetic field (uint in T)
%       voxSize    - the voxel size of the GRE image (unit in mm)
%       TE         - the echo time (unit in ms)
%       mag_vein   - the mean magnitude within the DMV (this can be estimated from the signal intensity of a larger vein) 
%   output:
%       The output will be saved in res_vessel.mat with the following format:
%       Column 1:   Vessel index
%       Column 2:   fitted DMV radius
%       Column 3:   fitted white matter intensity
%       Column 4-7: fitted spatial parameters of the DMV center path

%% Loading Data and set parameter
info_phase = load_untouch_niigz(phase_file);
info_mag = load_untouch_niigz(mag_file);
info_mask = load_untouch_niigz(mask_file);
phase_img = double(info_phase.img);
phase_img = normalization(phase_img,-180,180);
mag_img = double(info_mag.img);
% mag_img = max(mag_img,[],'all')-mag_img;
mask_img = info_mask.img;

fit_par.B0 = B0;%T
fit_par.matrixSize = size(mag_img);
fit_par.voxSize = voxSize*1e-3;%m
fit_par.gamma = 26.7519*1e7; %gyromagnetic ratio (rad/s/T)
fit_par.TE = TE*1e-3;%s
fit_par.mu0 = 4*pi*1e-7;%H/s
fit_par.interp = 10;
fit_par.chi = 0.41e-6;%ppm
fit_par.val_vessel = mag_vein;

%% Starting the nonlinear fitting to obtain DMV diameter
nvox_path = 3;
[dmv,~,~]=PVSPath(mask_img,nvox_path);
padding_num = 2; % padding scale of the chunk
for i = 1:size(dmv,2)
    dmv_path_sub = dmv(i).sub_ind_path;
    pos_all = get_pos_all(fit_par);
    % get the longest straight part of a certain DMV and extract the DMV chunk
    straight_test_temp = fitStraightLine(dmv_path_sub,pos_all);
    if straight_test_temp <= 0.5
        dmv_path_ind = dmv(i).i_ind_path;% the ind of a certain dmv
        dmv_vessel_ind = dmv(i).ind;
        [chunk_vessel,chunk_path,fit_par] = get_cluster_chunk(size(mag_img),dmv_vessel_ind,dmv_path_ind,padding_num,phase_img,mag_img,fit_par);
        SE = strel("sphere",2);
        fit_area = imdilate(chunk_path,SE);
        fit_ind = find(fit_area ==1);
    else
        dmv_path_sub_new = findBestSegment3(dmv_path_sub,pos_all,0.5);
        dmv_vessel_ind_temp = dmv(i).ind;
        [dmv_path_ind,dmv_vessel_ind,fit_ind_temp] = findPathVessel(dmv_path_sub_new,dmv_vessel_ind_temp,size(mag_img));
        [chunk_vessel,chunk_path,fit_par,fit_ind] = get_cluster_chunk2(size(mag_img),dmv_vessel_ind,dmv_path_ind,padding_num,phase_img,mag_img,fit_par,fit_ind_temp);
    end
%     test(i,:) = [size(dmv_path_sub,1),length(dmv_path_ind)];

    % Get ini parameter of the DMV path line
    [theta,phi_line,r_intercept,an,pos_fit,fit_par] = get_ini_para2(chunk_vessel,chunk_path,fit_par);
    % Perpare for the fitting
    pos = [theta,phi_line,r_intercept*1e6,an];
    fitfunc2 = @(x) DMV_phase_fitfunc_final(x(1),x(2),x(3:6),fit_par,pos_fit,fit_ind);
    options=prep_options;
    
    x = [90,fit_par.val_wm,pos];
    lb = [20,30,-180,-180,pos(3)-500,-180];
    ub = [200,90,180,180,pos(3)+500,180];
    
    res=lsqnonlin(fitfunc2,x,lb,ub,options);
    res_all(i,:) = res;
    vessel_ind(i) = i;
    res_final = cat(2,vessel_ind',res_all);
    disp(['vessel ',num2str(i),' is calculated,'])
    save('res_vessel.mat','res_final');
end