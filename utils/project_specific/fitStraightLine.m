function res = fitStraightLine(sub_vessel,pos_all)

pos_vessel = zeros(size(sub_vessel,1),3);

% dmv sub to pos
for i = 1:size(sub_vessel,1)
%     pos_vessel(i,:) = (squeeze(pos_all_interp(sub_vessel_path(i,1),sub_vessel_path(i,2),sub_vessel_path(i,3),:)))';
    pos_vessel(i,:) = (squeeze(pos_all(sub_vessel(i,1),sub_vessel(i,2),sub_vessel(i,3),:)))';
end

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
a=optimoptions('lsqnonlin','Display','none');
an=lsqnonlin(fitfunc,0,[],[],a);
% [res,intercept1]=line_in_space(r,an,theta,phi,intercept);
%%
[intercept_new,n_new] = line_in_space(r,an,theta,phi);
for i = 1:size(pos_vessel, 1)
    point = pos_vessel(i,:);
    l = dot((pos_vessel(i,:)'-intercept_new), n_new') / norm(n_new')^2;
    pos_fit = n_new*l+intercept_new';
    distance2(i) = norm(point-pos_fit);
end
% res = mean(res_all(:));
% res = mean(distance2(:))*1000;
res = max(distance2(:))*1000;
% % Projection of the two endpoints voxel onto the fitted line
% l_min = dot((pos_vessel(1,:)'-intercept'), n') / norm(n')^2;  
% l_max = dot((pos_vessel(end,:)'-intercept'), n') / norm(n')^2;
% 
% l_range = linspace(l_min,l_max,50);
% 
% for i = 1:size(l_range,2)
%     pos_fit(i,:) = n*l_range(i)+intercept;
% end


    
