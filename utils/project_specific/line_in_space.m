function [intercept,n]=line_in_space(r,an,th,phi)

% A line defined by 1) direction n and 2) the intercept of the line in the plane that goes
% through origin and perpendicular to n. The coordinates of the line
% are given by n*l+intercept, where l takes values in [-inf, inf].
% n is parallel to the direction defined by th and phi.  The line is obtained by rotating the line [r*cos(an),r*sin(an),l] 
% by m returned from transform_matrix_rotation(theta,phi).
%
% Note: th,phi can be obtained from n by unitVec2thetaPhi(n);
%        r can be obtained by the distance to origin of the projections of the line
%        on the normal plane that go through origin.  For example, for a
%        point in the line with coordinates pos, the distance can be
%        obtained by r=sos(pos-sum(pos.*n)*n,2);
%        With known th, phi, and r, an can be obtained using the following code 
%        fitfunc=@(x) vec(line_in_space(r,x(1),th,phi)-r);
%        a=optimoptions('lsqnonlin','Display','none');
%        an=lsqnonlin(fitfunc,0,[],[],a);

n=thetaPhi2unitVec(th,phi,1);

m=transform_matrix_rotation(th,phi);

a=an*pi/180;

intercept=m*[r*cos(a);r*sin(a);0];
% res = 1e3*(vec(intercept)-real');
end








