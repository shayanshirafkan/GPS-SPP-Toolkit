function ed=klbuchar(A,E,phi,lambda,time,alfa, beta)
% A=deg2rad(A);
% E=deg2rad(E);
% A=A(521,1);
% E=E(521,1);
% phi=phi;
% lambda=lan;
% time=temission(521,1);

% v1=weekday('2015-03-15');
% v2=weekday('2015-03-14');
% 
% if time>0;
%     time=time+86400*(v1-1);
% elseif time<0;
%     time=time+86400*(v2);
% end

ff=299792458;
R=6378000;
hg=350000;
phiP=78.3;
lambdaP=291;
% phiP=deg2rad(78.3);
% lambdaP=deg2rad(291);
AI=0;
PI=0;
E1=deg2rad(E);

say=(pi/2-E-asin(R*cos(E)/(R+hg)));
say=rad2deg(say);

phiIP=asind(sind(phi)*cosd(say)+cosd(phi)*sind(say)*cos(A));
lambda1=deg2rad(lambda);
say1=deg2rad(say);
% A1=deg2rad(A);
phiIP1=deg2rad(phiIP);
lambdaIP1=lambda1+say1*sin(A)/cos(phiIP1);
lambdaIP=rad2deg(lambdaIP1);
phim=asind(sind(phiIP)*sind(phiP)+cosd(phiIP)*cosd(phiP)*cosd(lambdaIP-lambdaP));
phim=deg2rad(phim);

t1=43200*lambdaIP1/pi+time;
if t1>=86400 ;
t1=t1-86400;
elseif t1<0;
t1=t1+86400;
end

for i=1:4
AI=AI+alfa(i,1)*(phim/pi)^(i-1);
end
if AI<0 ;
AI=0;
end
for i=1:4
PI=PI+beta(i,1)*(phim/pi)^(i-1);
end
if PI<72000 
PI=72000;
end
XI=2*pi*(t1-50400)/PI;
F=(1-(R*cos(E)/(R+hg))^2)^(-0.5);
if abs(XI)<pi/2
I1=(5e-9+AI*cos(XI))*F;
elseif abs(XI)>=pi/2
I1=5e-9*F;
end
ed=I1*ff;
end