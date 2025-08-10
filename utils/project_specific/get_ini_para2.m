function [theta,phi,r,an,pos_fit,fit_par] = get_ini_para2(chunk_vessel,chunk_path,fit_par)
interp = fit_par.interp;
voxSize = fit_par.voxSize;
FOV = size(chunk_vessel).*voxSize;
nvox=round(FOV./voxSize);
fit_par.nvox = nvox;


x=linspace(-FOV(2)/2,FOV(2)/2,nvox(2)+1); 
y=linspace(-FOV(1)/2,FOV(1)/2,nvox(1)+1);
z=linspace(-FOV(3)/2,FOV(3)/2,nvox(3)+1);
x=x(1:end-1);
y=y(1:end-1);
z=z(1:end-1);
x1=repmat(x,[length(y),1,length(z)]);
y1=repmat(y',[1,length(x),length(z)]);
z1=repmat(reshape(z,[1,1,length(z)]),[length(y),length(x),1]);

x0=linspace(-FOV(2)/2,FOV(2)/2,nvox(2)*interp+1); 
y0=linspace(-FOV(1)/2,FOV(1)/2,nvox(1)*interp+1);
z0=linspace(-FOV(3)/2,FOV(3)/2,nvox(3)*interp+1);
x0=x0(1:end-1);
y0=y0(1:end-1);
z0=z0(1:end-1);

% x_interp=repmat(x0,[length(y0),1,length(z0)]);
% y_interp=repmat(y0',[1,length(x0),length(z0)]);
% z_interp=repmat(reshape(z0,[1,1,length(z0)]),[length(y0),length(x0),1]);

x_new = normalization(x0,min(x),max(x));
y_new = normalization(y0,min(y),max(y));
z_new = normalization(z0,min(z),max(z));
x_interp_new=repmat(x_new,[length(y_new),1,length(z_new)]);
y_interp_new=repmat(y_new',[1,length(x_new),length(z_new)]);
z_interp_new=repmat(reshape(z_new,[1,1,length(z_new)]),[length(y_new),length(x_new),1]);

pos_all = cat(4,x1,y1,z1);
% pos_all_interp = cat(4,x_interp,y_interp,z_interp);
pos_all_interp_new = cat(4,x_interp_new,y_interp_new,z_interp_new);
% sub_vessel_path = ind2subb(size(chunk_vessel),find(chunk_vessel==1))*interp;
sub_vessel = ind2subb(size(chunk_vessel),find(chunk_vessel==1));
sub_path = ind2subb(size(chunk_path),find(chunk_path==1));
pos_vessel = zeros(size(sub_vessel,1),3);
pos_path = zeros(size(sub_path,1),3);

% dmv sub to pos
for i = 1:size(sub_vessel,1)
%     pos_vessel(i,:) = (squeeze(pos_all_interp(sub_vessel_path(i,1),sub_vessel_path(i,2),sub_vessel_path(i,3),:)))';
    pos_vessel(i,:) = (squeeze(pos_all(sub_vessel(i,1),sub_vessel(i,2),sub_vessel(i,3),:)))';
end
for i = 1:size(sub_path,1)
    pos_path(i,:) = (squeeze(pos_all(sub_path(i,1),sub_path(i,2),sub_path(i,3),:)))';
end
    
% pos_fit_interp = reshape(pos_all_interp,[numel(pos_all_interp)/3,3]);
pos_fit_interp_new = reshape(pos_all_interp_new,[numel(pos_all_interp_new)/3,3]);
pos_fit.pos_fit_interp = pos_fit_interp_new;
pos_fit.pos_vessel_real = pos_vessel;
pos_fit.size_interp = size(pos_all_interp_new);
pos_fit.pos_path = pos_path;

fit_par.voxSize_new = [x_new(2)-x_new(1),y_new(2)-y_new(1),z_new(2)-z_new(1)];


%%
a = pca(pos_vessel);
n = a(:,1)';
[theta,phi] = unitVec2thetaPhi(n');
for i = 1:size(pos_vessel,1)
    r0(i,:) = pos_vessel(i,:)-sum(pos_vessel(i,:).*n)*n;
end
intercept = mean(r0);
r = mean(sos(r0,2));

fitfunc=@(x)1e3*vec(line_in_space(r,x(1),theta ,phi)-intercept');
a=optimoptions('lsqnonlin');
an=lsqnonlin(fitfunc,0,[],[],a);
% [res,intercept1]=line_in_space(r,an,theta,phi,intercept);
end

% test = angle(phi_map)*180/pi;
% rad_ind = find(test == 0);
% for i =1:size(rad_ind,1)
%     pos_rad(i,:) = pos_fit.pos_fit_interp(rad_ind(i),:);
% end
    
