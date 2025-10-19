function [E,A] = G2LG(rsat,rrec,phi,lan );
% phi=deg2rad(phi);
% lan=deg2rad(lan);
e=[-sind(lan) , cosd(lan),0];
n=[- cosd(lan)*sind(phi),- sind(lan)*sind(phi),cosd(phi)];

u=[cosd(lan)*cosd(phi),sind(lan)*cosd(phi),sind(phi)];

ro=(rsat-rrec)/(norm(rsat-rrec));
p1=sum(ro.*u);
E=asin(p1);
p2=sum(ro.*e);
p3=sum(ro.*n);
A=atan2(p2,p3);
end

