function [ dlt ] = shay1(obs,nav,tr,stnum,v1,v2 );
% tn=tr;
% v1=weekday('2015-03-15');
% v2=weekday('2020-03-14');
% v1=weekday('2021-01-01');
% v2=weekday('2020-12-31');

%  stnum=obs(1,8);
%  tr=temission(1,1);
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
Z = zeros(q,3);
toe= zeros(q,1);
for i=1:q;
Z(i,:)=nav(1,i).a0_a1_a2;
end


for i=1:q;
toe(i)=nav(1,i).toe;
end
for i=1:q
SAT(i,1)=nav(1,i).sat_num;
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
z1(i,:)=Z(v6(i,1),:);
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
zt(1,:)=z1(l,:);

tk=tr-toee;
tk(tk<-302400)= tk(tk<-302400)+604800;
tk(tk> 302400)= tk(tk> 302400)-604800;
dlt=zt(1,1)+zt(1,2)*tk+zt(1,3)*tk^(2);

end
