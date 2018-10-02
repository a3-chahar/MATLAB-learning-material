% Example script to demonstrate removal of mains frequency from a a voltage
% trace (synthetic data).
% Gary Atkinson, Sept 2017

clear
clc
close all

%% Synthesise signal

% set amplitudes and frequencies of components
A1 = 2;
f1 = 10;
A2 = 5;
f2 = 50;
% number of points in sample
N = 1000;

% generate signal
t = linspace(0,1,N);
y1 = A1*sin(2*pi*f1*t);
y2 = A2*sin(2*pi*f2*t);
z = y1+y2;

% plot data
subplot(321);
plot(t,y1,t,y2)
xlabel('Time, t (s)');
ylabel('Voltage, V (V)');
ylim([-max([A1 A2 max(z)]) max([A1 A2 max(z)])]);
title('Components of synthetic signal');
subplot(323);
plot(t,z);
xlabel('Time, t (s)');
ylabel('Voltage, V (V)');
ylim([-max([A1 A2 max(z)]) max([A1 A2 max(z)])]);
title('Combined synthetic signal');

%% Break down signal and remove noise

% Fourier transform for spectral density
Z = fft(z,N);
P = Z.*conj(Z)/N;
f = ifftshift(-floor(N/2):floor(N/2-1));

% plot spectrum
subplot(222);
plot(f(f>0),P(f>0),'.-')
title('Power spectral density')
xlabel('Frequency (Hz)')
xlim([0 100])

% remove mains signal
P(abs(f)>40 & abs(f)<60) = 0;

% plot modified signal
subplot(224);
plot(f(f>0),P(f>0),'.-')
title('Modified power spectral density')
xlabel('Frequency (Hz)')
xlim([0 100])

%% Reconstruct signal without noise

% inverse Fourier transform to recover time domain data
Z_ = Z(:);
Z_(abs(f)>45 & abs(f)<55) = 0;
zz = ifft(Z_);


% plot recovered signal
subplot(325);
plot(t,zz);
xlabel('Time, t (s)');
ylabel('Voltage, V (V)');
ylim([-max([A1 A2 max(z)]) max([A1 A2 max(z)])]);
title('Recovered signal');