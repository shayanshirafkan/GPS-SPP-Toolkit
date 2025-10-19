clear
clc
v1=weekday('2015-03-15');
v2=weekday('2015-03-14');
[hdr, obs] = read_rinex_obs('C:\Users\pascal\Desktop\cn000740.15o');
[nav,ION_ALPHA, ION_BETA] = readRinex('C:\Users\pascal\Desktop\brdc0740.15n');


r0=[2874042.8280 -5356829.5000  1923453.4320];

EP=100;

for i=1:EP;
R(i,1)=obs(i,11);
end
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

% for i=1:EP;
% temission(i,1)=temissionnav(obs,nav,r0,obs(i,4),obs(i,5),obs(i,6),obs(i,8) );
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
   
% rrcv=r0;
% rsat=rasat(1,:);
phi=[];
lan=[];
rrcv=r0;
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
D(i,1)=obs(i,11)+c*em(i,1)+TR(i,1)-TGD(i,1)*c+at*ed(i,1);
end

% for i=1:EP;
% pr(i,1)=obs(i,11)+c*em(i,1)-TGD(i,1)*c;
% end

for i=1:EP;
prj(i,1)=obs(i,11)+c*em(i,1)-TGD(i,1)*c;
end

for i=1:EP;
prj1(i,1)=obs(i,11)+c*em(i,1)+TR(i,1)-TGD(i,1)*c+at*ed(i,1);
end
for j=1:2000;
    sat=[];
    pr=[];
for i=4*(j-1)+1:4*j;
    
kq=rasat(i,:);
sat=[sat;kq];
kd=prj(i,1);
pr=[pr;kd];
end
[ r1,r2,r3,cdt ] = bandcruft( sat,pr)
RR(j,:)=[ r1,r2,r3,cdt ];
end




for j=1:100;
    sat=[];
    pr=[];
for i=4*(j-1)+1:4*j;
    
kq=rasat(i,:);
sat=[sat;kq];
kd=prj1(i,1);
pr=[pr;kd];
end
[ r1,r2,r3,cdt ] = bandcruft( sat,pr)
RR1(j,:)=[ r1,r2,r3,cdt ];
end

% for j=1:100;
%     sat=[];
%     pr=[];
% for i=4*(j-1)+1:4*j;
%     
% kq=rasat(i,:);
% sat=[sat;kq];
% kd=D(i,1);
% pr=[pr;kd];
% end
% [ r1,r2,r3,cdt ] = bandcruft( sat,pr)
% RD(j,:)=[ r1,r2,r3,cdt ];
% end

ef=20;
for i=1:ef;
    B(i,:)=[rasat(i,:) prj(i,:)];
    j1=[];
    j1=[rasat(i,:),prj(i,:)];
    j1=j1';
    aaa(i,1)=(1/2)*crost( j1,j1 );
end




a1=crost( inv(B'*B)*B'*ones(ef,1),inv(B'*B)*B'*ones(ef,1) );
b1=2*(crost( inv(B'*B)*B'*ones(ef,1),inv(B'*B)*B'*aaa )-1);
c1=(crost( inv(B'*B)*B'*aaa,inv(B'*B)*B'*aaa ));

delta=b1^(2)-4*a1*c1;
lan1=(-b1+sqrt(delta))/(2*a1);
% lan1=(-b1+sqrt(delta))/(2*a1);
% if lan1 >=0
%     x=lan1;
% end
lan2=(-b1-sqrt(delta))/(2*a1);

if abs(lan1)< abs(lan2)
    landa=lan1;
else
    landa=lan2;
end
m=[1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 -1];
RRR=m*inv(B'*B)*B'*(landa*ones(ef,1)+aaa);