function [ Xk,Yk,Zk ] = shay(obs,nav,tr,stnum,v1,v2 )
% i=80;
% tr=temission(i,1); 
% 
% stnum=obs(i,8);
% v1=weekday('2015-03-15');
% v2=weekday('2015-03-14');

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
t1(i,1)=obs(v(i,1),4);
t2(i,1)=obs(v(i,1),5);
t3(i,1)=obs(v(i,1),6);
end

time = tr;


q=length(nav);
a= zeros(q,1);
e = zeros(q,1);
toe= zeros(q,1);
dn = zeros(q,1);
Omega = zeros(q,1);
w = zeros(q,1);
i0 = zeros(q,1);
idot = zeros(q,1);
omegadot = zeros(q,1);
M0= zeros(q,1);
cuc = zeros(q,1);
cus = zeros(q,1);
crc = zeros(q,1);
crs = zeros(q,1);
cic = zeros(q,1);
cis = zeros(q,1);

for i=1:q
SAT(i)=nav(1,i).sat_num;
toe(i)=nav(1,i).toe;
a(i)=(nav(1,i).sqrt_a)^2;
e(i)=nav(1,i).e;
w(i)=nav(1,i).w;
dn(i)=nav(1,i).dn;
Omega(i)=nav(1,i).omega0;
omegadot(i)=nav(1,i).omega_dot;
i0(i)=nav(1,i).i0;
idot(i,1)=nav(1,i).i_dot;
M0(i)=nav(1,i).M0;
cuc(i)=nav(1,i).cuc;
cus(i)=nav(1,i).cus;
crc(i)=nav(1,i).crc;
crs(i)=nav(1,i).crs;
cic(i)=nav(1,i).cic;
cis(i)=nav(1,i).cis;
end


v6=[];
for i=1:q;
if  SAT(i)==stnum-7100;
v6=[v6;i];
end
end
[on,pm]=size(v6);
for i=1:on;
toe1(i,1)=toe(v6(i,1),1);
a1(i,1)=a(v6(i,1),1);
e1(i,1)=e(v6(i,1),1);
w1(i,1)=w(v6(i,1),1);
dn1(i,1)=dn(v6(i,1),1);
Omega1(i,1)=Omega(v6(i,1),1);
omegadot1(i,1)=omegadot(v6(i,1),1);
i01(i,1)=i0(v6(i,1),1);
idot1(i,1)=idot(v6(i,1),1);
M01(i,1)=M0(v6(i,1),1);
cuc1(i,1)=cuc(v6(i,1),1);
cus1(i,1)=cus(v6(i,1),1);
crc1(i,1)=crc(v6(i,1),1);
crs1(i,1)=crs(v6(i,1),1);
cic1(i,1)=cic(v6(i,1),1);
cis1(i,1)=cis(v6(i,1),1);
end

if tr>0;
tr=tr+86400*(v1-1);
elseif tr<0;
tr=tr+86400*(v2);
end


if v1==1;
tj=time+86400*(7);
for j=1:on;
if toe1(j,1)<500000;
to1(j,1)=toe1(j,1)+86400*(7);
else
to1(j,1)=toe1(j,1);
end 
end
jn=find(to1<=tj,1,'last');    
[pd,pl]=size(jn);
if pd==0;
l=1;
else
l=jn;
end

else
    
jn=find(toe1<=tr,1,'last'); 
[pd,pl]=size(jn);
if pd==0;
l=1;
else
l=jn;
end    
end


toee=toe1(l,1);
at=a1(l,1);
et=e1(l,1);
wt=w1(l,1);
dnt=dn1(l,1);
Omegat=Omega1(l,1);
omegadott=omegadot1(l,1);
i0t=i01(l,1);
idott=idot1(l,1);
M0t=M01(l,1);
cuct=cuc1(l,1);
cust=cus1(l,1);
crct=crc1(l,1);
crst=crs1(l,1);
cict=cic1(l,1);
cist=cis1(l,1);    
      
tk=tr-toee;
tk(tk<-302400)= tk(tk<-302400)+604800;
tk(tk> 302400)= tk(tk> 302400)-604800;
mi = 6.6743 * 10^-11 * 5.972 * 10^24;
n = sqrt(mi./at.^3) + dnt;  
Mk = M0t+ n .* tk;

 Ek = Mk; dx=1;
while norm(dx) > 10^-15
Ek2=Ek+(Mk+et*sin(Ek)-Ek)/(1-et*cos(Ek));
dx = Ek2 - Ek;
Ek = Ek2;
end

we = 7.292115 * 10^-5;
vk = atan2(sqrt(1-et.^2).*sin(Ek),cos(Ek)-et);
uk = wt + vk + cuct .* cos(2*(wt+vk)) + cust .* sin(2*(wt+vk));
rk = at.*(1-et*cos(Ek))+crct.*cos(2*(wt+vk))+crst.*sin(2*(wt+vk));
ik = i0t + idott.*tk+ cict.*cos(2*(wt+vk))+cist.*sin(2*(wt+vk));
Omegak = Omegat + (omegadott-we).*tk - we*toee ;
xp=rk*cos(uk);
yp=rk*sin(uk);
Xk=xp*cos(Omegak)-yp*sin(Omegak)*cos(ik);
Yk=xp*sin(Omegak)+yp*cos(Omegak)*cos(ik);
Zk=yp*sin(ik);
rr=[Xk Yk Zk];
% R3=[cos(Omegak)  -sin(Omegak)  0  ; sin(Omegak)  cos(Omegak) 0;0 0 1];
% R1=[1 0 0;0 cos(ik)  -sin(ik) ;0 sin(ik)   cos(ik)];
% R2=[cos(uk)  -sin(uk) 0 ;sin(uk)  cos(uk) 0;0 0 1];
% R=R3*R1*R2;
% L=R*[rk;0;0];
% P=R(:,1);
% Q=R(:,2);
% S=R(:,3);
% Xk = L(1);
% Yk = L(2);
% Zk = L(3);
% rr=[Xk Yk Zk];

end