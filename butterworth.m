%This file is used for designing an anolog butterworth filter%
%Desired specifications must be entered %
amax=input('Enter attenuation in the passband in dB   ');
amin=input('Enter attenuation in the stopband in dB   ');  
Wp=input('Enter passband frequency                  ');
Ws=input('Enter stopband frequency                  ');
%Then filter order n is calculated%
N=log10((10^(amin/10)-1)/(10^(amax/10)-1))/(2*log10(Ws/Wp));
N=ceil(N);
%Half power frequency Wo is calculated%
Wo=Ws/(10^(amin/10)-1)^(1/(2*N));
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
%Exact pole locations are found% 
sk=sk*Wo;
%Transfer function is calculated%
s=tf('s');
Hs=1;
for i=1:2*N
    if real(sk(i))<0
        Hs=Hs/(s-sk(i));
    end
end
%Gain is set to 1%
K=Wo^N;
Hs=K*Hs;
%Magnitude response is plotted, order and transfer function is displayed%
[B,A] = TFDATA(Hs,'v');
B=real(B);A=real(A);
[H,W] = FREQS(B,A);figure
for i=1:length(W)
    if W(i)<2*Ws
        Hzoom(i)=H(i);
        Wzoom(i)=W(i);
    end
end
plot(Wzoom,abs(Hzoom));
N
Hs=tf(B,A)
    