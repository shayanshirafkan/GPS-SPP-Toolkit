clear
clc
format long g
[hdr, obs] = read_rinex_obs('C:\Users\pascal\Desktop\cn000740.15o');
v=[];
% cyc = cycleslip(obs , hdr , 30 , 200 , 1);
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


for i=1:po;
phi1(i,1)=obs(v(i,1),9);
end
for i=1:po;
phi2(i,1)=obs(v(i,1),10);
end
phi=phi1-phi2;
xx=1:1:po;
xx=xx';
plot(xx,phi,'.');
for i=1:po;
t1(i,1)=obs(v(i,1),4);
t2(i,1)=obs(v(i,1),5);
t3(i,1)=obs(v(i,1),6);
end
 for i = 1:po;
time(i,1) =  t1(i,1)*3600+t2(i,1)*60+t3(i,1);
end
time=time/10000;
for j=1:5;
A(j,:)=[1 time(j,1)  time(j,1)^(2)];
end
xh=inv(A'*A)*A'*phi(1:1:5,1);
y=A*xh;
n1=y-phi(1:1:5,1);
v1=[];
k=jj(1);
NI=30;
for t=k+1:po; 
A1=[];    
for j=k+1:t-1;
A1(j-k,:)=[1 time(j,1)  time(j,1)^(2)];
end  
[pi,pii]=size(A1);
PL=pi-NI;
ll=phi(k+1:1:t-1,1);
if pi>NI;
A1=A1(PL+1:1:pi,:); 
ll=ll(PL+1:1:pi,1);
xh1=inv(A1'*A1)*A1'*ll;
y1=[1 time(t,1)  time(t,1)^(2)]*xh1;
n2=abs(y1)-phi(t,1);
if abs(n2)>200;
v1=[v1;t];
k=t;
end
end        
% if pi>3 && pi<=NI;
end

[LM LD]=size(v1);
for i=1:LM;
b(i,1)=v(v1(i,1),1);
end
b=[jj;b];
b=sort(b);