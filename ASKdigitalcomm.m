binarycode = [1 1 0 1 0 1 0 0 1 1 0 1];
Fc = 1000;  %Carier Frequency
SR = 100000;
X = 0.005; % pulse width over time 
time = 0 : 1/SR :length(binarycode)*X ;
Sc = cos ( 2*pi*Fc*time);
DigData = 0 ;
for i = 1:1:length(binarycode) % This Loop represents the binary code in pulse form
    if (binarycode(i) == 1)
        DigData = rectangularPulse(((i-1)*X),i*X,time) + DigData;
    end 
end
ModSignal = Sc.*DigData; % Multiplying the binary sequance by the carrier signal
%% Rectifier
Rec_ModSignal = ModSignal;
for i = 1:1:length(DigData)
    if (ModSignal(i) <0)
        Rec_ModSignal(i) = -1*ModSignal(i);
    end
end
%% Filter
Dem_Signal = lowpass(Rec_ModSignal,100,SR)  ; 
%% Comparator
Threshold = 0.19*ones(1,length(DigData));
Com_Dem_Signal = Dem_Signal;
for i = 1:1:length(DigData)
    if (Dem_Signal(i) <Threshold)
        Com_Dem_Signal(i) =0;
    else
        Com_Dem_Signal(i) =1;
    end
end
%% Plots    
subplot (6,1,1)
plot(time,DigData,'LineWidth',2)
title("Binary Data");
subplot (6,1,2)
plot(time,Sc,'LineWidth',2)
title("Carry Signal");
subplot (6,1,3)
plot(time,ModSignal,'LineWidth',2)
title("Modulated Signal");
subplot (6,1,4)
plot(time,Rec_ModSignal,'LineWidth',2)
title("Rec ModSignall");
subplot (6,1,5)
plot(time,Dem_Signal,'LineWidth',2)
title("Rec ModSignall after LPF");
hold on
plot(time,Threshold,'LineWidth',2)
title("Threshold");
subplot (6,1,6)
plot(time,Com_Dem_Signal,'LineWidth',2);
title("Demodulated Signal");
xlabel("Time");

