clear
clc
[hdr, obs] = read_rinex_obs('C:\Users\pascal\Desktop\cn000010.21o');
[fil,path]=uigetfile('C:\Users\pascal\Desktop\igs21385.sp3','Select sp3 File');
fid=fopen([path,fil],'r');
SP3 = SP3_File_Read(fid);
[k1,k2]=size(obs);

tmn1 = juliandate(datetime('2021-01-01 00:00:00')) - juliandate(datetime('2000-01-01 12:00:00'));
tmn2 = juliandate(datetime('2020-12-31 00:00:00')) - juliandate(datetime('2000-01-01 12:00:00'));
% d = juliandate('2015-03-15 00:00:00')
% modifiedjuliandate('2015-03-15 00:00:00')
rrcv=[2874042.8770 -5356829.4800  1923453.5060 ];

r0=rrcv;
f1=1575.42*10^(6);
f2=1227.6*10^(6);

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

tmn1=mjuliandate('2021-01-01');
tmn2=mjuliandate('2020-12-31');

for i=1:k1;
time(i,1)=3600*obs(i,4)+60*obs(i,5)+obs(i,6);
end
b=[];
for i=1:32;
g = cycle(obs,7100+i);
b=[b;g];
end
[sh1,sh2]=size(b);
if sh1>0
obs(b,:)=[];
end
obs=[obs time];

L=[];
for jd=1:32;
    
m=SP3{1,jd};
for jj=1:96;
time1(jj,1)=m(jj,4)*3600+m(jj,5)*60+m(jj,6);
end
m=[m time1];    

for j=1:96;
for i=1:26662;                
if obs(i,8)==7100+jd && obs(i,16)==time1(j,1);
    L1=[m(j,:) obs(i,8) obs(i,9) obs(i,10) obs(i,11) obs(i,12)];
    L=[L;L1];
end
end
end
end    
b=[]; 
[mb,mf]=size(L);
for j=1:96;
for i=1:mb;
if L(i,14)==time1(j,1);
    b=[b;L(i,:)];
end
end
end

b(any(isnan(b),2),:)=[];
b(:,20)= (f1.^(2)*b(:,16)-f2.^(2)*b(:,17))/(f1^(2)-f2^(2));
b(:,21)= (f1.^(2)*b(:,18)-f2.^(2)*b(:,19))/(f1^(2)-f2^(2));
[mb,mc]=size(b);
dcbq=load('satdcbmat.mat');
dcb=dcbq.satdcb;
b(:,22)=zeros(mb,1);
for i=1:mb;
    for j=1:32;
      if  b(i,15)== dcb(j,1);
          b(i,22)=dcb(j,2);
      end
    end
end
rsat1=[b(:,7) b(:,8) b(:,9)];
for i=1:mb;
mm(i,1)=saye( rsat1(i,:),b(i,14),tmn1,tmn2 );
end
nf=[];
for i=1:mb;
if mm(i,1)==1;
    nf=[nf;i];
end
end
b(nf,:)=[];
[jm,jn]=size(b);
bj=zeros(2*jm,jm);



for i=1:jm;
    bj(2*i,i)=1;
end
dx=1;
% jm=400;
while dx>10^(-5);
for i=1:jm;
tem(i,1) =temvs(b(i,4),b(i,5),b(i,6),b(i,18) );
end
% for i=1:jm;
%     tem1(i,1)=tsatp(b,b(i,14),b(i,15),b(i,7),b(i,8),b(i,9),r0,SP3 );
% end
for i=1:jm
    if tem(i,1)<0;
        lu=i;
    end
end
% i=163;
% e1=b(i,7);
% e2=b(i,8);
% e3=b(i,9);
% r0=rrcv;
% tr=b(i,14);
% stnum=b(i,15);

for i=1:jm;
x=[];
y=[];
z=[];
[x , y ,z]=satp(b,tem(i,1),b(i,15),SP3 );
rsat(i,:)=[x , y ,z];
end

% for i=1:jm;
% x=[];
% y=[];
% z=[];
% [x , y ,z]=satcoor(b,tem(i,1),b(i,15) );
% rsat(i,:)=[x , y ,z];
% end
for i=1:jm;
Xk=[];
Yk=[];
Zk=[];
[ Xk,Yk,Zk ] = satcoort(tem(i,1) ,rsat(i,:) , r0, atx1 ,b(i,15), 1,tmn1,tmn2 );
SAT(i,:)=[ Xk,Yk,Zk ];
end
rsat=SAT;
for i=1:jm;
[ xx,yy,zz ] =rot(rsat(i,:),r0);
rsat(i,:)=[ xx,yy,zz ] ;
end
SAT=rsat;

% (tr ,rsat , rrcv, atx ,stnum, f,tmn1,tmn2 )
for i=1:jm;
dt(i,1) = satsatp(b,tem(i,1),b(i,15),SP3);
end
dt=dt*10^(-6);
for i=1:jm;
W(i,1)=windup(tem(i,1) ,SAT(i,:) , r0 ,tmn1,tmn2);
end
D=DOY([2021,1,1]);
D=D*ones(jm,1);
for i=1:lu;
D(i,1)=D(i,1)-1;
end
% r0=rrcv;
nm=ecef2lla([r0(1,1) r0(1,2) r0(1,3)]);
phi=nm(1,1);
lan=nm(1,2);
for i=1:jm;
[E(i,1),A(i,1)] = G2LG(SAT(i,:),r0,phi(1,1),lan(1,1) );
end
E=rad2deg(E);
A=rad2deg(A);
height=1400;
Trdz=2.3*exp(-0.116*height*10^(-3));
Trz0w=0.1;
for i=1:jm;
[ad(i,1) bd(i,1) cd(i,1) aw(i,1) bw(i,1) cw(i,1)]=interpp(phi,D(i,1));
end
at=2.53e-5;bt=5.49e-3;ct=1.14e-3;
for i=1:jm;
o1=[];
o2=[];
o3=[];
o4=[];
o1=1+(bd(i,1))/(1+cd(i,1));
o2=1+(ad(i,1))/(o1);
o3=sind(E(i,1))+(bd(i,1))/(sind(E(i,1))+cd(i,1));
o4=(ad(i,1))/(o3)+sind(E(i,1));
m=[];
m=o2/o4;

% m=(1+(ad(i,1)/(1+(bd(i,1)/(1+cd(i,1))))))/(sind(E(i,1))+(ad(i,1)/(sind(E(i,1))+(bd(i,1)/(sind(E(i,1))+cd(i,1))))));
o1=[];
o2=[];
o3=[];
o4=[];
o1=1+(bt)/(1+ct);
o2=1+(at)/(o1);
o3=sind(E(i,1))+(bt)/(sind(E(i,1))+ct);
o4=(at)/(o3)+sind(E(i,1));
mmm=[];
mmm=o2/o4;
dm=((1)/(sind(E(i,1)))-mmm)*height;
% dm=((1/sind(E(i,1)))-(1+(at/1+(bt/1+ct)))/(sind(E(i,1))+(at/(sind(E(i,1))+(bt/(sind(E(i,1))+ct))))))*height;
Mdry(i,1)=m+dm; %output of mapping function FUNCTION

o1=[];
o2=[];
o3=[];
o4=[];
o1=1+(bw(i,1))/(1+cw(i,1));
o2=1+(aw(i,1))/(o1);
o3=sind(E(i,1))+(bw(i,1))/(sind(E(i,1))+cw(i,1));
o4=(aw(i,1))/(o3)+sind(E(i,1));
kk=[];
kk=o2/o4;
Mwet(i,1)=kk;

% Mwet(i,1)=(1+(aw(i,1)/1+(bw(i,1)/1+cw(i,1))))/(sind(E(i,1))+(aw(i,1)/(sind(E(i,1))+(bw(i,1)/(sind(E(i,1))+cw(i,1))))));%output
Tr0(i,1)=Trdz*Mdry(i,1)+Trz0w*Mwet(i,1);
end
for i=1:jm;
roh(i,1)=ROH(r0(1,1),r0(1,2),r0(1,3),SAT(i,1),SAT(i,2),SAT(i,3));
end

for i=1:jm;  
atx=antenna_PCV;
APC = atx.offset(:,:,1); 
azList = atx.tablePCV_azi;
znList = atx.tablePCV_zen;
data = atx.tablePCV(:,:,1);
nm=ecef2lla([rrcv(1,1) rrcv(1,2) rrcv(1,3)]);
phi=nm(1,1);
lan=nm(1,2);
[El, Az] =G2LG(rrcv, SAT(i,:),phi,lan);
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
for i=1:jm;
 nesb(i,1)= nes( SAT(i,:),r0);
end



l=zeros(2*jm,1);
c=299792458;
land=c/(f1-f2);
l(1:2:2*jm-1,1)=b(:,21)-(roh+nesb)+c*dt-Tr0+rr;
l(2:2:2*jm,1)=b(:,20)-(roh+nesb)+c*dt-Tr0-land*W-rr;

rf1=r0(1,1)*ones(jm,1)./roh;
rf2=r0(1,2)*ones(jm,1)./roh;
rf3=r0(1,3)*ones(jm,1)./roh;
rf=[rf1 rf2 rf3];

rt1=SAT(:,1)./roh;
rt2=SAT(:,2)./roh;
rt3=SAT(:,3)./roh;
rt=[rt1 rt2 rt3];
PK=rf-rt;
A=zeros(2*jm,5);
A(1:2:2*jm-1,1)=PK(1:1:jm,1);
A(2:2:2*jm,1)=PK(1:1:jm,1);
A(1:2:2*jm-1,2)=PK(1:1:jm,2);
A(2:2:2*jm,2)=PK(1:1:jm,2);
A(1:2:2*jm-1,3)=PK(1:1:jm,3);
A(2:2:2*jm,3)=PK(1:1:jm,3);
A(:,4)=1;
A(1:2:2*jm-1,5)=Mwet;
A(2:2:2*jm,5)=Mwet;
% bj=bj(1:1:jm,:);
A=[A bj];
rhat=inv(A'*A)*A'*l;
ro1=r0+rhat(1:1:3)';
dx=norm(r0-ro1)
r0=ro1;
end
ro1
[mb,mc]=size(b);
bs=10.1*10^(-9)*c;
for i=1:mb;
    hz(i,:)=[40.3*(f2^2-f1^2)/(f1*f2) ];
    lzz(i,1)=b(i,18)-b(i,19)-b(i,22)*c*10^(-9)-bs;
end
ju=inv(hz'*hz)*hz'*lzz;
STEC1=ju(1,1)*10;
% bs=ju(2,1);
N=b(i,18)-b(i,19)-(b(:,20)-b(:,21));
N=sum(sum(N))/mb;
for i=1:mb;
    STEC2(i,1)=(b(i,17)-(f2/f1)*b(i,16)+N+f2*(b(i,22)+bs))*((f1^(2)*f2)/(f1^(2)-f2^(2)))*c/40.3;
end
STEC2=STEC2*10^(-25);
N1=rhat(6:1:mb,1);
for i=1:mb-5;
    ST3(i,1)=(b(i,17)-(f2/f1)*b(i,16)+N1(i,1)+f2*(b(i,22)+bs))*((f1^(2)*f2)/(f1^(2)-f2^(2)))*c/40.3;
end
ST3=ST3*10^(-25);
wrt=rhat(5,1);
at=2.53e-5;bt=5.49e-3;ct=1.14e-3;
for i=1:mb;
o1=[];
o2=[];
o3=[];
o4=[];
o1=1+(bd(i,1))/(1+cd(i,1));
o2=1+(ad(i,1))/(o1);
o3=sind(E(i,1))+(bd(i,1))/(sind(E(i,1))+cd(i,1));
o4=(ad(i,1))/(o3)+sind(E(i,1));
WRT(i,1)=o4*wrt;
end
T0=1;
Tm=75.39+0.7103*T0;
k3=3.7*10^(5);
k2=17*10^(3);
Rv=461.45;
rf=1;
WRT2=inv(10^(-6)*(k3/Tm +k2)*Rv*rf)*WRT;