function [temssion ] = temissionnav(obs,nav,r0,t1,t2,t3,stnum,v1,v2 )
time =  t1*3600+t2*60+t3;
c=299792458;
[X1,Y1,Z1]=k2ecf(obs,nav,time,stnum);
X1=X1';
Y1=Y1';
Z1=Z1';
time=time';
r=[X1 Y1 Z1];
for i=1:1;
rj=r(i,:);
p=1;    
while p > 10^(-5);
dt=norm(rj-r0)/c;
t3=time(1,i)-dt;
[ xi,yi,zi ] = shay(obs,nav,t3,stnum,v1,v2);
ri=[xi,yi,zi];
p=norm(rj-ri);
rj=ri;
end
temssion(1,i)=time(1,i)-dt;
end   
temssion=temssion';
end

