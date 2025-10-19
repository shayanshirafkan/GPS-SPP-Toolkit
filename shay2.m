function [TGD ] = shay2( obs,nav,tr,stnum,v1,v2 );
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

toe= zeros(q,1);
for i=1:q;
tgdd(i,1)=nav(1,i).tgd;
end

for i=1:q;
toe(i)=nav(1,i).toe;
end
for i=1:q
SAT(i,1)=nav(1,i).sat_num;
end
v6=[];
for i=1:q;
if  SAT(i,1)==stnum-7100;
v6=[v6;i];
end
end
[on,pm]=size(v6);
for i=1:on;
toe1(i,1)=toe(v6(i,1),1);
tgd1(i,1)=tgdd(v6(i,1),1);
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
TGD=tgd1(l,1);
end