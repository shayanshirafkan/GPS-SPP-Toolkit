clear
clc
v1=weekday('2021-01-01');
v2=weekday('2020-12-31');
[hdr, obs] = read_rinex_obs('C:\Users\pascal\Desktop\cn000010.21o');
[nav,ION_ALPHA, ION_BETA] = readRinex('C:\Users\pascal\Desktop\brdc0010.21n');
r0=[2874042.8770 -5356829.4800  1923453.5060 ];

rrcv=r0;
EP=20000;

for i=1:EP;
R(i,1)=obs(i,11);
end
f1=1575.42*10*(6);
f2=1227.6*10*(6);
a1=(40.3/f1^(2))*10^(16);
a2=(40.3/f2^(2))*10^(16);
at=(a1)/(a2-a1);


obs(:,16)=obs(:,4)*3600+obs(:,5)*60+obs(:,6);
qq=[];
for i=1:26661;
    if obs(i+1,16)-obs(i,16)==30;
        qg=i+1;
        qq=[qq;qg];
    end
end


qq=[1;qq];



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
roh(i,1)=ROH(r0(1,1),r0(1,2),r0(1,3),rasat(i,1),rasat(i,2),rasat(i,3));
end

rf1=r0(1,1)*ones(EP,1)./roh;
rf2=r0(1,2)*ones(EP,1)./roh;
rf3=r0(1,3)*ones(EP,1)./roh;
rf=[rf1 rf2 rf3];

rt1=rasat(:,1)./roh;
rt2=rasat(:,2)./roh;
rt3=rasat(:,3)./roh;
rt=[rt1 rt2 rt3];
A=[];
A=rf-rt;
A=[A ones(EP,1)];

for i=1:2600;
     AA=[];
   for j=qq(i,1):qq(i+1,1)-1;
   aa=A(j,:);
   AA=[AA;aa];
   end
   Q=[];
   Q=inv(AA'*AA);
   PDOP(i,1)=Q(1,1)+Q(2,2)+Q(3,3);
end
J=1:1:2021; 
plot(J,PDOP)
xlabel('epoch')
ylabel('PDOP')
title('PDOP STATUS');