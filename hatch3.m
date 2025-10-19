function [ R ] = hatch3(obs,R,PHI,t1,t2,t3,stnum,n );

time=3600*t1+60*t2+t3;

% n=360;
% stnum=7107;
v=[];
[LK,LD]=size(obs);

for i=1:LK;
if obs(i,8)==stnum;
b=i;
v=[v;b];
end
end
[lp,lq]=size(v);
for i=1:lp;
s(i,1)=R(v(i,1),1);
end
ur(1,1)=s(1,1);
for i=1:lp;
v1(i,1)=PHI(v(i,1),1);
end
for j=2:lp;
ur(j,1)=(1/n)*(sum(sum(s(1:j,1))))/j +((n-1)/n)*(ur(j-1,1)+v1(j,1)-v1(j-1,1));
end
for i=1:lp;
time2(i,1)=3600*obs(v(i,1),4)+60*obs(v(i,1),5)+obs(v(i,1),6);
end
for i=1:lp;
    if time==time2(i,1);
        k=i;
    end
end
R=ur(k,1);
end