%This file is used for designing an anolog chebyshev BPF%
%Desired specifications must be entered %
amax=input('Enter attenuation in the passband in dB   ');
amin=input('Enter attenuation in the stopband in dB   ');  
Wp=input('Enter passband frequency                  ');
Ws=input('Enter stopband frequency                  ');
%Then filter order n is calculated for normalized LPF%
BW=Wp(2)-Wp(1);Wcenter=sqrt(Wp(1)*Wp(2));
Wp_LPF=Wp(2)-Wcenter;Ws_LPF=Ws(2)-Wcenter;
N=acosh(sqrt((10^(amin/10)-1)/(10^(amax/10)-1)))/acosh(Ws_LPF/Wp_LPF);
N=ceil(N);
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
%Transfer function is calculated for LPF%
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
%Transfer function of BPF is calculated due to frequency transformation%
[B,A] = TFDATA(Hs,'v');
A=real(A);B=real(B);
s=tf('s');
HS=0;
for i=1:length(A)
    HS=A(i)*((s^2+Wcenter^2)/(BW*s))^(length(A)-i)+HS;
end
HS=B(length(B))/HS;
[B,A] = TFDATA(HS,'v');
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
%Magnitude response is plotted%
W=linspace(Ws(1),Ws(2),200);
H = FREQS(BS,AS,W);figure
plot(W,abs(H));
N=2*N
HS=tf(BS,AS)