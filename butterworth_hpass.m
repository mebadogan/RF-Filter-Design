%This file is used for designing an anolog highpass butterworth%
%filter. Desired specifications must be entered %
amax=input('Enter attenuation in the passband in dB   ');
amin=input('Enter attenuation in the stopband in dB   ');  
Wp=input('Enter passband frequency                  ');
Ws=input('Enter stopband frequency                  ');
%Then filter order n is calculated for normalized LPF%
N=log10((10^(amin/10)-1)/(10^(amax/10)-1))/(2*log10(Wp/Ws));
N=ceil(N);
%Half power frequency Wo is calculated%
Wo=Wp/(10^(amin/10)-1)^(1/(2*N));
%Pole locations are found due to narmalized frequency Wo=1%
if mod(N,2)==0
    for i=0:2*N-1
        sk(i+1)=exp(j*pi*(2*i+1)/(2*N));
    end
else
    for i=0:2*N-1
        sk(i+1)=exp(j*pi*i/N);
    end
end
%Transfer function is calculated due to frequency transformation%
s=tf('s');
Hs=1;
for i=1:2*N
    if real(sk(i))<0
        Hs=Hs/((Wp/s)-sk(i));
    end
end
%Magnitude response is plotted%
[B,A] = TFDATA(Hs,'v');
A=real(A);B=real(B);
s_number=0;
for k=1:length(A)
    if A(k)==0
        s_number=s_number+1;
    end
end
for k=1:length(A)-s_number
    AS(k)=A(k);
    BS(k)=B(k);
end
W=linspace(Ws/2,2*Wp,200);
H = FREQS(BS,AS,W);figure
plot(W,abs(H));
N
HS=tf(BS,AS)
    