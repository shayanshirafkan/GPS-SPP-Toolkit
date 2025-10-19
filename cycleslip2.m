clear
clc
format long g
[hdr, obs] = read_rinex_obs('C:\Users\pascal\Desktop\cn000740.15o');
v=[];
for i=1:26662;
if obs(i,8)==7107;
v=[v;i];
end
end
[po,pn]=size(v);
jj=[];
for i=1:po-1;
    o1=[];
    o2=[];
    o1=v(i,1);
    o2=v(i+1,1);
    u=o2-o1;
    if u>100
        jj=[jj;i];
    end
end


f1=1575.42*10*(9);
f2=1227.6*10*(9);
if po>0;
phiw=(f1*obs(:,9)-f2*obs(:,10))/(f1-f2);
rn=(f1*obs(:,11)+f2*obs(:,12))/(f1+f2);


for i=1:po;
phiiw(i,1)=phiw(v(i,1),1);
rni(i,1)=rn(v(i,1),1);
end
BW=phiiw-rni;
mbw(1,1)=0;
for i=2:po;
mbw(i,1)=((i-1)/i)*mbw(i-1,1)+(1/i)*BW(i,1);
end
so=0;
sp=0;
sbw(1,1)=sqrt(((1-1)/1)*so+(1/1)*(BW(1,1)-sp)^(2));
for k=2:po;
sbw(k,1)=sqrt(((k-1)/k)*sbw(k-1,1)^(2)+(1/k)*(BW(k,1)-mbw(k-1,1))^(2));
end
j=BW-mbw;
vq=[];
for i=1:po;
if abs(j(i,1))>6*sbw(i,1);
vq=[vq;j];
end
end
[LM LD]=size(vq);
if LM>0;
for i=1:LM;
b(i,1)=v(vq(i,1),1);
end
end
end
