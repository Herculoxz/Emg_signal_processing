% Clear the workspace to avoid any shadowing issues
clear;
% NOTE : this code works for the dataset in .txt file. make sure u have it in your matlab drive.

% Read the EMG data from the text file
data = readmatrix('/MATLAB Drive/EMG_data_for_gestures-master/01/1_raw_data_13-12_22.03.16.txt');

% Extract the time and EMG channels
time = data(:, 1);
emg_channels = data(:, 2:9);

% Sampling frequency (assuming time is in seconds)
fs = 1 / (time(2) - time(1));  % Sampling frequency in Hz

% Compute the FFT for each channel
N = length(time);  % Number of samples
f = (0:N-1) * (fs / N);  % Frequency range

fft_emg_data = fft(emg_channels);  % Renamed variable to avoid shadowing

% Compute the single-sided amplitude spectrum
fft_emg_amp = abs(fft_emg_data / N);
fft_emg_amp = fft_emg_amp(1:N/2+1, :);
fft_emg_amp(2:end-1, :) = 2 * fft_emg_amp(2:end-1, :);

% Frequency vector for the single-sided spectrum
f_single_sided = f(1:N/2+1);

% Compute the Power Spectral Density (PSD)
psd_emg = (1 / (fs * N)) * abs(fft_emg_data).^2;  % Using the renamed variable
psd_emg = psd_emg(1:N/2+1, :);
psd_emg(2:end-1, :) = 2 * psd_emg(2:end-1, :);

% Plot the raw EMG signals for each channel
figure;
for i = 1:8
    subplot(4, 2, i);
    plot(time, emg_channels(:, i));
    title(['Channel ' num2str(i) ' Raw EMG Signal']);
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;
end

% Plot the FFT and PSD for each channel
figure;
for i = 1:8
    subplot(4, 2, i);
    plot(f_single_sided, fft_emg_amp(:, i));
    title(['Channel ' num2str(i) ' FFT']);
    xlabel('Frequency (Hz)');
    ylabel('Amplitude');
    grid on;
end

figure;
for i = 1:8
    subplot(4, 2, i);
    plot(f_single_sided, 10*log10(psd_emg(:, i)));
    title(['Channel ' num2str(i) ' PSD']);
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');
    grid on;
end

