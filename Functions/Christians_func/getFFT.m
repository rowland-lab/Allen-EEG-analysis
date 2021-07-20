function [A,P,f] = getFFT(X,Fs)
% Perform fft on given signal X. The function returns the amplitude and power spectrum.
% X: one-dimensional vector containing the sampled signal
% Fs: sampling frequency of X

% A: amplitude of signal
% P: power of signal
% f: frequencies associated with A

% the result can be plotted as
% plot(f,A)
% xlabel('Frequency [Hz]')
% ylabel('Amplitude')

L = length(X); % length of sampled signal
NFFT = 2^nextpow2(L); % closest length that is a power of 2
Y = fft(X,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
A = 2*abs(Y(1:NFFT/2+1));
P = A.^2;