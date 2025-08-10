function res = ComplexImage_phase(phi_map,fit_par,fit_ind)
voxSize = fit_par.voxSize;
% voxSize_interp = fit_par.voxSize_new;
interp = fit_par.interp;
nvox = fit_par.nvox;
matrixSize = fit_par.matrixSize;
kernel_range = fit_par.size_map;
nvox_y = nvox(1);
nvox_x = nvox(2);
nvox_z = nvox(3);
step = fit_par.voxSize_new;
kernel = PSF(voxSize,matrixSize.*voxSize,step,kernel_range);
res=zeros(nvox);
% voxNumy = 1:nvox_y;
% voxNumx = 1:nvox_x;
% voxNumz = 1:nvox_z;
% [Y,X,Z] = meshgrid(voxNumy,voxNumx,voxNumz);
% cal_point = [Y(:),X(:),Z(:)];
cal_point = ind2subb(nvox,fit_ind);
cal_point = repmat(nvox,size(cal_point,1),1)-cal_point+1;
tmp = zeros(1,size(cal_point,1));
num_point = size(cal_point,1);
parfor i = 1:num_point
    current_cal_point = cal_point(i,:);
    %coordinate of the point where image intensity should be calculated;
    %(center at 0)
    p_y=(current_cal_point(1)-half2(nvox_y))*interp;
    p_x=(current_cal_point(2)-half2(nvox_x))*interp;
    p_z=(current_cal_point(3)-half2(nvox_z))*interp;
    tmp(i) = conv2_1point(kernel,phi_map,[p_y,p_x,p_z]);
%     res(nvox(1)-current_cal_point(1)+1,nvox(2)-current_cal_point(2)+1,nvox(3)-current_cal_point(3)+1) = tmp;
end
for i = 1:num_point
    current_cal_point = cal_point(i,:);
    res(nvox(1)-current_cal_point(1)+1,nvox(2)-current_cal_point(2)+1,nvox(3)-current_cal_point(3)+1) = tmp(i);
end
%% no parfor version
% for i=1:nvox(1)
%     for j=1:nvox(2)
%         for k=1:nvox(3)
%             %coordinate of the point where image intensity should be calculated;
%             %(center at 0)
%             p(1)=(i-half2(nvox(1)))*interp;
%             p(2)=(j-half2(nvox(2)))*interp;
%             p(3)=(k-half2(nvox(3)))*interp;
%             res(nvox(1)-i+1,nvox(2)-j+1,nvox(3)-k+1)=conv2_1point(kernel,phi_map,p);%may have problem
%         end
%     end
% end
% phi = angle(res)*180/pi;
end