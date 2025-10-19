function [ r1,r2,r3,cdt ] = bandcruft( sat,pr)

j1=[sat(1,1)  sat(1,2) sat(1,3)  pr(1,1)];
j2=[sat(2,1)  sat(2,2) sat(2,3)  pr(2,1)];
j3=[sat(3,1)  sat(3,2) sat(3,3)  pr(3,1)];
j4=[sat(4,1)  sat(4,2) sat(4,3)  pr(4,1)];
B=[j1 ;j2; j3; j4];

a1=(1/2)*crost(j1',j1' );
a2=(1/2)*crost(j2',j2' );
a3=(1/2)*crost(j3',j3' );
a4=(1/2)*crost(j4',j4' );
a=[a1;a2;a3;a4];

b=2*(crost( inv(B)*ones(4,1),inv(B)*a )-1);
c=crost( inv(B)*a,inv(B)*a );
aa=crost( inv(B)*ones(4,1),inv(B)*ones(4,1) );
delta=b^(2)-4*aa*c;
lan1=(-b+sqrt(delta))/(2*aa);
% if lan1 >=0
%     x=lan1;
% end
lan2=(-b-sqrt(delta))/(2*aa);

if abs(lan1)< abs(lan2)
    landa=lan1;
else
    landa=lan2;
end
% if lan2 >=0
%     x=lan2;
% end
% landa=lan1;

M=[1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 -1];
at=[a1 0 0 0;0 a2 0 0;0 0 a3 0; 0 0 0 a4];
h=M*inv(B)*(landa*ones(4,1)+a);
r1=h(1,1);
r2=h(2,1);
r3=h(3,1);
cdt=h(4,1);
end

