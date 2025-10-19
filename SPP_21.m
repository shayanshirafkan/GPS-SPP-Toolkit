clear
clc
% [hdr, obs] = read_rinex_obs('C:\Users\pascal\Desktop\cn000740.15o');
% [nav,ION_ALPHA, ION_BETA] = readRinex('C:\Users\pascal\Desktop\brdc0740.15n');
% r0=[2874042.8280 -5356829.5000  1923453.4320];
v1=weekday('2021-01-01');
v2=weekday('2020-12-31');
[hdr, obs] = read_rinex_obs('C:\Users\pascal\Desktop\cn000010.21o');
[nav,ION_ALPHA, ION_BETA] = readRinex('C:\Users\pascal\Desktop\brdc0010.21n');
r0=[2874042.8770 -5356829.4800  1923453.5060 ];

EP=1000;
for i=1:EP;
R(i,1)  = hatch(obs,obs(i,4),obs(i,5),obs(i,6),obs(i,8),360 );
end
% for i=1:EP;
% R(i,1)=obs(i,11);
% end

f1=1575.42*10*(9);
f2=1227.6*10*(9);
a1=(40.3/f1^(2))*10^(16);
a2=(40.3/f2^(2))*10^(16);
at=(a1)/(a2-a1);


alfa=[7.4510D-09 -1.4900D-08 -5.9600D-08  1.1920D-07]';
beta=[9.2160D+04 -1.1470D+05 -1.3110D+05  7.2090D+05]';
dx=1;
tmn1=mjuliandate('2021-01-01');
tmn2=mjuliandate('2020-12-31');

options.system.gps = 1; options.system.glo = 0;
options.system.gal = 0; options.system.bds = 0;
file.atx='C:\Users\pascal\Desktop\igs14.txt';
f_anten=file.atx;
atx_sat = read_anx_sat(file.atx,options);
[atx1] = r_antx(f_anten, hdr.ant(1,2),options);
J='igs14.txt';

[antenna_PCV] = read_antenna_PCV('igs14.txt', hdr.ant(1,2)); 
atx=antenna_PCV;
APC = atx.offset(:,:,1); 
azList = atx.tablePCV_azi;
znList = atx.tablePCV_zen;
data = atx.tablePCV(:,:,1);

tmn1=mjuliandate('2015-03-15');
tmn2=mjuliandate('2015-03-14');
while norm(dx)>10^(-6); 
% for i=1:EP;
% temission1(i,1)=temissionnav(obs,nav,r0,obs(i,4),obs(i,5),obs(i,6),obs(i,8) );
% end

for i=1:EP;
temission(i,1)=temv(obs,nav,obs(i,4),obs(i,5),obs(i,6),obs(i,8),obs(i,11) );
end
for i=1:EP;
    if temission(i,1)<0;
        ld=i;
    end
end

for i=1:EP;
[Xk,Yk,Zk ]=shay(obs,nav,temission(i,1),obs(i,8),v1,v2);
rasat(i,:)=[Xk,Yk,Zk ];
end
% tr=temission(80,1);
% rsat=rasat(80,:);
for i=1:EP;
Xk=[];
Yk=[];
Zk=[];
[ Xk,Yk,Zk ] = satcoort(temission(i,1) ,rasat(i,:) , r0, atx1 ,obs(i,8), 1,tmn1,tmn2 );
SAT(i,:)=[ Xk,Yk,Zk ];
end
rasat=SAT;

for i=1:EP;
[ xx,yy,zz ] =rot(rasat(i,:),r0);
rasat(i,:)=[ xx,yy,zz ] ;
end
for i=1:EP;
em(i,1)= shay1(obs,nav,temission(i,1),obs(i,8),v1,v2);
end  
for i=1:EP;
TGD(i,1)= shay2(obs,nav,temission(i,1),obs(i,8),v1,v2);
end  
   
rrcv=r0;
for i=1:EP;  
atx=antenna_PCV;
APC = atx.offset(:,:,1); 
azList = atx.tablePCV_azi;
znList = atx.tablePCV_zen;
data = atx.tablePCV(:,:,1);
nm=ecef2lla([rrcv(1,1) rrcv(1,2) rrcv(1,3)]);
phi=nm(1,1);
lan=nm(1,2);
[El, Az] =G2LG(rrcv, rasat(i,:),phi,lan);
El=abs(El);
Az=abs(Az);
Zn = rad2deg(pi/2 - El);
Az = rad2deg(Az) + 180;
% L1
APR = interp2(znList, azList,data,Zn,Az);
rrs=[];
rrs = APR*ones(1,3) + APC+hdr.delta;
rr(i,1)=norm(rrs);
end
for i=1:EP
 nesb(i,1)= nes( rasat(i,:),rrcv);
end
% rrcv=r0;
% rsat=rasat(1,:);
phi=[];
lan=[];

nm=ecef2lla([rrcv(1,1) rrcv(1,2) rrcv(1,3)]);
phi(1,1)=nm(1,1);
lan(1,1)=nm(1,2);


for i=1:EP;
[E(i,1),A(i,1)] = G2LG(rasat(i,:),rrcv(1,:),phi(1,1),lan(1,1) );
end
E1=rad2deg(E);
A1=rad2deg(A);
D1=1;
H=1600;
D1=D1*ones(EP,1);
for i=1:ld;
D1(i,1)=365;
end

for i=1:EP;

TR(i,1)=colliins(phi(1,1),D1(i,1),H,E1(i,1));
end


for i=1:EP;
ed(i,1)=klbuchar(A(i,1),E(i,1),phi(1,1),lan(1,1),temission(i,1),alfa, beta);
end
c=299792458;
for i=1:EP;
D(i,1)=-c*em(i,1)+TR(i,1)+TGD(i,1)*c+at*ed(i,1);
end

for i=1:EP;
roh(i,1)=ROH(r0(1,1),r0(1,2),r0(1,3),rasat(i,1),rasat(i,2),rasat(i,3))+nesb(i,1);
end

% rf1=[];
% rf2=[];
% rf3=[];
% rf=[];
rf1=r0(1,1)*ones(EP,1)./roh;
rf2=r0(1,2)*ones(EP,1)./roh;
rf3=r0(1,3)*ones(EP,1)./roh;
rf=[rf1 rf2 rf3];
% rt1=[];
% rt2=[];
% rt3=[];
% rt=[];
rt1=rasat(:,1)./roh;
rt2=rasat(:,2)./roh;
rt3=rasat(:,3)./roh;
rt=[rt1 rt2 rt3];
A=[];
A=rf-rt;
A=[A ones(EP,1)];
L=obs(1:1:EP,11)+rr-roh-D;
% L=R-roh-D;
%  tqq=[];
%  for i=1:1000;
%      if abs(L(i,1))>4;
% tqq=[tqq;i];
%      end
%  end
%  L(tqq,:)=[];
%  A(tqq,:)=[];
% 
rhat=inv(A'*A)*A'*L;
ro1=r0+rhat(1:1:3)';
dx=norm(r0-ro1)
r0=ro1;
end