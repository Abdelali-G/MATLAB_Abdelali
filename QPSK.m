%% Input data in polar form (Modulator)
binary = [0 0 1 1 0 1 1 0 0 1]; % the input bit stream >> enter any number of bits
binarycode = binary;
DigData = 0 ;
X = 0.005; % pulse width over time 
Fc = 1000;
SR = 100000;
time = 0 : 1/(SR) :length(binarycode)*X  ;
for i = 1:1:length(binary) % Reconfig the binary data 1 = 1 while zero = -1 
    if (binary(i) == 1)    % from unipolar NRZ to Polar NRZ
        binarycode(i) = 1;
    else
         binarycode(i) = -1;
    end
end 
for i = 1:1:length(binarycode) % This Loop represents the binary digits in pulse form 
    if (binarycode(i) == 1)
        DigData = rectangularPulse(((i-1)*X),i*X,time) + DigData; %one is represented by +1
    else 
        DigData = -1*rectangularPulse(((i-1)*X),i*X,time) + DigData; %zero is represented by -1
    end 
end
%% serial to parallel converter
pbinary_even = zeros(1,0.5*length(binarycode)) ; % set even array
pbinary_odd = zeros(1,0.5*length(binarycode)) ; % set odd array
ne = 0 ;
no = 1 ;
for i = 1 : 1 : length(pbinary_even) % seperate binary data to even and odd
    pbinary_even(i) = binarycode(i+ne);
    ne = ne + 1 ;
end
for j = 1 : 1 : length(pbinary_even)
    pbinary_odd(j) = binarycode(j+no);
    no = no + 1 ;
end
% time = 0 : 1/(100*Fc) :length(pbinary_even)*X ;
DigData_even = 0;
DigData_odd = 0;
for i = 1:1:length(pbinary_even) % This Loop represents the binary even digits in pulse form 
    if (pbinary_even(i) == 1)
        DigData_even = rectangularPulse(((i-1)*(X)),i*(X),time) + DigData_even; %one is represented by +1
    else 
        DigData_even = -1*rectangularPulse(((i-1)*(X)),i*(X),time) + DigData_even; %zero is represented by -1
    end 
end
for i = 1:1:length(pbinary_odd) % This Loop represents the binary odd digits in pulse form 
    if (pbinary_odd(i) == 1)
        DigData_odd = rectangularPulse(((i-1)*(X)),i*(X),time) + DigData_odd; %one is represented by +1
    else 
        DigData_odd = -1*rectangularPulse(((i-1)*(X)),i*(X),time) + DigData_odd; %zero is represented by -1
    end 
end
%% Careier
Sc_I = cos( 2*pi*Fc*time);
Sc_Q = sin( 2*pi*Fc*time);
%% PSK 
ModSig = DigData_odd .* Sc_Q + DigData_even .* Sc_I  ;
%% PSK (Demodulator)
PSK1 = ModSig .* Sc_Q;
PSK2 = ModSig .* Sc_I;
PSK1 =  bandpass(PSK1,[900 1100],SR);
PSK2 =  bandpass(PSK2,[900 1100],SR);
PSK1_int = zeros(1, length(ModSig));
PSK2_int = zeros(1, length(ModSig));
for i=1:500:((length(ModSig)-500)/2)
    PSK1_int(i:i+500)= trapz(PSK1(i:i+500));
    if PSK1_int(i:i+500) > 1  
        PSK1_int(i:i+500) = 1;
    elseif PSK1_int(i:i+500) < 1
        PSK1_int(i:i+500) = -1 ;
    end
end
for i=1:500:((length(ModSig)-500)/2)
    PSK2_int(i:i+500)= trapz(PSK2(i:i+500));
    if PSK2_int(i:i+500) > 1
        PSK2_int(i:i+500) = 1;
    elseif PSK2_int(i:i+500) < 1
        PSK2_int(i:i+500) =-1;
    end
end
Digdata_out= zeros(1,5001);
j = 1;
for i = 1 : 1000:((length(ModSig)-500))
   Digdata_out(i:i+500)= PSK2_int(j:j+500);
   Digdata_out(i+500:i+1000)= PSK1_int(j:j+500);
   j = j +500;
end
%% Plots
subplot (9,1,1)
plot(time,DigData,'LineWidth',2)
title("Binary Data");
ylabel("Amplitude")
subplot (9,1,2)
plot(time,DigData_even,'LineWidth',2)
title("Binary Data_ even");
ylabel("Amplitude")
subplot (9,1,3)
plot(time,DigData_odd,'LineWidth',2)
title("Binary Data_ odd");
ylabel("Amplitude")
subplot (9,1,4)
plot(time,Sc_I,'LineWidth',2)
title("Carrier");
ylabel("Amplitude")
subplot (9,1,5)
plot(time,Sc_Q,'LineWidth',2)
title("Carrier + Shift 90");
ylabel("Amplitude")
subplot (9,1,6)
plot(time,ModSig,'LineWidth',2)
title("Modulated Signal");
ylabel("Amplitude")
subplot (9,1,7)
plot(time,PSK2_int,'LineWidth',2)
title("Binary Data_ even");
ylabel("Amplitude")
subplot (9,1,8)
plot(time,PSK1_int,'LineWidth',2)
title("Binary Data_ odd");
ylabel("Amplitude")
subplot (9,1,9)
plot(time,Digdata_out,'LineWidth',2)
title("Binary Data");
ylabel("Amplitude")
xlabel("Time")