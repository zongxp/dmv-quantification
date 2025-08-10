function pos_all = get_pos_all(fit_par)
% get all the pos of the matrix
voxSize = fit_par.voxSize;
FOV = fit_par.matrixSize.*voxSize;
nvox=round(FOV./voxSize);

x=linspace(-FOV(2)/2,FOV(2)/2,nvox(2)+1);
y=linspace(-FOV(1)/2,FOV(1)/2,nvox(1)+1);
z=linspace(-FOV(3)/2,FOV(3)/2,nvox(3)+1);
x=x(1:end-1);
y=y(1:end-1);
z=z(1:end-1);
x1=repmat(x,[length(y),1,length(z)]);
y1=repmat(y',[1,length(x),length(z)]);
z1=repmat(reshape(z,[1,1,length(z)]),[length(y),length(x),1]);

pos_all = cat(4,x1,y1,z1);