sizes = 0;
CHANNEL_ID = 147;
MIN_SIZE = 5000;
STIMULUS = 'Face';
FIXED_SIZE = 5000;
channels = zeros(size(epochs,1), FIXED_SIZE);
counter = 1;
for i = 1:size(epochs,1)
    label = labels(i, 1);
    epoch = epochs{i,1};
    if strcmp(label{1, 1}, STIMULUS) && size(epoch, 2) > MIN_SIZE
        sizes(counter) = size(epoch,2);
        
        for j = 1:FIXED_SIZE
            channels(counter, j) = epoch(CHANNEL_ID, j);
        end
        counter = counter + 1;
    end
    
    
    
end
channels = channels(1:counter, :);
L = size(channels,2);
Fs = 1000;
Y_all = zeros(counter, size(channels, 2));
for i = 1:counter
    Y_all(i,:) = fft(channels(i, :));
    
    
end

Y = mean(Y_all, 1);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
xlim([2, 10])