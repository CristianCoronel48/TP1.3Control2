% El codigo a partir de leer la repuesta al escalon te devuelve la FT
%Codigo realizado por JAP 
% El codigo a partir de leer la repuesta al escalon te devuelve la FT
%Codigo realizado por JAP
%Revisar en https://github.com/Julianpucheta/OptimalControl/blob/main/ID_CHEN.ipynb
clear all; clc;
[x1]=xlsread('Curvas_Medidas_RLC'); % lee los datos de la planilla excel
t0=x1(:,1);%vector de tiempo
y=x1(:,3); figure;plot(t0,y,'.')
t_ret= .0101; %Tiempo de offset, en el que empieza a existir entrada escalón
t_inic= .0131 - t_ret; %tiempo al que se debe restar el tiempo arranque de escalón
[val,lugar] = min(abs(t_inic+t_ret-t0)); y_t1=y(lugar);
t_t1= t0(lugar) - t_ret; %Escala t1 de Chen
ii=0;
ii=ii+1;
[val,lugar] =min(abs(2*t_inic + t_ret -t0));
t_2t1= t0(lugar) - t_ret;
y_2t1=y(lugar);
[val,lugar] =min(abs(3*t_inic + t_ret-t0));
t_3t1= t0(lugar) - t_ret;
y_3t1=y(lugar);
t_end=.0483;
[val,lugar] =min(abs(t_end-t0));
K=y(lugar)/12; %valor del escalon de 12 voltios
k1=(1/12)*y_t1/K-1;%Afecto el valor del Escalon
k2=(1/12)*y_2t1/K-1;
k3=(1/12)*y_3t1/K-1;
be=4*k1^3*k3-3*k1^2*k2^2-4*k2^3+k3^2+6*k1*k2*k3;
alfa1=(k1*k2+k3-sqrt(be))/(2*(k1^2+k2));
alfa2=(k1*k2+k3+sqrt(be))/(2*(k1^2+k2));
beta=(k1+alfa2)/(alfa1-alfa2);
T1_ang=-t_t1/log(alfa1);
T2_ang=-t_t1/log(alfa2);
T3_ang=beta*(T1_ang-T2_ang)+T1_ang;
T1(ii)=T1_ang;
T2(ii)=T2_ang;
T3(ii)=T3_ang;
T3_ang=sum(T3/length(T3));
T2_ang=sum(T2/length(T2));
T1_ang=sum(T1/length(T1));
sys_G_ang=tf(K,conv([real(T1_ang) 1],[real(T2_ang) 1]))
[yo,to]=step(12*sys_G_ang); % step(12*sys_G_ang);
plot(t0,y,'r'), hold on;
plot(t_t1 + t_ret,y_t1,'o')
plot(t_2t1+ t_ret,y_2t1,'o')
plot(t_3t1+ t_ret,y_3t1,'o')
plot(to+t_ret,yo,'.k')
