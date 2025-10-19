function [ dt ] = satsatp( b,tr,stnum,SP3 )
ZF=stnum-7100;
SP33=SP3{1,ZF};
timed=SP33(:,4)*3600+SP33(:,5)*60+SP33(:,6);

xt=SP33(:,10);








jn=find(timed<=tr,1,'last');

[pd,pll]=size(jn);
if pd==0;
    jn=0;
end

if jn <=4 ;
xt=xt(1:1:9,:);
timed=timed(1:1:9,:);
elseif jn>=93;
xt=xt(88:1:96,:);
timed=timed(88:1:96,:);
 
elseif jn==0;
xt=xt(1:1:9,:);
timed=timed(1:1:9,:);
else
xt=xt(jn-4:1:jn+4,:);
timed=timed(jn-4:1:jn+4,:);
end
% if tr >= timed(14,1);
% timed=timed(14:1:pl,:);
% xt=xt(14:1:pl,:);
% else
% timed=timed(1:1:15,:);
% xt=xt(1:1:15,:);  
% end    
xt=xt';

timed=timed';
dt = LagrangeInter(timed,xt,tr);


end

