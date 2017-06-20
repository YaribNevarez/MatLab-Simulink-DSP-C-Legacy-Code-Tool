clc
disp('Poxi initialization ...')
clear
format long
%%%%%%%%%%%%%%%%%%%%%%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%
fh = 3;     % Low pass cut-off frecuency
Lowpass_Order = 6;
fl = 50/60;    % High pass cut-off frecuency
Highpass_Order = 4;
T = .001;    % Sample time

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate DSP.H
 Butterworth_POXI(fh, Lowpass_Order, fl, Highpass_Order, T)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
F = 1/T;

[BH,AH]=butter(Highpass_Order,fl/(F/2),'high');
[BL,AL]=butter(Lowpass_Order,fh/(F/2),'low');

%%%%%%%%%%%%%%%%%%%% Transfer functions %%%%%%%%%%%%%%%%%%%%
DHighPass = filt(BH,AH,T)
DLowPass = filt(BL,AL,T)

CHighPass = d2c(DHighPass);
CLowPass = d2c(DLowPass);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[BHC,AHC] = tfdata(CHighPass,'v');
[BLC,ALC] = tfdata(CLowPass,'v');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Frecuency responce
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% High Pass filter
w = linspace(0, 2*fl, 100)';
magH = freqresp(DHighPass, w, 'Hz');
magH = abs(magH(:));

figure
subplot(6,2,1);
plot(w,magH);
grid
title('POXI - High pass filter frequency response')
xlabel('Hz');
ylabel('Mag');
subplot(6,2,2);
step(DHighPass);
% Low Pass filter
w = linspace(0, 10*fh, 100)';
magL = freqresp(DLowPass, w, 'Hz');
magL = abs(magL(:));
subplot(6,2,3);
plot(w,magL);
grid
title('POXI - Low pass filter frequency response')
xlabel('Hz');
ylabel('Mag');
subplot(6,2,4);
step(DLowPass);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load ..\JAVA_APP\poxi\poxi_adc.dat
subplot(6,2,[5,6]);
time = poxi_adc(:,1);
u    = poxi_adc(:,2);
plot(time,u)
title('POXI ADC SIGNAL')
ylabel('Mag');
legend('ADC Original')
grid

subplot(6,2,[7,8]);
plot(time,filter(BH,AH,filter(BL,AL,u)));
title('LOW-HIGH PASS FILTERED SIGNAL')
ylabel('Mag');
legend('Low High Pass Filtered')
grid

subplot(6,2,[9,10]);
plot(time,filter(BL,AL,u));
title('LOW PASS FILTERED SIGNAL')
ylabel('Mag');
legend('Low pass Filtered')
grid

subplot(6,2,[11,12]);
plot(time,filter(BH,AH,u));
title('HIGH PASS FILTERED SIGNAL')
xlabel('Time (S)');
ylabel('Mag');
legend('High pass Filtered')
grid

%signal.time = (T:T:length(u)*T)';
signal.time = time;
signal.signals.values = [u];
signal.signals.dimensions = 1;

disp('Done !')