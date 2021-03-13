%This file is used for designing an anolog chebyshev filter%
%Desired specifications must be entered %
amax=input('Enter attenuation in the passband in dB   ');
amin=input('Enter attenuation in the stopband in dB   ');  
Wp=input('Enter passband frequency                  ');
Ws=input('Enter stopband frequency                  ');
%Then filter order n is calculated%
N=acosh(sqrt((10^(amin/10)-1)/(10^(amax/10)-1)))/acosh(Ws/Wp);
N=ceil(N)
%Pole locations are found due to narmalized frequency Wp=1%
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
%Exact pole locations are found% 
sk=sk*Wp;
%Transfer function is calculated%
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
plot(Wzoom,abs(Hzoom))
N
Hs=tf(B,A)