function [ROH ] = ROH(x1,y1,z1,x2,y2,z2 )
% x1=r0(1,1);
% x2=r0(1,2);
% y1=r0(1,3);
% y2=rasat(i,1);
% z1=rasat(i,2);
% z2=rasat(i,3);
ROH=sqrt((x1-x2)^(2)+(y1-y2)^(2)+(z1-z2)^(2))
end

