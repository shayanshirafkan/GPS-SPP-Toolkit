function [ t ] =temvs(t1,t2,t3,L )
time =  t1*3600+t2*60+t3;
c=299792458;
% dlt= esaat(obs,nav,time,stnum );
% t=time-L/c-dlt;
t=time-L/c;
end