clc
clear all

Fs=200e3;
Ts=1/Fs;
dt=0:Ts:5e-3-Ts;

f1=1e3;
f2=20e3;
f3=30e3;
y1=5*sin(2*pi*f1*dt);
y=5*sin(2*pi*f1*dt)+5*sin(2*pi*f2*dt)+10*sin(2*pi*f3*dt);

% plot(dt,y)

nfft=length(y);
%nfft2=2.^nextpow2(nfft);
nfft2=nfft;

%fy=fft(y,nfft2);
fy=fft(y);
fy=fy(1:nfft2/2);
fy2=fft(y);
fy2=fy2(1:nfft/2);

xfft=Fs.*(0:nfft2/2-1)/nfft2;
xfft2=Fs.*(0:nfft/2-1)/nfft;
figure(1)
plot(xfft,abs(fy/max(fy)));
hold on
plot(xfft2,abs(fy2/max(fy2)));

cut_off_fre=1.5e3;
cut_off=cut_off_fre/Fs/2;

order=32;

h=fir1(order,cut_off);

fh=fft(h,nfft2);
fh=fh(1:nfft2/2);

mul=fh.*fy;

con=conv(y,h);

figure(2)
subplot(3,2,1);
plot(dt,y);
subplot(3,2,3);
stem(h);
subplot(3,2,5);
plot(con);

subplot(3,2,2)
plot(xfft,abs(fy/max(fy)));
subplot(3,2,4)
plot(xfft,abs(fh/max(fh)));
subplot(3,2,6)
plot(xfft,abs(mul));


%% Converting back into the time domain
tim=dt;
Yf=(fy)/2;
Y_mag = abs(Yf); %Magnitudes
Y_phase = angle(Yf); %Phase


N = length(Y_mag);
Bins = 1:floor(N/2);
%N=nfft;

time=tim;

for z = 1:1
    M = find(ismember(xfft,round(cut_off_fre,-3))); %Number of Harmonics
    %M=150
    A0 = (2/N(z))*real(Yf(z,1));
    Ak = (2/N(z))*real(Yf(z,2:M));
    Bk = -(2/N(z))*imag(Yf(z,2:M));
    %T(z) = D(z,[9]);
    T(z)=(5e-3);
for j = 1:length(time)
    y_rec(z,j) = A0/2;
    for i = 1:M-1
        temp_har = Ak(i)*cos(2*pi()*i*time(z,j)/T(z))+Bk(i)*sin(2*pi()*i*time(z,j)/T(z));
        y_rec(z,j) = y_rec(z,j)+temp_har;
    end
end
end


figure(3),plot(y_rec)
txt={['M=',num2str(M),' harmonics, Time Domain for RV pressure waveform']}
title(txt)
xlabel('Time(seconds)')
ylabel('RV pressure waveform (y_rec)')

yf_test=fft(y_rec);
yf_test=yf_test(1:length(yf_test)/2)
figure(4)
plot(abs(yf_test/max(yf_test)));
