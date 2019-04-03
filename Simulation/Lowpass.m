%===============================================================================
% Lowpass Filter Design
%
% Specifications
order = 6;
cutoff_freq = 20e3;
pointNbr = 1000;
R = 100;

%-------------------------------------------------------------------------------
% Filter Design
[Num,Den] = BUTTER(order, 2*pi*cutoff_freq, 's');

%-------------------------------------------------------------------------------
% Filter Analysis
freq = logspace(log10(cutoff_freq)-3,log10(cutoff_freq)+2,pointNbr);
H = FREQS(Num,Den,2*pi*freq);
A = 20*log10(abs(H)/2);

semilogx(freq, A, 'g');
grid;

f_tail = freq(A<-20*order);
f_damped = f_tail(1);

lc_values = TF2LC(Num,Den)/cutoff_freq;
[A,B,C,D] = LC2SS(lc_values);

[Num_lc,Den_lc] = ss2tf(A,B,C,D);

H_lc = FREQS(Num_lc,Den_lc,2*pi*freq);
A_lc = 20*log10(abs(H_lc));

%hold on;
%semilogx(freq, A_lc);
%hold off;

%-------------------------------------------------------------------------------
% Frequency Bessel Correction
f_tail = freq(A_lc<-20*order);
f_lc_damped = f_tail(1);

scaling = f_damped/f_lc_damped;
lc_values = lc_values / scaling;

[A,B,C,D] = LC2SS(lc_values);

[Num_lc,Den_lc] = ss2tf(A,B,C,D);

H_lc = FREQS(Num_lc,Den_lc,2*pi*freq);
A_lc = 20*log10(abs(H_lc));

hold on;
semilogx(freq, A_lc, 'b');
hold off;

%-------------------------------------------------------------------------------
% Resistor Scaling C = values/R L = values*R
lc_values
for i = [2:2:order]
    lc_values(i) = lc_values(i)/R;
    lc_values(i)
end 
for i = [1:2:order]
    lc_values(i) = lc_values(i)*R;
    lc_values(i)
end 

%-------------------------------------------------------------------------------
% Real element values
lc_values = [150e-6, 57e-9, 820e-6, 115e-9, 1.5e-3, 330e-9 ]
for i = [2:2:order]
    lc_values(i) = lc_values(i)*R;
    lc_values(i)
end 
for i = [1:2:order]
    lc_values(i) = lc_values(i)/R;
    lc_values(i)
end

[A,B,C,D] = LC2SS(lc_values);

[Num_lc,Den_lc] = ss2tf(A,B,C,D);

H_lc = FREQS(Num_lc,Den_lc,2*pi*freq);
A_lc = 20*log10(abs(H_lc));

hold on;
semilogx(freq, A_lc,'r');
hold off;

