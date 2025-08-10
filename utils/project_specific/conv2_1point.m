function   res= conv2_1point(kernel,y,p)


     nx=size(y,2);
     ny=size(y,1);
     nz=size(y,3);

     i_img1=1:ny;
     i_img2=1:nx;
     i_img3=1:nz;
     
     %% coordinates of the image after shift p 
     coord1=index2coord(i_img1,p(1),ny);
     coord2=index2coord(i_img2,p(2),nx);
     coord3=index2coord(i_img3,p(3),nz);
 
     nxk=size(kernel,2);
     nyk=size(kernel,1);
     nzk=size(kernel,3);

     %% indices of the kernel at the corresponding image coordinates  
     i_knl1=coord2ind(coord1,0,nyk);
     i_knl2=coord2ind(coord2,0,nxk);
     i_knl3=coord2ind(coord3,0,nzk);

     %% only select image indices that give i_knl within 1:nxk or 1:nyk

     sel1=i_knl1>1 & i_knl1<nyk;
     sel2=i_knl2>1 & i_knl2<nxk;
     sel3=i_knl3>1 & i_knl3<nzk;
     
     frtmp=y(sel1,sel2,sel3);
     
     tmp=kernel(i_knl1(sel1),i_knl2(sel2),i_knl3(sel3)).*frtmp;
    
     res=sum(tmp(:));
     

function coord=index2coord(ind,center,ind_max)
     coord=ind-half2(ind_max)+center;

function ind=coord2ind(coord,center,ind_max)
     ind=coord+half2(ind_max)-center;
