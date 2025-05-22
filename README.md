# LMS-Adaptive-Filter

This project was completed for my DSP-II class using MATLAB and involves designing an Adaptive Filter that removes noise using the Least Mean Square Algorithm.

__Files__
- DeviceIDFinder.m: Script to find the microphone ID
- adaptivefilter.m: Adaptive filter code

__How to Use__
- Run DeviceIDFinder.m to find your microphone ID. Enter Device ID as the 4th parameter on line 8 in adaptivefilter.m.
- You can change the number of taps or step size on lines 25/26 if wanted.
- Run the file, the Signal to Noise Ratio (SNR) before and after will be displayed, and plots will show up of the different signals.
- Inside the file of the project, the noisy input and output signals will be saved as .wav files.
