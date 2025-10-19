function err = ionex_err(ionex , time , r_sat , r_rcv , f_num,phi,lan)

Re = .63781363e+7;
h = 450000;

if f_num == 1
    a = 0.1624;
else 
    a = 0.2674;
end

ref_time = time(:,4)+1;
if size(ionex,3) > 20 % 24 hour obs or 12 hour
    mat = ionex(: , : , ref_time);
else
   mat = ionex(: , : , ceil(ref_time./2) );
end

[phi_rcv, landa_rcv ] = ecef2geodetic(wgs84Ellipsoid, r_rcv(1),...
    r_rcv(2), r_rcv(3));
phiList = -180 : 5 : 180;
landaList = 87.5 : -2.5 : -87.5;

Vtec = zeros(length(ref_time) ,1);
for i = 1 : length(ref_time)
    Vtec(i) = interp2(phiList, landaList, mat(: , : , i), phi_rcv,...
        landa_rcv) ./ 10;
end
[El,A] = G2LG(r_sat,r_rcv,phi,lan );
% El = ecef2ea(r_rcv, r_sat);
F = ( 1 - (Re*cos(El)./(Re+h)).^2 ).^-0.5;
err = F.* a .* Vtec;
end

