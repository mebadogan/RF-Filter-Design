%This file is used for designing an anolog highpass chebyshev%
%filter. Desired specifications must be entered %
amax=input('Enter attenuation in the passband in dB   ');
amin=input('Enter attenuation in the stopband in dB   ');  
Ws=input('Enter passband frequency                  ');
Wp=input('Enter stopband frequency                  ');
%Then filter order n is calculated for normalized LPF%
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
%Transfer function is calculated due to frequency transformation%
s=tf('s');
Hs=1;
for i=1:2*N
    if real(sk(i))<0
        Hs=Hs/((Ws/s)-sk(i));
    end
end
%Gain is set to 1 from normalized LPF's poles%
Hsk=1;
for i=1:2*N
    if real(sk(i))<0
        Hsk=Hsk/(s-sk(i));
    end
end
[B,A] = TFDATA(Hsk,'v');
if mod(N,2)==0
    K=sqrt(1/(1+e^2))*A(length(A));
else
    K=A(length(A));
end
Hs=K*Hs;
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
W=linspace(Wp/2,2*Ws,200);
H = FREQS(BS,AS,W);figure
plot(W,abs(H));
N
HS=tf(BS,AS)