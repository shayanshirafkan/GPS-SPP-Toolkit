function [ad bd cd aw bw cw]=interpp(phii,DOY)
x=[15 30 45 60 75];
%average dry
y1=[1.2769934e-3 1.2683230e-3 1.2465397e-3 1.2196049e-3 1.2045996e-3];
y2=[2.9153695e-3 2.9152299e-3 2.9288445e-3 2.9022565e-3 2.9024912e-3];
y3=[62.610505e-3 62.837393e-3 63.721774e-3 63.824265e-3 64.258455e-3];
%amplitude dry
y4=[0 1.2709626e-5 2.6523662e-5 3.4000452e-5 4.1202191e-5];
y5=[0 2.1414979e-5 3.0160779e-5 7.2562722e-5 11.723375e-5];
y6=[0 9.128400e-5 4.3497037e-5 84.795348e-5 170.37206e-5];
% wet
y7=[5.8021898e-4 5.6794847e-4 5.8118019e-4 5.9727542e-4 6.1641693e-4];
y8=[1.4275268e-3 1.5138625e-3 1.4572752e-3 1.5007428e-3 1.7599082e-3];
y9=[4.3472961e-2 4.6729510e-2 4.3908931e-2 4.4626982e-2 5.4736038e-2];
if phii<15
    ad=y1(1);
    bd=y2(1);
    cd=y3(1);
elseif phii>75
    ad=y1(5)-y4(5)*cos(2*pi*((DOY-28)/365.25));
    bd=y2(5)-y5(5)*cos(2*pi*((DOY-28)/365.25));
    cd=y3(5)-y6(5)*cos(2*pi*((DOY-28)/365.25));
else
ad=interp1(x,y1,phii)-interp1(x,y4,phii)*cos(2*pi*((DOY-28)/365.25));
bd=interp1(x,y2,phii)-interp1(x,y5,phii)*cos(2*pi*((DOY-28)/365.25));
cd=interp1(x,y3,phii)-interp1(x,y6,phii)*cos(2*pi*((DOY-28)/365.25));
end
if phii<15
    aw=y7(1);
    bw=y8(1);
    cw=y9(1);
elseif phii>75
    aw=y7(5);
    bw=y8(5);
    cw=y9(5);
else
    aw=interp1(x,y7,phii);
    bw=interp1(x,y8,phii);
    cw=interp1(x,y9,phii);
end

