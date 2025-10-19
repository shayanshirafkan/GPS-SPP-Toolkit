function [ curvlinear] =curv(b,c,h )
a = 6378137;
e = 8.1819190842622e-2;
% phi=[i b c]
% landa=[d y f]
% phi=dms2degrees(phi)
% landa=dms2degrees(landa)
N=(a/sqrt(1-e^2*(sin(b))^2));
curvlinear=[(N+h)*cos(b)*cos(c),(N+h)*cos(b)*sin(c),(N*(1-e^2)+h)*sin(b)];
end

