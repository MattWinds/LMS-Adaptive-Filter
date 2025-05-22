%Matthew Windsor
%DSP2
%Adaptive Filter


%----------------------------------------------------------------
%Record voice
voice = audiorecorder(44100, 16, 1, 2); %(fs, bits, channels, deviceID)
disp("Speak");
recordblocking(voice, 3);   %(object,duration)
disp("Recording Done");

%Get voice data
voice_signal = getaudiodata(voice);

%Create noise
delay = 5;  %Simulate real world delay
ref_noise = .05 * randn(length(voice_signal),1);    %Create noise
ref_noise = [zeros(delay,1); ref_noise(1:end-delay)];   %Simulate delayed interference, [0 0 0 0 0, noise]

%Create noisy input (desired signal)
d = voice_signal + ref_noise;
%-----------------------------------------------------------------
%Initializations
taps = 128;   %Number of taps
mu = .01;   %Step size
w = zeros(taps, 1);    %Filter Coefficients (column vector length of taps)
e = zeros(length(d),1); %Error (column vector length of signal)
W = zeros(taps, length(d)); %Weights (taps x length of signal)

%Loop for filtering
for n = taps:length(d)  %# of taps to length of signal
    x = ref_noise(n:-1:n-taps+1); %x(n), buffered noise column vector from x(n) to x(n-M+1)
    y(n) = w' * x;   %y(n), output of filter = w^T(n) * x(n)
    e(n) = d(n) - y(n); %e(n), error between desired and output of filter
    w = w + (mu * e(n) * x); %w, weight updates w(n+1) = w(n) + stepsize*error*x(n)
    W(:, n) = w;    %Storing weights for plotting
end
%-----------------------------------------------------------------
%Normalize signals between [-1,1]
voice_norm = voice_signal / max(abs(voice_signal));
d_norm = d / max(abs(d));
e_norm = e / max(abs(e));

%Save voice recordings
audiowrite('Input.wav', d_norm, 44100);   %d(n)
audiowrite('Output.wav', e_norm, 44100);   %e(n)

t = (0:length(voice_signal)-1)/44100;   %0 to time in seconds

%Plotting Amplitude of clean (s(n), noise x(n), noisy d(n), and filtered e(n))
figure;
subplot(3,1,1);
plot(t, voice_norm);
title('Clean Voice Signal s(n)');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,2);
plot(t, ref_noise);
title('Noise Signal x(n)');
xlabel('Time (s)');
ylabel('Amplitude');

figure;
subplot(3,1,1);
plot(t, d_norm);
title('Noisy Input Signal d(n)');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,2);
plot(t, e_norm);
title('Filtered Output e(n)');
xlabel('Time (s)');
ylabel('Amplitude');

%Plotting power of error
figure;
plot(10*log10(e.^2));
title('Error Power (dB) v Time');
xlabel('Sample'); ylabel('Error Power (dB)');

%SNR calculation
snr_before = 10*log10(sum(voice_signal.^2) / sum((d - voice_signal).^2));
snr_after = 10*log10(sum(voice_signal.^2) / sum((e - voice_signal).^2));

%Print SNR
fprintf("SNR Before Filtering: %.2f dB\n", snr_before);
fprintf("SNR After Filtering: %.2f dB\n", snr_after);