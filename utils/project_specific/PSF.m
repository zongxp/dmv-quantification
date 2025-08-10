function res=PSF(voxSize_acq,FOV,step,kernel_range)
    kmax=pi./voxSize_acq;
    x0=linspace(-FOV(2)/2,FOV(2)/2,FOV(2)/step(2)+1);%step(2) instead of step
    y0=linspace(-FOV(1)/2,FOV(1)/2,FOV(1)/step(1)+1);%step(1) instead of step
    z0=linspace(-FOV(3)/2,FOV(3)/2,FOV(3)/step(3)+1);%step(3) instead of step
    x0=x0(1:end-1);
    y0=y0(1:end-1);
    z0=z0(1:end-1);
    Nx = size(x0,2);
    Ny = size(y0,2);
    Nz = size(z0,2);
    
%     x=repmat(x0,[length(y0),1,length(z0)]);
%     y=repmat(y0',[1,length(x0),length(z0)]);
%     z=repmat(reshape(z0,[1,1,length(z0)]),[length(y0),length(x0),1]);

%     sinc_x = sinc2(size(x,2),kmax(2),x);
%     sinc_y = sinc2(size(y,1),kmax(1),y);
%     sinc_z = sinc2(size(z,3),kmax(3),z);
    sinc_x = sinc2(Nx,kmax(2),x0);
    sinc_y = sinc2(Ny,kmax(1),y0);
    sinc_z = sinc2(Nz,kmax(3),z0);
    %crop kernel
%     sinc_x = sinc_x((half2(Nx)-kernel_range(2)):(half2(Nx)+kernel_range(2)));
%     sinc_y = sinc_y((half2(Ny)-kernel_range(1)):(half2(Ny)+kernel_range(1)));
%     sinc_z = sinc_z((half2(Nz)-kernel_range(3)):(half2(Nz)+kernel_range(3)));
    sinc_x = sinc_x((half2(Nx)-20):(half2(Nx)+20));
    sinc_y = sinc_y((half2(Ny)-20):(half2(Ny)+20));
    sinc_z = sinc_z((half2(Nz)-20):(half2(Nz)+20));
    %repmat
    kernel_x = repmat(sinc_x,[length(sinc_y),1,length(sinc_z)]);
    kernel_y = repmat(sinc_y',[1,length(sinc_x),length(sinc_z)]);
    kernel_z = repmat(reshape(sinc_z,[1,1,length(sinc_z)]),[length(sinc_y),length(sinc_x),1]);
    res = (kernel_x/max(kernel_x,[],'all')).*(kernel_y/max(kernel_y,[],'all')).*(kernel_z/max(kernel_z,[],'all'));
%     sumRes = (squeeze(sum(res,[1,2])))';
%     sumRes_repmat=repmat(reshape(sumRes,[1,1,length(sumRes)]),[size(res,1),size(res,2),1]);
%     res = res./sumRes_repmat;

end

function psfkernel = sinc2(N,k,x)
i=find(x==0);                                                              
x(i)= 1;      % From LS: don't need this is /0 warning is off    
psfkernel = sin(N*k/N.*x)./sin(k/N.*x)*k/N/pi;
psfkernel(i) = k/pi;  
end