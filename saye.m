function [m ] = saye( rsat,tr,tmn1,tmn2 )
ae=6378.1*10^(3);
% tmn1 = juliandate(datetime('2015-03-15 00:00:00')) - juliandate(datetime('2000-01-01 12:00:00'));
% tmn2 = juliandate(datetime('2015-03-14 00:00:00')) - juliandate(datetime('2000-01-01 12:00:00'));

if tr>=0;
    tmn=tmn1+tr/86400;
else
    tmn=tmn1-tr/86400;
end
XMJD=tmn;
[ ~ , xctsun,R] = sun_ecef(XMJD-(16-(350.7512/1000))/86400);

% [X,Xct,R,L,B] = sun_ecef(XMJD);

rsun=xctsun*R;

rsun=rsun';
p=dot(rsat(1,:),rsun(1,:));
q=norm(rsat(1,:))*norm(rsun(1,:));
phi=acos(p(1,1)/q(1,1));
v=[];
if cos(phi)<0 && norm(rsat(1,:))*sqrt(1-cos(phi)^(2))<ae;
v=1;
end
if v==1
m=1;
else
    m=0;
end
end

