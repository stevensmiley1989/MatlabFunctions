

clc
clear all
close all

fs = 1000; %Hz
T = 1; 
dt = 1/fs;

t = 0:dt:T-dt;
f1 = 20; f2 = 35; f3 = 10;

y1 = 3*cos(2*pi()*f1*t);
y2 = 1*cos(2*pi()*f2*t);
y3 = 9*cos(2*pi()*f3*t);

yrand = rand(fs,1);
%yt = y1+y2+y3+2*yrand;
yt = y1+y2+y3;

subplot(4,1,1)
plot(t,y1)
subplot(4,1,2)
plot(t,y2)
subplot(4,1,3)
plot(t,y3)
subplot(4,1,4)
plot(t,yt)

%% Looking at the frequency domain
Yf = fft(yt)

Y_mag = abs(Yf); %Magnitudes
Y_phase = angle(Yf); %Phase


N = length(Y_mag);
Bins = 1:floor(N/2);

for k = 1:length(Bins)
    freq(k) = (k-1)*fs/(N);
end


%figure, plot(freq,Yf(1:floor(N/2))) 
figure, plot(freq,Y_mag(1:floor(N/2))) 
ylabel('Magnitude')
xlabel('frequency(hz)')

%% Converting back into the time domain

M = 12; %Number of Harmonics
A0 = (2/N)*real(Yf(1));
Ak = (2/N)*real(Yf(2:M));
Bk = -(2/N)*imag(Yf(2:M));


time = linspace(0,1,500);

for j = 1:500
    y_rec(j) = A0/2;
    for i = 1:M-1
        temp_har = Ak(i)*cos(2*pi()*i*time(j)/T)+Bk(i)*sin(2*pi()*i*time(j)/T);
        y_rec(j) = y_rec(j)+temp_har;
    end
end

figure
plot(t,yt,'o')
hold on
plot(time,y_rec)
xlabel('Time(seconds)')
ylabel('y-Time Domain')
txt={['M=',num2str(M),' harmonics, Time Domain for RV pressure waveform']}
title(txt)

figure(99)
plot(t,yt)

figure(100)
plot(time,y_rec)

for z = 1:1

    A0 = (2/N(z))*real(Yf(z,1));
    Ak = (2/N(z))*real(Yf(z,2:M));
    Bk = -(2/N(z))*imag(Yf(z,2:M));
    %T(z) = D(z,[9]);
    T(z)=T;
for j = 1:length(time)
    y_rec(z,j) = A0/2;
    for i = 1:M-1
        temp_har = Ak(i)*cos(2*pi()*i*time(z,j)/T(z))+Bk(i)*sin(2*pi()*i*time(z,j)/T(z));
        y_rec(z,j) = y_rec(z,j)+temp_har;
    end
end
end

figure(101)
plot(time,y_rec)

yf_test=fft(y_rec);
figure(4)
plot(abs(yf_test/max(yf_test)));