function [temssion] = tsatp(b,tr,stnum,e1,e2,e3,r0,SP3 )
ZF=stnum-7100;
SP33=SP3{1,ZF};
timed=SP33(:,4)*3600+SP33(:,5)*60+SP33(:,6);



X1=SP33(:,7);
Y1=SP33(:,8);
Z1=SP33(:,9);





% jk=tr*ones(pl,1);
% 
% k22=abs(jk-timed);
jn=find(timed<=tr,1,'last');
[pd,pll]=size(jn);
if pd==0;
    jn=0;
end
% jn=min([find(timed<=tr,1,'last') find(tr>timed,1)]);
% [pd,pll]=size(jn);
% if pd==0;
%     jn=0;
% end

if jn <=4 ;
X1=X1(1:1:9,:);
Y1=Y1(1:1:9,:);
Z1=Z1(1:1:9,:); 
timed=timed(1:1:9,:);
elseif jn>=93;
X1=X1(88:1:96,:);
Y1=Y1(88:1:96,:);
Z1=Z1(88:1:96,:);
timed=timed(88:1:96,:);
 
elseif jn==0;
X1=X1(1:1:9,:);
Y1=Y1(1:1:9,:);
Z1=Z1(1:1:9,:);
timed=timed(1:1:9,:);
else
X1=X1(jn-4:1:jn+4,:);
Y1=Y1(jn-4:1:jn+4,:);
Z1=Z1(jn-4:1:jn+4,:); 
timed=timed(jn-4:1:jn+4,:);
end
% % r0=[2874042.8280  -5356829.5000  1923453.4320];
% r=[X1 Y1 Z1];
c=299792458;
X1=X1';
Y1=Y1';
Z1=Z1';
timed=timed';
for i=1:1
rj=[e1 e2 e3];
p=1;    
 while p > 10^(-6);
dt=norm(rj-r0)/c;
t3=tr-dt;
xi = LagrangeInter(timed,X1,t3);
yi = LagrangeInter(timed,Y1,t3);
zi = LagrangeInter(timed,Z1,t3);
ri=[xi,yi,zi];
p=norm(rj-ri);
rj=ri;
end
temssion(1,i)=tr-dt;
end   
temssion=temssion';


end
