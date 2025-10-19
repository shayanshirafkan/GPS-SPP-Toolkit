function TR=colliins(phi,D,H,E)
%  E=E1(5,1);
%  D=73;
k1 = 77.604;k2 = 382000;Rd = 287.054;gm = 9.784;g = 9.80665;
[T,P,e1,beta,lambda] =interpolation(30 ,1)
Trz0d = 1e-6*k1*Rd*P/gm;
Trz0w = 10^(-6)*k2*Rd*e1/(((lambda+1)*gm-beta*Rd)*T);
Trzd = ((1-(beta*H/T))^(g/(Rd*beta)))*Trz0d;
Trzw = ((1-(beta*H/T))^(((lambda+1)*g/(Rd*beta))-1))*Trz0w;
M = 1.001/sqrt(0.002001+sind(E)^2);
TR = (Trzd+Trzw)*M;
end