%% Input + Modulator
binary = [0 1 1 1 0 1 0 1 0 0 0 1 1 0 1 0]; % the input bit stream >> enter any number of bits
binarycode = binary;
for i = 1:1:length(binary) % Reconfig the binary data 1 = 1 while zero = -1 
    if (binary(i) == 1)    % from unipolar NRZ to Polar NRZ
        binarycode(i) = 1;
    else
         binarycode(i) = -1;
    end
end    
Fc = 1000;  %Carier Frequency
X = 0.005; % pulse width over time 
time = 0 : 1/(100*Fc) :length(binarycode)*X ;
Sc = cos ( 2*pi*Fc*time);
DigData = 0 ;
for i = 1:1:length(binarycode) % This Loop represents the binary digits in pulse form 
    if (binarycode(i) == 1)
        DigData = rectangularPulse(((i-1)*X),i*X,time) + DigData; %one is represented by +1
    else 
        DigData = -1*rectangularPulse(((i-1)*X),i*X,time) + DigData; %zero is represented by -1
    end 
end
ModSignal = Sc.*DigData; % Multiplying the binary sequance by the carrier signal
% if the digital signal is switched from 1 to -1 , the carry signal
% will be phase shifted 180 degree
%% Demodulator
Output = ones(1 , length(DigData));
a = ((length(DigData)-1)/length(binary));
for i = a/2 : a : (length(DigData))
  if  ((ModSignal(i)> 0 && Sc(i)> 0) || ((ModSignal(i) < 0 && Sc(i) < 0)))
      Output(i-a/2+1:i +a/2) = Output(i-a/2+1:i +a/2)* 1 ;
  elseif ((ModSignal(i)> 0 && Sc(i) < 0) || ((ModSignal(i) < 0 && Sc(i) > 0)))
      Output(i-a/2+1:i +a/2) = Output(i-a/2+1:i +a/2)* -1 ;
  end
end
%% Plots    
subplot (4,1,1)
plot(time,DigData,'LineWidth',2)
title("Binary Data");
subplot (4,1,2)
plot(time,Sc,'LineWidth',2)
title("Carry Signal");
subplot (4,1,3)
plot(time,ModSignal,'LineWidth',2)
title("Modulated Signal");
subplot (4,1,4)
plot(time,Output,'LineWidth',2)
title("Output");
xlabel("Time")