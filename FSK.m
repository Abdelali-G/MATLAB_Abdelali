%% Input
% define the data signal for any number of bits
binarycode = [1 1 0 1 0 1 0 0 1 1 0 1];
Fc = 1000;  %Carier Frequency
SR = 100000;
X = 0.005; % pulse width over time 
time = 0 : 1/SR :length(binarycode)*X ;
Sc = cos ( 2*pi*2*Fc*time);
Sc_ = cos ( 2*pi*Fc*time);
DigData = 0 ;
for i = 1:1:length(binarycode) % This Loop represents the binary code in pulse form
    if (binarycode(i) == 1)
        DigData = rectangularPulse(((i-1)*X),i*X,time) + DigData;
    end 
end
%% Modulator
ModSignal = zeros(1,length(DigData));
for i = 1:1:length(DigData)
    if (DigData(i) <= 0)
        ModSignal(i) = Sc_(i);
    else
        ModSignal(i) = Sc(i);
    end
end
%% Bandpass filter
Output = bandpass(ModSignal,[1950 2050],SR);
%% Rectifire + Hilbert
OutputH = hilbert(Output);
OutputH_abs = abs(Rec_ModSignal);
% for i = 1:1:length(DigData)
%     if (Output(i) <0)
%         Rec_ModSignal(i) = -1*Output(i);
%     end
% end
%% Comparator
Threshold = 0.498*ones(1,length(DigData));
Com_Dem_Signal = OutputH_abs;
for i = 1:1:length(OutputH_abs)
    if (OutputH_abs(i) < Threshold)
        Com_Dem_Signal(i) =0;
    else
        Com_Dem_Signal(i) = 1;
    end
end
%% Plots        
subplot (7,1,1)
plot(time,DigData ,'LineWidth',2)
title("Binary Data");
subplot (7,1,2)
plot(time,Sc,'LineWidth',2)
title("First Carry");
subplot (7,1,3)
plot(time,Sc_,'LineWidth',2)
title("Seconed Carry");
subplot (7,1,4)
plot(time,ModSignal,'LineWidth',2)
title("ModSignal");
subplot (7,1,5)
plot(time,Output,'LineWidth',2)
title("Rec ModSignall after LPF");
hold on
subplot (7,1,6)
plot(time,Rec_ModSignal,'LineWidth',2);
title("Demodulated Signal");
subplot (7,1,7)
% plot(time,Threshold,'LineWidth',2)
plot(time,Com_Dem_Signal,'LineWidth',2)
title("Threshold");
xlabel("Time");
