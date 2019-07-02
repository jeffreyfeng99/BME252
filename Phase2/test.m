t = 0:1/100:10-1/100;                     
x = sin(2*pi*15*t) + sin(2*pi*20*t) + sin(2*pi*45*t);
plot(t,x)

out = abs(fft(x));
out = out(1:length(t)/2);
%f = (0:length(t)/2-1)*50/length(t)
f = 0:0.1:(length(t)/2-1)*0.1;
plot(f,out)

figure
[b,a] = butter(5, [1 10]/10);
filtered1 = filter(b,a,x);
out = abs(fft(filtered1));
out = out(1:length(t)/2)
f = (0:length(t)/2-1)*100/length(t);
%f = 0:0.1:(length(t)/2-1)*0.1;
plot(f,out)
ylim([0,200])



