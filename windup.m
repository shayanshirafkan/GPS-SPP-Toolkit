function [ dphi ] = windup(tr ,rsat , rrcv,tmn1,tmn2 )
lt=rsat-rrcv;
i1=[lt(1,1)/norm(lt),0,0];
j1=[0,lt(1,2)/norm(lt),0];
k1=[0,0,lt(1,3)/norm(lt)];
i=[rrcv(1,1)/norm(rrcv),0,0];
j=[0,rrcv(1,2)/norm(rrcv),0];
k=[0,0,rrcv(1,3)/norm(rrcv)];
U=[i1(1,1),j1(1,2),k1(1,3)];
% tmn1 = juliandate(datetime('2015-03-15 00:00:00')) - juliandate(datetime('2000-01-01 12:00:00'));
% tmn2 = juliandate(datetime('2015-03-14 00:00:00')) - juliandate(datetime('2000-01-01 12:00:00'));
% tr=50;
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
D1=I-U*dot(U,I)-cross(U,J);
D2=i-U*dot(U,i)-cross(U,j);
p=cross(D1,D2);
eta=dot(K,p);
dphi=sign(eta)*acos((dot(D1,D2))/(norm(D1)*norm(D2)));

end

