function [ x,y,z ] =rot(rsat,r0)
we = 7.292115 * 10^-5;
c=299792458;
d=norm(rsat-r0)/c;
t=we*d;
R=[cos(t) sin(t) 0;-sin(t) cos(t) 0;0 0 1];
r=R*rsat';
x=r(1,1);
y=r(2,1);
z=r(3,1);
end

