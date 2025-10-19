function [T,P,e,beta,lambda] = interpolation(phi,D)
% phi=abs(phi);
phii=abs(phi);
T0 = [299.65, 294.15, 283.15, 272.15, 263.65];
T0=T0';
dT = [0 , 7, 11, 15, 14.5];
dT=dT';
P0 = [1013.25, 1017.25, 1015.75, 1011.75, 1013.00];
P0=P0';
dP = [0 , -3.75, -2.25, -1.75, -0.5];
dP=dP';
e0 = [26.31, 21.79, 11.66, 6.78, 4.11];
e0=e0';
de = [0 , 8.85, 7.24, 5.36, 3.39];
de=de';
beta0 = [6.3, 6.05, 5.58, 5.39, 4.53]*10^(-3);
beta0=beta0';
dbeta = [0 , 0.25, 0.32, 0.81, 0.62]*10^(-3);
dbeta=dbeta';
lambda0 = [2.77, 3.15, 2.57, 1.81, 1.55];
lambda0=lambda0';
dlambda = [0 , 0.33, 0.46, 0.74, 0.30];
dlambda=dlambda';
num = phii/15;
num1 = floor(phii/15);
if mod(phii,15)==0
T0_1 = T0(num);
P0_1 = P0(num);
e0_1 = e0(num);
beta0_1 = beta0(num);
lambda0_1 = lambda0(num);
dT_1 = dT(num);
dP_1 = dP(num);
de_1 = de(num);
dbeta_1 = dbeta(num);
dlambda_1 = dlambda(num);
elseif mod(phii,15)~=0 && num1==0
num = 1;
T0_1 = T0(num);
P0_1 = P0(num);
e0_1 = e0(num);
beta0_1 = beta0(num);
lambda0_1 = lambda0(num);
dT_1 = dT(num);
dP_1 = dP(num);
de_1 = de(num);
dbeta_1 = dbeta(num);
dlambda_1 = dlambda(num);
elseif mode(phii/15)~=0 && num1==5
num = 5;
T0_1 = T0(num);
P0_1 = P0(num);
e0_1 = e0(num);
beta0_1 = beta0(num);
lambda0_1 = lambda0(num);
dT_1 = dT(num);
dP_1 = dP(num);
de_1 = de(num);
dbeta_1 = dbeta(num);
dlambda_1 = dlambda(num);
else
x = [15*num1, 15*(num1+1)];
y_T = [T0(num1), T0(num1+1)];
T0_1 = interp1(x,y_T,phii);
y_P = [P0(num1), P0(num1+1)];
P0_1 = interp1(x,y_P,phii);
y_e = [e0(num1), e0(num1+1)];
e0_1 = interp1(x,y_e,phii);
y_beta = [beta0(num1), beta0(num1+1)];
beta0_1 = interp1(x,y_beta,phii);
y_lambda = [lambda0(num1), lambda0(num1+1)];
lambda0_1 = interp1(x,y_lambda,phii);
y_dT = [dT(num1), dT(num1+1)];
dT_1 = interp1(x,y_dT,phii);
y_dP = [dP(num1), dP(num1+1)];
dP_1 = interp1(x,y_dP,phii);
y_de = [de(num1), de(num1+1)];
de_1 = interp1(x,y_de,phii);
y_dbeta = [dbeta(num1), dbeta(num1+1)];
dbeta_1 = interp1(x,y_dbeta,phii);
y_dlambda = [dlambda(num1), dlambda(num1+1)];
dlambda_1 = interp1(x,y_dlambda,phii);
end
if phi<0
D_min = 211;            
else
D_min =28;              
end
T = T0_1 - dT_1*cos(2*pi*(D-D_min)/365.25);
P = P0_1 - dP_1*cos(2*pi*(D-D_min)/365.25);
e = e0_1- de_1*cos(2*pi*(D-D_min)/365.25);
beta = beta0_1- dbeta_1*cos(2*pi*(D-D_min)/365.25);
lambda = lambda0_1- dlambda_1*cos(2*pi*(D-D_min)/365.25);
end