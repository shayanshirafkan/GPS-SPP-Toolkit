function [ Xk,Yk,Zk ] = satcoort(tr ,rsat , rrcv, atx ,stnum, f,tmn1,tmn2 );
dPCO =  atx.sat.neu;
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
E=(rsun'-rsat)/(norm(rsun'-rsat));
K=-rsat/norm(rsat);
J=cross(K,E);
I=cross(J,K);
R=[I;J;K];
stnum=stnum-7100;
dPCO(stnum,:,f);
n=dPCO(stnum,:,f);

mi=inv(R)*n';
dx=mi(1,1);
dy=mi(2,1);
dz=mi(3,1);
Xk=rsat(1,1)+dx;
Yk=rsat(1,2)+dy;
Zk=rsat(1,3)+dz;
end

