% This is a demo for measuring the diameter (radius) of a representative
% DMV extracted from subject DMV_03

mag_file = 'mag_64slice/DMV_03_0000.nii.gz';
phase_file = 'phase_64slice/DMV_03_0001.nii.gz';
mask_file = 'mask_file/mask_demo/DMV_03_vessel_125.nii.gz';

B0 = 7;
voxSize = [0.4297,0.4297,0.4];
TE = 15;
mag_vein = 17*1e-3;

res_final = DMV_Diameter(mag_file,phase_file,mask_file,B0,voxSize,TE,mag_vein);
