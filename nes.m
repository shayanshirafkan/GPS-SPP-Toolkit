function [ dnesb ] = nes( rsat,rrcv)
 mi = 6.6743 * 10^-11 * 5.972 * 10^24;
 c=299792458;
 u3=norm(rsat-rrcv);
 u1=norm(rsat)+norm(rrcv)+u3;
 u2=norm(rsat)+norm(rrcv)-u3;
 u=u1/u2;
 dnesb=((2*mi)/c^2)*log(abs(u));

end

