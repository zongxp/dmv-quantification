function [chunk_vessel,chunk_path,fit_par,fit_ind] = get_cluster_chunk2(matsize,ind_vessel,ind_path,padding_num,phi_img,mag_img,fit_par,fit_ind_temp)
% get the chunk of one vessel cluster
    sub_vessel=ind2subb(matsize,ind_vessel);
    vessel_cluster =  zeros(matsize);
    vessel_cluster(ind_vessel) = 1;
    path_cluster = zeros(matsize);
    path_cluster(ind_path) = 1;
    fit_cluster  = zeros(matsize);
    fit_cluster(fit_ind_temp) = 1;
    
    pos_min_pad = min(sub_vessel,[],1)-padding_num;%1*3
    pos_max_pad = max(sub_vessel,[],1)+padding_num;
    pos_min_pad(pos_min_pad<=0) = 1;
    indd = find(pos_max_pad-matsize>0);
    pos_max_pad(indd) = matsize(indd);
    %dmv path chunk
    chunk_vessel = vessel_cluster(pos_min_pad(1):pos_max_pad(1),pos_min_pad(2):pos_max_pad(2),pos_min_pad(3):pos_max_pad(3));
    chunk_path = path_cluster(pos_min_pad(1):pos_max_pad(1),pos_min_pad(2):pos_max_pad(2),pos_min_pad(3):pos_max_pad(3));
    chunk_fit = fit_cluster(pos_min_pad(1):pos_max_pad(1),pos_min_pad(2):pos_max_pad(2),pos_min_pad(3):pos_max_pad(3));
    %phase image chunk
    chunk_phi = phi_img(pos_min_pad(1):pos_max_pad(1),pos_min_pad(2):pos_max_pad(2),pos_min_pad(3):pos_max_pad(3));
    rad_chunk_phi = chunk_phi*pi/180;
    %mag image chunk
    chunk_mag = mag_img(pos_min_pad(1):pos_max_pad(1),pos_min_pad(2):pos_max_pad(2),pos_min_pad(3):pos_max_pad(3));
    val_wm = mean(chunk_mag(chunk_vessel==0),'all');
    phi_complex = chunk_mag.*exp(1i*rad_chunk_phi);
    
    fit_par.chunk_phi = chunk_phi;
    fit_par.phi_complex = phi_complex;
    fit_par.val_wm = val_wm;
%     fit_par.val_vessel = 17*1e-3;
    fit_ind = find(chunk_fit == 1);
end