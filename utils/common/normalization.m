function  y  = normalization(x,ymin,ymax)
% x: origin data
% ymin/ymax: expected range

xmax = double(max(x,[],'all'));
xmin = double(min(x,[],'all'));
y = (ymax-ymin)*(x-xmin)./(xmax-xmin) + ymin;

end