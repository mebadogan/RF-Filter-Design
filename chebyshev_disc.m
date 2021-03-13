%This file is used for designing a digital chebyshev filter%
%Desired specifications must be entered %
amax=input('Enter attenuation in the passband in dB   ');
amin=input('Enter attenuation in the stopband in dB   ');  
Fp=input('Enter passband frequency                  ');
Fs=input('Enter stopband frequency                  ');
Fsm=input('Enter sampling frequency                  ');
%Then filter order n is calculated%
Wp=2*pi*Fp/Fsm;Ws=2*pi*Fs/Fsm;
N=acosh(sqrt((10^(amin/10)-1)/(10^(amax/10)-1)))/acosh(tan(.5*Ws)/tan(.5*Wp));
N=ceil(N);
%Kc is calculated for bilinear tranformation%
Kc=cot(0.5*Wp);
%Pole locations are found %
e=sqrt(10^(amax/10)-1);
a=1/N*acosh(1/e);
for i=0:2*N-1
    ak(i+1)=sinh(a)*sin((2*i+1)*pi/(2*N));
    wk(i+1)=cosh(a)*cos((2*i+1)*pi/(2*N));
end
sk=ak+j*wk;
s=tf('s');
Hs=1;
for i=1:2*N
    if real(sk(i))<0
        Hs=Hs/(s-sk(i));
    end
end
%Gain is set to 1%
[B,A] = TFDATA(Hs,'v');
if mod(N,2)==0
    K=sqrt(1/(1+e^2))*A(length(A));
else
    K=A(length(A));
end
%Transfer function is calculated by applying bilinear transformation%
z=tf('z');
Hz=K;
for i=1:2*N
    if real(sk(i))<0
        Hz=Hz/(Kc*(1-z^-1)/(1+z^-1)-sk(i));
    end
end
%Magnitude response is plotted%
[B,A] = TFDATA(Hz,'v');
[H,W] = FREQZ(B,A);figure
plot(W,abs(H));
N