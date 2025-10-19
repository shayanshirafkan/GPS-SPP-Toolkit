clear
clc
v1=weekday('2015-03-15');
v2=weekday('2015-03-14');
[hdr, obs] = read_rinex_obs('C:\Users\pascal\Desktop\cn000740.15o');
[nav,ION_ALPHA, ION_BETA] = readRinex('C:\Users\pascal\Desktop\brdc0740.15n');


r0=[2874042.8280 -5356829.5000  1923453.4320];

EP=1000;

% for i=1:EP;
% R(i,1)=obs(i,11);
% end
obs=obs(:,1:1:12);
obs(any(isnan(obs),2),:)=[];
R1=obs(:,11);
PHI=obs(:,9);


% ZZ=R-R1(1:1:EP,1);

% RHatch=hatch(R1,PHI,360);
% RHatch=RHatch(1:1:EP,:);
% R=RHatch;
% for i=1:EP;
% R(i,1)  = hatch(obs,obs(i,4),obs(i,5),obs(i,6),obs(i,8),360 );
% end

f1=1575.42*10*(6);
f2=1227.6*10*(6);
a1=(40.3/f1^(2))*10^(16);
a2=(40.3/f2^(2))*10^(16);
at=(a1)/(a2-a1);

alfa=[2.1420D-08  7.4510D-09 -1.1920D-07  0.0000D+00]';
beta=[1.2290D+05  0.0000D+00 -2.6210D+05  1.9660D+05]';
dx=1;

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
rcv=r0;
nm=ecef2lla([rcv(1,1) rcv(1,2) rcv(1,3)]);
phi(1,1)=nm(1,1);
lan(1,1)=nm(1,2);
time=obs(:,1:1:6);
[TECS,Lat1,Lon1,DLat,DLon,interval] = IONEX2TECS('c1pg0740.15i');
for i=1:1000;
err(i,1) = ionex_err(TECS , time(i,:) , rasat(i,:) , r0 , 1,phi,lan)*10;
end;

for i=1:EP;
[E(i,1),A(i,1)] = G2LG(rasat(i,:),rcv,phi,lan );
end

alfa=[2.1420D-08  7.4510D-09 -1.1920D-07  0.0000D+00]';
beta=[1.2290D+05  0.0000D+00 -2.6210D+05  1.9660D+05]';
for i=1:EP;
ed(i,1)=klbuchar(A(i,1),E(i,1),phi,lan,temission(i,1),alfa, beta);
end
