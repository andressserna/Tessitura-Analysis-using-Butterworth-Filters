clc 
clear all
close all

%Importar el audio
[a,fs]=audioread("Prueba1.wav");
duracion=length(a)/fs;

[b,fs1]=audioread("Prueba2.wav");
duracion1=length(b)/fs;

a_m= 0.5*(a(:,1)+a(:,2));
b_m= 0.5*(b(:,1)+b(:,2));
t=linspace(0,duracion,length(a_m));
t1=linspace(0,duracion1,length(b_m));
%figure(1);
%plot(t,a_m,t1,b_m);


A_m=fftshift(fft(a_m));
B_m=fftshift(fft(b_m));

f=linspace(-fs/2,fs/2,length(A_m));
f1=linspace(-fs/2,fs/2,length(B_m));

magnitud_A=abs(A_m);
MagNor=magnitud_A/max(magnitud_A);
magnitud_B=abs(B_m);
MagNor1=magnitud_B/max(magnitud_B);
%figure(1);
%plot(f,MagNor,f1,MagNor1);

%Determinar frecuencias de corte
% Para Soprano 261-1046Hz
fmin=261;
fmax=1046;
Wnmin=2*pi*fmin/(fs/2);
Wnmax=2*pi*fmax/(fs/2);
Wn=[Wnmin Wnmax];


%Diseño del filtro 

n=4;
[num den]=butter(n/2,Wn,'bandpass');
sfiltrada=filter(num,den,MagNor);
sfiltrada1=filter(num,den,MagNor1);


%Respuesta en frecuencia del filtro
figure(2);
title('Respuesta en frecuencia del filtro')
[h w]=freqz(num,den);
plot(w,abs(h));
xlabel("Frecuencia kHz");
ylabel("Amplitud");

%Filtrado
figure(3);

plot(f,MagNor,f,abs(sfiltrada));
title("Audio 1");
ylim([0 0.25]);
xlim([-1000 1000])
xlabel("Frecuencia Hz");
ylabel("Amplitud");
legend( 'Original','Filtrada')

figure(4);

plot(f1,MagNor1,f1,abs(sfiltrada1))
title("Audio 2");
ylim([0 0.25]);
xlim([-1000 1000])
xlabel("Frecuencia Hz");
ylabel("Amplitud");
legend( 'Original','Filtrada');

%Caracterizacion del filtro

funcionTransferencia = tf(num,den);
figure(5)
bode(funcionTransferencia)
figure(6)
pzplot(funcionTransferencia)

