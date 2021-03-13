%This file is used for designing a digital butterworth filter%
%Desired specifications must be entered %
amax=input('Enter attenuation in the passband in dB   ');
amin=input('Enter attenuation in the stopband in dB   ');  
Fp=input('Enter passband frequency                  ');
Fs=input('Enter stopband frequency                  ');
Fsm=input('Enter sampling frequency                  ');
%Then filter order n is calculated%
Wp=2*pi*Fp/Fsm;Ws=2*pi*Fs/Fsm;
N=log10((10^(amin/10)-1)/(10^(amax/10)-1))/(2*log10(tan(.5*Ws)/tan(0.5*Wp)));
N=ceil(N);
%Kb and Wo are calculated for bilinear tranformation%
Wo=2*atan(tan(0.5*Ws)/(10^(amin/10)-1)^(1/(2*N)))
Kb=cot(0.5*Wo);
%Pole locations are found %
if mod(N,2)==0
    for i=0:2*N-1
        sk(i+1)=exp(j*pi*(2*i+1)/(2*N));
    end
else
    for i=0:2*N-1
        sk(i+1)=exp(j*pi*i/N);
    end
end
%Transfer function is calculated by applying bilinear transformation%
z=tf('z');
Hz=1;
for i=1:2*N
    if real(sk(i))<0
        Hz=Hz/(Kb*(1-z^-1)/(1+z^-1)-sk(i));
    end
end
%Magnitude response is plotted%
[B,A] = TFDATA(Hz,'v');
B=real(B);A=real(A);
s_number=0;
for k=1:length(A)
    if A(k)==0
        s_number=s_number+1;
    end
end
for k=1:length(A)-s_number
    Az(k)=A(k);
    Bz(k)=B(k);
end
[H,W] = FREQZ(Bz,Az);figure
plot(W,abs(H));
N

    